from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from ..database import get_db
from ..firebase import verify_firebase_token

from ..models.user import User
from ..models.farmer_profile import FarmerProfile
from ..models.product import Product

from ..schemas.product import (
    ProductCreate,
    ProductResponse,
)


router = APIRouter(
    prefix="/products",
    tags=["Products"]
)


# ============================================================
# CREATE PRODUCT
# FARMER ONLY
# ============================================================

@router.post(
    "",
    response_model=ProductResponse
)
def create_product(
    data: ProductCreate,
    id_token: str,
    db: Session = Depends(get_db)
):

    try:

        # ----------------------------------------------------
        # VERIFY FIREBASE TOKEN
        # ----------------------------------------------------

        decoded_token = verify_firebase_token(
            id_token
        )

        firebase_uid = decoded_token["uid"]

        # ----------------------------------------------------
        # FIND USER
        # ----------------------------------------------------

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
                detail="User not found"
            )

        # ----------------------------------------------------
        # CHECK FARMER ROLE
        # ----------------------------------------------------

        if user.role != "farmer":
            raise HTTPException(
                status_code=403,
                detail="Only farmers can add products"
            )

        # ----------------------------------------------------
        # FIND FARMER PROFILE
        # ----------------------------------------------------

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
                detail="Farmer profile not found"
            )

        # ----------------------------------------------------
        # CHECK CATEGORY
        # ----------------------------------------------------

        from ..models.product import Product
        from ..models.category import Category

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
                detail="Category not found"
            )

        # ----------------------------------------------------
        # CREATE PRODUCT
        # ----------------------------------------------------

        product = Product(

            farmer_id=farmer_profile.farmer_id,

            category_id=data.category_id,

            name=data.name,

            description=data.description,

            price=data.price,

            unit=data.unit,

            quantity_available=data.quantity_available,

            image_url=data.image_url,

            is_available=True
        )

        # ----------------------------------------------------
        # SAVE
        # ----------------------------------------------------

        db.add(product)

        db.commit()

        db.refresh(product)

        # ----------------------------------------------------
        # RETURN
        # ----------------------------------------------------

        return product

    except ValueError as e:

        raise HTTPException(
            status_code=401,
            detail=str(e)
        )


# ============================================================
# GET FARMER PRODUCTS
# ============================================================

@router.get(
    "/my-products",
    response_model=list[ProductResponse]
)
def get_my_products(
    id_token: str,
    db: Session = Depends(get_db)
):

    try:

        # ----------------------------------------------------
        # VERIFY TOKEN
        # ----------------------------------------------------

        decoded_token = verify_firebase_token(
            id_token
        )

        firebase_uid = decoded_token["uid"]

        # ----------------------------------------------------
        # FIND USER
        # ----------------------------------------------------

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
                detail="User not found"
            )

        # ----------------------------------------------------
        # CHECK FARMER
        # ----------------------------------------------------

        if user.role != "farmer":
            raise HTTPException(
                status_code=403,
                detail="Only farmers can access this endpoint"
            )

        # ----------------------------------------------------
        # FIND FARMER PROFILE
        # ----------------------------------------------------

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
                detail="Farmer profile not found"
            )

        # ----------------------------------------------------
        # GET PRODUCTS
        # ----------------------------------------------------

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

    except ValueError as e:

        raise HTTPException(
            status_code=401,
            detail=str(e)
        )


# ============================================================
# GET ALL PRODUCTS
# BUYER HOME
# ============================================================

@router.get(
    "",
    response_model=list[ProductResponse]
)
def get_all_products(
    db: Session = Depends(get_db)
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
            detail=f"Failed to fetch products: {str(e)}"
        )