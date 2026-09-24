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
# GET BUYER ORDERS
# ============================================================

@router.get("/me")
def get_my_orders(
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
    # ONLY BUYERS
    # --------------------------------------------------------

    if user.role != "buyer":
        raise HTTPException(
            status_code=403,
            detail="Only buyers can view buyer orders",
        )

    # --------------------------------------------------------
    # FETCH ORDERS
    # --------------------------------------------------------

    orders = (
        db.query(Order)
        .filter(Order.user_id == user.user_id)
        .order_by(Order.created_at.desc())
        .all()
    )

    # --------------------------------------------------------
    # BUILD RESPONSE
    # --------------------------------------------------------

    result = []

    for order in orders:

        order_items = (
            db.query(OrderItem)
            .filter(
                OrderItem.order_id == order.order_id
            )
            .all()
        )

        items = []

        for item in order_items:

            items.append(
                {
                    "order_item_id": item.order_item_id,
                    "product_id": item.product_id,
                    "farmer_id": item.farmer_id,
                    "product_name": item.product_name,
                    "price": float(item.price),
                    "unit": item.unit,
                    "image_url": item.image_url,
                    "farm": item.farm,
                    "location": item.location,
                    "quantity": item.quantity,
                    "total_price": float(item.total_price),
                }
            )

        # ----------------------------------------------------
        # ADD ORDER
        # ----------------------------------------------------

        result.append(
            {
                "order_id": order.order_id,
                "order_number": order.order_number,
                "status": order.status,
                "subtotal": float(order.subtotal),
                "delivery_fee": float(order.delivery_fee),
                "discount": float(order.discount),
                "total_amount": float(order.total_amount),
                "payment_method": order.payment_method,
                "payment_status": order.payment_status,
                "note": order.note,
                "address_id": order.address_id,
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
                "delivery_date": None,
                "delivery_slot": None,
                "items": items,
            }
        )

    # --------------------------------------------------------
    # RESPONSE
    # --------------------------------------------------------

    return {
        "message": "Orders fetched successfully",
        "count": len(result),
        "orders": result,
    }


# ============================================================
# CANCEL MY ORDER
# ============================================================

@router.post("/{order_id}/cancel")
def cancel_my_order(
    order_id: int,
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
        .filter(
            User.firebase_uid == firebase_uid
        )
        .first()
    )

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found",
        )

    # --------------------------------------------------------
    # ONLY BUYERS
    # --------------------------------------------------------

    if user.role != "buyer":
        raise HTTPException(
            status_code=403,
            detail="Only buyers can cancel orders",
        )

    # --------------------------------------------------------
    # FIND ORDER
    # --------------------------------------------------------

    order = (
        db.query(Order)
        .filter(
            Order.order_id == order_id,
            Order.user_id == user.user_id,
        )
        .first()
    )

    if not order:
        raise HTTPException(
            status_code=404,
            detail="Order not found",
        )

    # --------------------------------------------------------
    # CHECK ORDER STATUS
    # --------------------------------------------------------

    current_status = (
        order.status or ""
    ).lower()

    if current_status == "cancelled":
        raise HTTPException(
            status_code=400,
            detail="Order is already cancelled",
        )

    if current_status != "processing":
        raise HTTPException(
            status_code=400,
            detail="Only processing orders can be cancelled",
        )

    # --------------------------------------------------------
    # GET ORDER ITEMS
    # --------------------------------------------------------

    order_items = (
        db.query(OrderItem)
        .filter(
            OrderItem.order_id == order.order_id
        )
        .all()
    )

    # --------------------------------------------------------
    # RESTORE PRODUCT STOCK
    # --------------------------------------------------------

    for item in order_items:

        if item.product_id is None:
            continue

        product = (
            db.query(Product)
            .filter(
                Product.product_id == item.product_id
            )
            .first()
        )

        if not product:
            continue

        # PostgreSQL NUMERIC values are Decimal.
        # Keep the calculation as Decimal instead
        # of mixing float + Decimal.

        current_quantity = (
            product.quantity_available
            or Decimal("0")
        )

        item_quantity = (
            item.quantity
            or 0
        )

        product.quantity_available = (
            current_quantity
            + Decimal(str(item_quantity))
        )

        # Product becomes available again
        # when stock is greater than zero.

        product.is_available = (
            product.quantity_available
            > Decimal("0")
        )

    # --------------------------------------------------------
    # UPDATE ORDER
    # --------------------------------------------------------

    order.status = "cancelled"

    # --------------------------------------------------------
    # UPDATE PAYMENT IF NECESSARY
    # --------------------------------------------------------

    payment = (
        db.query(Payment)
        .filter(
            Payment.order_id == order.order_id
        )
        .first()
    )

    if payment:

        payment_status = (
            payment.status or ""
        ).lower()

        # If payment was already completed,
        # mark payment as refunded.

        if payment_status == "paid":

            payment.status = "refunded"

            # Keep order payment status synchronized.

            order.payment_status = "Refunded"

        # For pending payment / COD,
        # no money has been paid yet.
        #
        # Therefore payment remains Pending.

    # --------------------------------------------------------
    # SAVE
    # --------------------------------------------------------

    try:

        db.commit()

        db.refresh(order)

    except Exception as e:

        db.rollback()

        print("====================================")
        print("CANCEL ORDER DATABASE ERROR")
        print("====================================")
        print(str(e))
        traceback.print_exc()
        print("====================================")

        raise HTTPException(
            status_code=500,
            detail=f"Failed to cancel order: {str(e)}",
        )

    # --------------------------------------------------------
    # RESPONSE
    # --------------------------------------------------------

    return {
        "message": "Order cancelled successfully",
        "order_id": order.order_id,
        "order_number": order.order_number,
        "status": order.status,
        "payment_status": order.payment_status,
    }