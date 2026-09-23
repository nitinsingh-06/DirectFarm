from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.firebase import verify_firebase_token

from app.models.user import User
from app.models.product import Product
from app.models.cart import Cart, CartItem
from app.models.farmer_profile import FarmerProfile

from app.schemas.cart import (
    CartItemCreate,
    CartItemUpdate,
    CartItemResponse,
)

router = APIRouter(
    prefix="/cart",
    tags=["Cart"],
)


# ============================================================
# ADD ITEM TO CART
# ============================================================

@router.post(
    "/items",
    response_model=CartItemResponse,
)
def add_cart_item(
    data: CartItemCreate,
    id_token: str,
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
            detail="Only buyers can use cart",
        )

    # --------------------------------------------------------
    # FIND PRODUCT
    # --------------------------------------------------------

    product = (
        db.query(Product)
        .filter(
            Product.product_id == data.product_id
        )
        .first()
    )

    if not product:
        raise HTTPException(
            status_code=404,
            detail="Product not found",
        )

    # --------------------------------------------------------
    # CHECK AVAILABILITY
    # --------------------------------------------------------

    if product.is_available is False:
        raise HTTPException(
            status_code=400,
            detail="Product is currently unavailable",
        )

    if data.quantity > float(
        product.quantity_available
    ):
        raise HTTPException(
            status_code=400,
            detail="Requested quantity is not available",
        )

    # --------------------------------------------------------
    # FIND FARMER
    # --------------------------------------------------------

    farmer = (
        db.query(FarmerProfile)
        .filter(
            FarmerProfile.farmer_id
            == product.farmer_id
        )
        .first()
    )

    if not farmer:
        raise HTTPException(
            status_code=404,
            detail="Farmer profile not found",
        )

    # --------------------------------------------------------
    # FIND OR CREATE CART
    # --------------------------------------------------------

    cart = (
        db.query(Cart)
        .filter(
            Cart.user_id == user.user_id
        )
        .first()
    )

    if not cart:
        cart = Cart(
            user_id=user.user_id,
        )

        db.add(cart)
        db.flush()

    # --------------------------------------------------------
    # CHECK EXISTING CART ITEM
    # --------------------------------------------------------

    cart_item = (
        db.query(CartItem)
        .filter(
            CartItem.cart_id == cart.cart_id,
            CartItem.product_id == product.product_id,
        )
        .first()
    )

    # ========================================================
    # EXISTING ITEM
    # ========================================================

    if cart_item:

        new_quantity = (
            cart_item.quantity
            + data.quantity
        )

        if new_quantity > float(
            product.quantity_available
        ):
            raise HTTPException(
                status_code=400,
                detail="Requested quantity exceeds available stock",
            )

        cart_item.quantity = new_quantity

        # Update product snapshot
        cart_item.name = product.name
        cart_item.price = product.price
        cart_item.unit = product.unit
        cart_item.image_url = product.image_url

        cart_item.farm = getattr(
            farmer,
            "farm_name",
            None,
        )

        cart_item.location = getattr(
            farmer,
            "farm_location",
            None,
        )

    # ========================================================
    # NEW ITEM
    # ========================================================

    else:

        cart_item = CartItem(
            cart_id=cart.cart_id,
            product_id=product.product_id,

            name=product.name,
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

            quantity=data.quantity,
        )

        db.add(cart_item)

    # --------------------------------------------------------
    # SAVE
    # --------------------------------------------------------

    db.commit()
    db.refresh(cart_item)

    return cart_item


# ============================================================
# GET MY CART
# ============================================================

@router.get(
    "/me",
    response_model=list[CartItemResponse],
)
def get_my_cart(
    id_token: str,
    db: Session = Depends(get_db),
):

    # --------------------------------------------------------
    # VERIFY TOKEN
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

    if user.role != "buyer":
        raise HTTPException(
            status_code=403,
            detail="Only buyers can access cart",
        )

    # --------------------------------------------------------
    # FIND CART
    # --------------------------------------------------------

    cart = (
        db.query(Cart)
        .filter(
            Cart.user_id == user.user_id
        )
        .first()
    )

    if not cart:
        return []

    # --------------------------------------------------------
    # GET ITEMS
    # --------------------------------------------------------

    cart_items = (
        db.query(CartItem)
        .filter(
            CartItem.cart_id == cart.cart_id
        )
        .all()
    )

    return cart_items


# ============================================================
# UPDATE CART ITEM
# ============================================================

@router.patch(
    "/items/{cart_item_id}",
    response_model=CartItemResponse,
)
def update_cart_item(
    cart_item_id: int,
    data: CartItemUpdate,
    id_token: str,
    db: Session = Depends(get_db),
):

    # --------------------------------------------------------
    # VERIFY TOKEN
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
    # FIND CART
    # --------------------------------------------------------

    cart = (
        db.query(Cart)
        .filter(
            Cart.user_id == user.user_id
        )
        .first()
    )

    if not cart:
        raise HTTPException(
            status_code=404,
            detail="Cart not found",
        )

    # --------------------------------------------------------
    # FIND CART ITEM
    # --------------------------------------------------------

    cart_item = (
        db.query(CartItem)
        .filter(
            CartItem.cart_item_id
            == cart_item_id,
            CartItem.cart_id
            == cart.cart_id,
        )
        .first()
    )

    if not cart_item:
        raise HTTPException(
            status_code=404,
            detail="Cart item not found",
        )

    # --------------------------------------------------------
    # CHECK PRODUCT STOCK
    # --------------------------------------------------------

    product = (
        db.query(Product)
        .filter(
            Product.product_id
            == cart_item.product_id
        )
        .first()
    )

    if not product:
        raise HTTPException(
            status_code=404,
            detail="Product not found",
        )

    if data.quantity > float(
        product.quantity_available
    ):
        raise HTTPException(
            status_code=400,
            detail="Requested quantity exceeds available stock",
        )

    # --------------------------------------------------------
    # UPDATE
    # --------------------------------------------------------

    cart_item.quantity = data.quantity

    db.commit()
    db.refresh(cart_item)

    return cart_item


# ============================================================
# REMOVE CART ITEM
# ============================================================

@router.delete(
    "/items/{cart_item_id}"
)
def remove_cart_item(
    cart_item_id: int,
    id_token: str,
    db: Session = Depends(get_db),
):

    # --------------------------------------------------------
    # VERIFY TOKEN
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
    # FIND CART
    # --------------------------------------------------------

    cart = (
        db.query(Cart)
        .filter(
            Cart.user_id == user.user_id
        )
        .first()
    )

    if not cart:
        raise HTTPException(
            status_code=404,
            detail="Cart not found",
        )

    # --------------------------------------------------------
    # FIND ITEM
    # --------------------------------------------------------

    cart_item = (
        db.query(CartItem)
        .filter(
            CartItem.cart_item_id
            == cart_item_id,
            CartItem.cart_id
            == cart.cart_id,
        )
        .first()
    )

    if not cart_item:
        raise HTTPException(
            status_code=404,
            detail="Cart item not found",
        )

    # --------------------------------------------------------
    # DELETE
    # --------------------------------------------------------

    db.delete(cart_item)
    db.commit()

    return {
        "message": "Cart item removed successfully"
    }


# ============================================================
# CLEAR CART
# ============================================================

@router.delete("/me")
def clear_my_cart(
    id_token: str,
    db: Session = Depends(get_db),
):

    # --------------------------------------------------------
    # VERIFY TOKEN
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
    # FIND CART
    # --------------------------------------------------------

    cart = (
        db.query(Cart)
        .filter(
            Cart.user_id == user.user_id
        )
        .first()
    )

    if not cart:
        return {
            "message": "Cart is already empty"
        }

    # --------------------------------------------------------
    # DELETE ITEMS
    # --------------------------------------------------------

    db.query(CartItem).filter(
        CartItem.cart_id == cart.cart_id
    ).delete(
        synchronize_session=False
    )

    db.commit()

    return {
        "message": "Cart cleared successfully"
    }