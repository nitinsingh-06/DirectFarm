from decimal import Decimal
import traceback
import uuid

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.firebase import verify_firebase_token

from app.models.user import User
from app.models.cart import Cart, CartItem
from app.models.product import Product
from app.models.farmer_profile import FarmerProfile
from app.models.address import Address
from app.models.order import Order
from app.models.order_item import OrderItem
from app.models.payment import Payment


router = APIRouter(
    prefix="/orders",
    tags=["Orders"],
)


# ============================================================
# CREATE ORDER
# ============================================================

@router.post("/")
def create_order(
    address_id: int,
    payment_method: str,
    delivery_date: str | None = None,
    delivery_slot: str | None = None,
    delivery_instructions: str | None = None,
    id_token: str = "",
    db: Session = Depends(get_db),
):

    # --------------------------------------------------------
    # VERIFY FIREBASE TOKEN
    # --------------------------------------------------------

    try:
        decoded_token = verify_firebase_token(id_token)

    except Exception:
        raise HTTPException(
            status_code=401,
            detail="Invalid Firebase token",
        )

    firebase_uid = decoded_token.get("uid")

    if not firebase_uid:
        raise HTTPException(
            status_code=401,
            detail="Invalid Firebase token",
        )

    # --------------------------------------------------------
    # FIND USER
    # --------------------------------------------------------

    user = (
        db.query(User)
        .filter(User.firebase_uid == firebase_uid)
        .first()
    )

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found",
        )

    if user.role != "buyer":
        raise HTTPException(
            status_code=403,
            detail="Only buyers can place orders",
        )

    # --------------------------------------------------------
    # FIND ADDRESS
    # --------------------------------------------------------

    address = (
        db.query(Address)
        .filter(
            Address.address_id == address_id,
            Address.user_id == user.user_id,
        )
        .first()
    )

    if not address:
        raise HTTPException(
            status_code=404,
            detail="Delivery address not found",
        )

    # --------------------------------------------------------
    # FIND CART
    # --------------------------------------------------------

    cart = (
        db.query(Cart)
        .filter(Cart.user_id == user.user_id)
        .first()
    )

    if not cart:
        raise HTTPException(
            status_code=400,
            detail="Cart is empty",
        )

    cart_items = (
        db.query(CartItem)
        .filter(CartItem.cart_id == cart.cart_id)
        .all()
    )

    if not cart_items:
        raise HTTPException(
            status_code=400,
            detail="Cart is empty",
        )

    # --------------------------------------------------------
    # VALIDATE PAYMENT METHOD
    # --------------------------------------------------------

    allowed_payment_methods = {
        "UPI",
        "Credit / Debit Card",
        "Cash on Delivery",
        "Net Banking",
    }

    if payment_method not in allowed_payment_methods:
        raise HTTPException(
            status_code=400,
            detail="Invalid payment method",
        )

    # --------------------------------------------------------
    # CALCULATE ORDER
    # --------------------------------------------------------

    subtotal = 0

    validated_items = []

    for cart_item in cart_items:

        product = (
            db.query(Product)
            .filter(
                Product.product_id == cart_item.product_id
            )
            .first()
        )

        if not product:
            raise HTTPException(
                status_code=404,
                detail=f"Product not found: {cart_item.product_id}",
            )

        if product.is_available is False:
            raise HTTPException(
                status_code=400,
                detail=f"{product.name} is currently unavailable",
            )

        if cart_item.quantity > float(
            product.quantity_available
        ):
            raise HTTPException(
                status_code=400,
                detail=(
                    f"Only {product.quantity_available} "
                    f"{product.unit} of {product.name} is available"
                ),
            )

        farmer = (
            db.query(FarmerProfile)
            .filter(
                FarmerProfile.farmer_id == product.farmer_id
            )
            .first()
        )

        if not farmer:
            raise HTTPException(
                status_code=404,
                detail=f"Farmer not found for {product.name}",
            )

        item_total = (
            float(product.price) * cart_item.quantity
        )

        subtotal += item_total

        validated_items.append(
            {
                "product": product,
                "farmer": farmer,
                "cart_item": cart_item,
                "item_total": item_total,
            }
        )

    # --------------------------------------------------------
    # CHARGES
    # --------------------------------------------------------

    delivery_fee = 40
    platform_fee = 10
    discount = 0

    total_amount = (
        subtotal
        + delivery_fee
        + platform_fee
        - discount
    )

    # --------------------------------------------------------
    # GENERATE ORDER NUMBER
    # --------------------------------------------------------

    order_number = (
        "FD-"
        + uuid.uuid4().hex[:10].upper()
    )

    # --------------------------------------------------------
    # CREATE ORDER
    # --------------------------------------------------------

    order = Order(
        order_number=order_number,
        user_id=user.user_id,
        address_id=address.address_id,
        status="processing",
        subtotal=subtotal,
        delivery_fee=delivery_fee,
        discount=discount,
        total_amount=total_amount,
        payment_method=payment_method,
        payment_status="Pending",
        note=(
            f"Delivery: {delivery_date or ''} "
            f"{delivery_slot or ''}. "
            f"{delivery_instructions or ''}"
        ).strip(),
    )

    db.add(order)

    # Get order_id before creating order items/payment
    db.flush()

    # --------------------------------------------------------
    # CREATE ORDER ITEMS
    # --------------------------------------------------------

    for item in validated_items:

        product = item["product"]
        farmer = item["farmer"]
        cart_item = item["cart_item"]

        order_item = OrderItem(
            order_id=order.order_id,
            product_id=product.product_id,
            farmer_id=product.farmer_id,
            product_name=product.name,
            price=product.price,
            unit=product.unit,
            image_url=product.image_url,
            farm=getattr(
                farmer,
                "farm_name",
                None,
            ),
            location=getattr(
                farmer,
                "farm_location",
                None,
            ),
            quantity=cart_item.quantity,
            total_price=item["item_total"],
        )

        db.add(order_item)

        # ----------------------------------------------------
        # REDUCE PRODUCT STOCK
        # ----------------------------------------------------

        product.quantity_available = (
            float(product.quantity_available)
            - cart_item.quantity
        )

        if product.quantity_available <= 0:
            product.quantity_available = 0
            product.is_available = False

    # --------------------------------------------------------
    # CREATE PAYMENT
    # --------------------------------------------------------

    payment_method_map = {
        "UPI": "upi",
        "Credit / Debit Card": "card",
        "Cash on Delivery": "cod",
        "Net Banking": "netbanking",
    }

    db_payment_method = payment_method_map.get(
        payment_method
    )

    if db_payment_method is None:
        raise HTTPException(
            status_code=400,
            detail=f"Unsupported payment method: {payment_method}",
        )

    payment = Payment(
        order_id=order.order_id,
        amount=total_amount,
        method=db_payment_method,
        status="pending",
        transaction_id=None,
        provider=None,
        note=None,
        paid_at=None,
    )

    db.add(payment)

    # --------------------------------------------------------
    # CLEAR CART
    # --------------------------------------------------------

    db.query(CartItem).filter(
        CartItem.cart_id == cart.cart_id
    ).delete(
        synchronize_session=False
    )

    # ========================================================
    # SAVE EVERYTHING
    # ========================================================

    try:

        db.commit()

        db.refresh(order)

    except Exception as e:

        db.rollback()

        print("====================================")
        print("CREATE ORDER DATABASE ERROR")
        print("====================================")

        traceback.print_exc()

        print("====================================")

        raise HTTPException(
            status_code=500,
            detail=f"Failed to create order: {str(e)}",
        )

    # ========================================================
    # RESPONSE
    # ========================================================

    return {
        "message": "Order placed successfully",
        "order_id": order.order_id,
        "order_number": order.order_number,
        "status": order.status,
        "subtotal": float(order.subtotal),
        "delivery_fee": float(order.delivery_fee),
        "platform_fee": platform_fee,
        "discount": float(order.discount),
        "total_amount": float(order.total_amount),
        "payment_method": order.payment_method,
        "payment_status": order.payment_status,
        "delivery_date": delivery_date,
        "delivery_slot": delivery_slot,
    }

# ============================================================
# GET FARMER ORDERS
# ============================================================
@router.get("/farmer/my-orders")
def get_farmer_orders(
    id_token: str = "",
    db: Session = Depends(get_db),
):
    # --------------------------------------------------
    # 1. Verify Firebase token
    # --------------------------------------------------
    try:
        decoded_token = verify_firebase_token(id_token)

        print("========================================")
        print("FIREBASE TOKEN VERIFIED")
        print("UID:", decoded_token.get("uid"))
        print("EMAIL:", decoded_token.get("email"))
        print("========================================")

    except Exception as e:
        print("========================================")
        print("FIREBASE TOKEN VERIFICATION FAILED")
        print("ERROR TYPE:", type(e).__name__)
        print("ERROR:", repr(e))
        print("========================================")

        raise HTTPException(
            status_code=401,
            detail="Invalid Firebase token",
        )
        
    firebase_uid = decoded_token.get("uid")

    if not firebase_uid:
        raise HTTPException(
            status_code=401,
            detail="Invalid Firebase token",
        )

    # --------------------------------------------------
    # 2. Find user
    # --------------------------------------------------
    user = (
        db.query(User)
        .filter(User.firebase_uid == firebase_uid)
        .first()
    )

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found",
        )

    # --------------------------------------------------
    # 3. Check farmer role
    # --------------------------------------------------
    if user.role != "farmer":
        raise HTTPException(
            status_code=403,
            detail="Only farmers can view farmer orders",
        )

    # --------------------------------------------------
    # 4. Find farmer profile
    # --------------------------------------------------
    farmer = (
        db.query(FarmerProfile)
        .filter(
            FarmerProfile.user_id == user.user_id
        )
        .first()
    )

    if not farmer:
        raise HTTPException(
            status_code=404,
            detail="Farmer profile not found",
        )

    # --------------------------------------------------
    # 5. Get this farmer's order items
    #
    # IMPORTANT:
    # OrderItem does not have created_at.
    # So we order by order_item_id instead.
    # --------------------------------------------------
    order_items = (
        db.query(OrderItem)
        .filter(
            OrderItem.farmer_id == farmer.farmer_id
        )
        .order_by(
            OrderItem.order_item_id.desc()
        )
        .all()
    )

    # --------------------------------------------------
    # 6. Prepare response
    # --------------------------------------------------
    result = []

    for item in order_items:

        # Find parent order
        order = (
            db.query(Order)
            .filter(
                Order.order_id == item.order_id
            )
            .first()
        )

        if not order:
            continue

        # Find buyer
        buyer = (
            db.query(User)
            .filter(
                User.user_id == order.user_id
            )
            .first()
        )

        result.append({
    "order_id": order.order_id,
    "order_number": order.order_number,

    "order_item_id": item.order_item_id,
    "product_id": item.product_id,

    "product_name": item.product_name,
    "price": float(item.price),
    "unit": item.unit,
    "quantity": item.quantity,

    "total_price": float(item.price) * int(item.quantity),

    "image_url": item.image_url,
    "farm": item.farm,
    "location": item.location,

    "buyer_name": (
        buyer.name
        if buyer
        else "Unknown Buyer"
    ),

    "buyer_phone": (
        buyer.phone
        if buyer
        else None
    ),

    "address_id": order.address_id,

    "status": item.status,

    "payment_method": order.payment_method,
    "payment_status": order.payment_status,

    "delivery_fee": float(
        order.delivery_fee or 0
    ),

    "discount": float(
        order.discount or 0
    ),

    "total_amount": float(
        order.total_amount or 0
    ),

    "created_at": (
        order.created_at.isoformat()
        if order.created_at
        else None
    ),

    "updated_at": (
        order.updated_at.isoformat()
        if order.updated_at
        else None
    ),
})

    # --------------------------------------------------
    # 7. Return response
    # --------------------------------------------------
    return {
        "message": "Farmer orders fetched successfully",
        "count": len(result),
        "orders": result,
        
    }
    
    
        
# ============================================================
# FARMER ACCEPT ORDER
# ============================================================

@router.post("/farmer/{order_item_id}/accept")
def accept_farmer_order(
    order_item_id: int,
    id_token: str = "",
    db: Session = Depends(get_db),
):
    # --------------------------------------------------------
    # VERIFY FIREBASE TOKEN
    # --------------------------------------------------------
    try:
        decoded_token = verify_firebase_token(id_token)
    except Exception:
        raise HTTPException(
            status_code=401,
            detail="Invalid Firebase token",
        )

    firebase_uid = decoded_token.get("uid")

    if not firebase_uid:
        raise HTTPException(
            status_code=401,
            detail="Invalid Firebase token",
        )

    # --------------------------------------------------------
    # FIND USER
    # --------------------------------------------------------
    user = (
        db.query(User)
        .filter(User.firebase_uid == firebase_uid)
        .first()
    )

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found",
        )

    # --------------------------------------------------------
    # ONLY FARMERS
    # --------------------------------------------------------
    if user.role != "farmer":
        raise HTTPException(
            status_code=403,
            detail="Only farmers can accept orders",
        )

    # --------------------------------------------------------
    # FIND FARMER PROFILE
    # --------------------------------------------------------
    farmer = (
        db.query(FarmerProfile)
        .filter(FarmerProfile.user_id == user.user_id)
        .first()
    )

    if not farmer:
        raise HTTPException(
            status_code=404,
            detail="Farmer profile not found",
        )

    # --------------------------------------------------------
    # FIND ORDER ITEM
    # --------------------------------------------------------
    order_item = (
        db.query(OrderItem)
        .filter(
            OrderItem.order_item_id == order_item_id,
            OrderItem.farmer_id == farmer.farmer_id,
        )
        .first()
    )

    if not order_item:
        raise HTTPException(
            status_code=404,
            detail="Order item not found",
        )

    # --------------------------------------------------------
    # CHECK STATUS
    # --------------------------------------------------------
    current_status = (
        order_item.status or "pending"
    ).lower()

    if current_status != "pending":
        raise HTTPException(
            status_code=400,
            detail=f"Order cannot be accepted because it is already {current_status}",
        )

    # --------------------------------------------------------
    # ACCEPT
    # --------------------------------------------------------
    order_item.status = "confirmed"

    try:
        db.commit()
        db.refresh(order_item)

    except Exception as e:
        db.rollback()

        raise HTTPException(
            status_code=500,
            detail=f"Failed to accept order: {str(e)}",
        )

    return {
        "message": "Order accepted successfully",
        "order_item_id": order_item.order_item_id,
        "status": order_item.status,
    }


# ============================================================
# FARMER REJECT ORDER
# ============================================================

@router.post("/farmer/{order_item_id}/reject")
def reject_farmer_order(
    order_item_id: int,
    id_token: str = "",
    db: Session = Depends(get_db),
):
    # --------------------------------------------------------
    # VERIFY FIREBASE TOKEN
    # --------------------------------------------------------
    try:
        decoded_token = verify_firebase_token(id_token)
    except Exception:
        raise HTTPException(
            status_code=401,
            detail="Invalid Firebase token",
        )

    firebase_uid = decoded_token.get("uid")

    if not firebase_uid:
        raise HTTPException(
            status_code=401,
            detail="Invalid Firebase token",
        )

    # --------------------------------------------------------
    # FIND USER
    # --------------------------------------------------------
    user = (
        db.query(User)
        .filter(User.firebase_uid == firebase_uid)
        .first()
    )

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found",
        )

    # --------------------------------------------------------
    # ONLY FARMERS
    # --------------------------------------------------------
    if user.role != "farmer":
        raise HTTPException(
            status_code=403,
            detail="Only farmers can reject orders",
        )

    # --------------------------------------------------------
    # FIND FARMER PROFILE
    # --------------------------------------------------------
    farmer = (
        db.query(FarmerProfile)
        .filter(FarmerProfile.user_id == user.user_id)
        .first()
    )

    if not farmer:
        raise HTTPException(
            status_code=404,
            detail="Farmer profile not found",
        )

    # --------------------------------------------------------
    # FIND ORDER ITEM
    # --------------------------------------------------------
    order_item = (
        db.query(OrderItem)
        .filter(
            OrderItem.order_item_id == order_item_id,
            OrderItem.farmer_id == farmer.farmer_id,
        )
        .first()
    )

    if not order_item:
        raise HTTPException(
            status_code=404,
            detail="Order item not found",
        )

    # --------------------------------------------------------
    # CHECK STATUS
    # --------------------------------------------------------
    current_status = (
        order_item.status or "pending"
    ).lower()

    if current_status != "pending":
        raise HTTPException(
            status_code=400,
            detail=f"Order cannot be rejected because it is already {current_status}",
        )

    # --------------------------------------------------------
    # REJECT
    # --------------------------------------------------------
    order_item.status = "rejected"

    try:
        db.commit()
        db.refresh(order_item)

    except Exception as e:
        db.rollback()

        raise HTTPException(
            status_code=500,
            detail=f"Failed to reject order: {str(e)}",
        )

    return {
        "message": "Order rejected successfully",
        "order_item_id": order_item.order_item_id,
        "status": order_item.status,
    }
    
    
    # ============================================================
# FARMER MARK ORDER AS SHIPPED
# ============================================================

@router.post("/farmer/{order_item_id}/ship")
def ship_farmer_order(
    order_item_id: int,
    id_token: str = "",
    db: Session = Depends(get_db),
):
    try:
        decoded_token = verify_firebase_token(id_token)
    except Exception:
        raise HTTPException(
            status_code=401,
            detail="Invalid Firebase token",
        )

    firebase_uid = decoded_token.get("uid")

    if not firebase_uid:
        raise HTTPException(
            status_code=401,
            detail="Invalid Firebase token",
        )

    user = (
        db.query(User)
        .filter(User.firebase_uid == firebase_uid)
        .first()
    )

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found",
        )

    if user.role != "farmer":
        raise HTTPException(
            status_code=403,
            detail="Only farmers can ship orders",
        )

    farmer = (
        db.query(FarmerProfile)
        .filter(FarmerProfile.user_id == user.user_id)
        .first()
    )

    if not farmer:
        raise HTTPException(
            status_code=404,
            detail="Farmer profile not found",
        )

    order_item = (
        db.query(OrderItem)
        .filter(
            OrderItem.order_item_id == order_item_id,
            OrderItem.farmer_id == farmer.farmer_id,
        )
        .first()
    )

    if not order_item:
        raise HTTPException(
            status_code=404,
            detail="Order item not found",
        )

    current_status = (
        order_item.status or "pending"
    ).lower()

    if current_status != "confirmed":
        raise HTTPException(
            status_code=400,
            detail=(
                "Order can only be marked as shipped "
                f"when it is confirmed. Current status: {current_status}"
            ),
        )

    order_item.status = "shipped"

    try:
        db.commit()
        db.refresh(order_item)
    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=500,
            detail=f"Failed to mark order as shipped: {str(e)}",
        )

    return {
        "message": "Order marked as shipped successfully",
        "order_item_id": order_item.order_item_id,
        "status": order_item.status,
    }