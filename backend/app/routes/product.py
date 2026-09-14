from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from ..database import get_db
from ..firebase import verify_firebase_token
from ..models.user import User
from ..models.product import Product
from ..schemas.product import ProductCreate, ProductResponse


router = APIRouter(
    prefix="/products",
    tags=["Products"]
)


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
        decoded_token = verify_firebase_token(id_token)

        firebase_uid = decoded_token["uid"]

        user = (
            db.query(User)
            .filter(User.firebase_uid == firebase_uid)
            .first()
        )

        if user is None:
            raise HTTPException(
                status_code=404,
                detail="User not found"
            )

        if user.role != "farmer":
            raise HTTPException(
                status_code=403,
                detail="Only farmers can add products"
            )

        product = Product(
            farmer_id=user.user_id,
            name=data.name,
            description=data.description,
            category=data.category,
            price=data.price,
            quantity=data.quantity,
            image_url=data.image_url
        )

        db.add(product)
        db.commit()
        db.refresh(product)

        return product

    except ValueError as e:
        raise HTTPException(
            status_code=401,
            detail=str(e)
        )