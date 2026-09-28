from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from ..database import get_db
from ..firebase import verify_firebase_token

from ..models.user import User
from ..models.farmer_profile import FarmerProfile
from ..models.product import Product
from ..models.category import Category

from ..schemas.product import (
    ProductCreate,
    ProductUpdate,
    ProductResponse,
    ProductStockUpdate,
    ProductAvailabilityUpdate,
)


router = APIRouter(
    prefix="/products",
    tags=["Products"],
)


# ============================================================
# HELPER
# GET CURRENT FARMER
# ============================================================

def get_current_farmer(
    id_token: str,
    db: Session,
):
    try:
        decoded_token = verify_firebase_token(id_token)

        firebase_uid = decoded_token["uid"]

        user = (
            db.query(User)
            .filter(
                User.firebase_uid == firebase_uid
            )
            .first()
        )

        if user is None:
            raise HTTPException(
                status_code=404,
                detail="User not found",
            )

        if user.role != "farmer":
            raise HTTPException(
                status_code=403,
                detail="Only farmers can access this endpoint",
            )

        farmer_profile = (
            db.query(FarmerProfile)
            .filter(
                FarmerProfile.user_id == user.user_id
            )
            .first()
        )

        if farmer_profile is None:
            raise HTTPException(
                status_code=404,
                detail="Farmer profile not found",
            )

        return user, farmer_profile

    except ValueError as e:
        raise HTTPException(
            status_code=401,
            detail=str(e),
        )


# ============================================================
# CREATE PRODUCT
# FARMER ONLY
# ============================================================

@router.post(
    "",
    response_model=ProductResponse,
)
def create_product(
    data: ProductCreate,
    id_token: str,
    db: Session = Depends(get_db),
):

    _, farmer_profile = get_current_farmer(
        id_token,
        db,
    )

    # --------------------------------------------------------
    # CHECK CATEGORY
    # --------------------------------------------------------

    category = (
        db.query(Category)
        .filter(
            Category.category_id == data.category_id
        )
        .first()
    )

    if category is None:
        raise HTTPException(
            status_code=404,
            detail="Category not found",
        )

    # --------------------------------------------------------
    # CREATE
    # --------------------------------------------------------

    product = Product(
        farmer_id=farmer_profile.farmer_id,
        category_id=data.category_id,
        name=data.name,
        description=data.description,
        price=data.price,
        unit=data.unit,
        quantity_available=data.quantity_available,
        image_url=data.image_url,
        is_available=True,
    )

    db.add(product)
    db.commit()
    db.refresh(product)

    return product


# ============================================================
# GET MY PRODUCTS
# FARMER ONLY
# ============================================================

@router.get(
    "/my-products",
    response_model=list[ProductResponse],
)
def get_my_products(
    id_token: str,
    db: Session = Depends(get_db),
):

    _, farmer_profile = get_current_farmer(
        id_token,
        db,
    )

    products = (
        db.query(Product)
        .filter(
            Product.farmer_id ==
            farmer_profile.farmer_id
        )
        .order_by(
            Product.created_at.desc()
        )
        .all()
    )

    return products


# ============================================================
# GET SINGLE PRODUCT
# FARMER ONLY
# ============================================================

@router.get(
    "/{product_id}",
    response_model=ProductResponse,
)
def get_product(
    product_id: int,
    id_token: str,
    db: Session = Depends(get_db),
):

    _, farmer_profile = get_current_farmer(
        id_token,
        db,
    )

    product = (
        db.query(Product)
        .filter(
            Product.product_id == product_id,
            Product.farmer_id ==
            farmer_profile.farmer_id,
        )
        .first()
    )

    if product is None:
        raise HTTPException(
            status_code=404,
            detail="Product not found",
        )

    return product


# ============================================================
# UPDATE PRODUCT
# PUT
# FARMER ONLY
# ============================================================

@router.put(
    "/{product_id}",
    response_model=ProductResponse,
)
def update_product(
    product_id: int,
    data: ProductUpdate,
    id_token: str,
    db: Session = Depends(get_db),
):

    _, farmer_profile = get_current_farmer(
        id_token,
        db,
    )

    # --------------------------------------------------------
    # FIND PRODUCT
    # --------------------------------------------------------

    product = (
        db.query(Product)
        .filter(
            Product.product_id == product_id,
            Product.farmer_id ==
            farmer_profile.farmer_id,
        )
        .first()
    )

    if product is None:
        raise HTTPException(
            status_code=404,
            detail="Product not found",
        )

    # --------------------------------------------------------
    # CHECK CATEGORY
    # --------------------------------------------------------

    if data.category_id is not None:

        category = (
            db.query(Category)
            .filter(
                Category.category_id ==
                data.category_id
            )
            .first()
        )

        if category is None:
            raise HTTPException(
                status_code=404,
                detail="Category not found",
            )

        product.category_id = data.category_id

    # --------------------------------------------------------
    # UPDATE FIELDS
    # --------------------------------------------------------

    if data.name is not None:
        product.name = data.name

    if data.description is not None:
        product.description = data.description

    if data.price is not None:
        product.price = data.price

    if data.unit is not None:
        product.unit = data.unit

    if data.quantity_available is not None:
        product.quantity_available = (
            data.quantity_available
        )

    if data.image_url is not None:
        product.image_url = data.image_url

    # --------------------------------------------------------
    # SAVE
    # --------------------------------------------------------

    db.commit()
    db.refresh(product)

    return product


# ============================================================
# UPDATE STOCK
# PATCH
# FARMER ONLY
# ============================================================

@router.patch(
    "/{product_id}/stock",
    response_model=ProductResponse,
)
def update_product_stock(
    product_id: int,
    data: ProductStockUpdate,
    id_token: str,
    db: Session = Depends(get_db),
):

    _, farmer_profile = get_current_farmer(
        id_token,
        db,
    )

    product = (
        db.query(Product)
        .filter(
            Product.product_id == product_id,
            Product.farmer_id ==
            farmer_profile.farmer_id,
        )
        .first()
    )

    if product is None:
        raise HTTPException(
            status_code=404,
            detail="Product not found",
        )

    product.quantity_available = (
        data.quantity_available
    )

    # Automatically unavailable when stock is 0
    if data.quantity_available <= 0:
        product.is_available = False
    else:
        product.is_available = True

    db.commit()
    db.refresh(product)

    return product


# ============================================================
# UPDATE AVAILABILITY
# PATCH
# FARMER ONLY
# ============================================================

@router.patch(
    "/{product_id}/availability",
    response_model=ProductResponse,
)
def update_product_availability(
    product_id: int,
    data: ProductAvailabilityUpdate,
    id_token: str,
    db: Session = Depends(get_db),
):

    _, farmer_profile = get_current_farmer(
        id_token,
        db,
    )

    product = (
        db.query(Product)
        .filter(
            Product.product_id == product_id,
            Product.farmer_id ==
            farmer_profile.farmer_id,
        )
        .first()
    )

    if product is None:
        raise HTTPException(
            status_code=404,
            detail="Product not found",
        )

    # Do not allow availability ON when stock is zero
    if (
        data.is_available
        and product.quantity_available <= 0
    ):
        raise HTTPException(
            status_code=400,
            detail="Cannot make product available because stock is zero",
        )

    product.is_available = data.is_available

    db.commit()
    db.refresh(product)

    return product


# ============================================================
# DUPLICATE PRODUCT
# POST
# FARMER ONLY
# ============================================================

@router.post(
    "/{product_id}/duplicate",
    response_model=ProductResponse,
)
def duplicate_product(
    product_id: int,
    id_token: str,
    db: Session = Depends(get_db),
):

    _, farmer_profile = get_current_farmer(
        id_token,
        db,
    )

    # --------------------------------------------------------
    # FIND ORIGINAL
    # --------------------------------------------------------

    original = (
        db.query(Product)
        .filter(
            Product.product_id == product_id,
            Product.farmer_id ==
            farmer_profile.farmer_id,
        )
        .first()
    )

    if original is None:
        raise HTTPException(
            status_code=404,
            detail="Product not found",
        )

    # --------------------------------------------------------
    # CREATE COPY
    # --------------------------------------------------------

    duplicate = Product(
        farmer_id=original.farmer_id,
        category_id=original.category_id,
        name=f"{original.name} Copy",
        description=original.description,
        price=original.price,
        unit=original.unit,
        quantity_available=original.quantity_available,
        image_url=original.image_url,
        is_available=False,
    )

    db.add(duplicate)
    db.commit()
    db.refresh(duplicate)

    return duplicate


# ============================================================
# DELETE PRODUCT
# DELETE
# FARMER ONLY
# ============================================================

@router.delete(
    "/{product_id}",
)
def delete_product(
    product_id: int,
    id_token: str,
    db: Session = Depends(get_db),
):

    _, farmer_profile = get_current_farmer(
        id_token,
        db,
    )

    # --------------------------------------------------------
    # FIND PRODUCT
    # --------------------------------------------------------

    product = (
        db.query(Product)
        .filter(
            Product.product_id == product_id,
            Product.farmer_id ==
            farmer_profile.farmer_id,
        )
        .first()
    )

    if product is None:
        raise HTTPException(
            status_code=404,
            detail="Product not found",
        )

    # --------------------------------------------------------
    # DELETE
    # --------------------------------------------------------

    db.delete(product)
    db.commit()

    return {
        "message": "Product deleted successfully",
        "product_id": product_id,
    }


# ============================================================
# GET ALL PRODUCTS
# BUYER HOME
# ============================================================

@router.get(
    "",
    response_model=list[ProductResponse],
)
def get_all_products(
    db: Session = Depends(get_db),
):

    try:

        products = (
            db.query(Product)
            .filter(
                Product.is_available == True
            )
            .order_by(
                Product.created_at.desc()
            )
            .all()
        )

        return products

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=f"Failed to fetch products: {str(e)}",
        )