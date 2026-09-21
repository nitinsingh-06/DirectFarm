from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.models.address import Address
from app.models.user import User
from app.firebase import verify_firebase_token


router = APIRouter(
    prefix="/addresses",
    tags=["Addresses"]
)


@router.get("/me")
def get_my_addresses(
    id_token: str,
    db: Session = Depends(get_db)
):
    # ---------------------------------------------------------
    # 1. Verify Firebase token
    # ---------------------------------------------------------
    decoded_token = verify_firebase_token(id_token)

    firebase_uid = decoded_token.get("uid")

    if not firebase_uid:
        raise HTTPException(
            status_code=401,
            detail="Invalid Firebase token"
        )

    # ---------------------------------------------------------
    # 2. Find logged-in user
    # ---------------------------------------------------------
    user = (
        db.query(User)
        .filter(User.firebase_uid == firebase_uid)
        .first()
    )

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found"
        )

    # ---------------------------------------------------------
    # 3. Make sure user is a buyer
    # ---------------------------------------------------------
    if user.role != "buyer":
        raise HTTPException(
            status_code=403,
            detail="Only buyers can access buyer addresses"
        )

    # ---------------------------------------------------------
    # 4. Get addresses belonging to this user
    # ---------------------------------------------------------
    addresses = (
        db.query(Address)
        .filter(Address.user_id == user.user_id)
        .order_by(
            Address.is_default.desc(),
            Address.created_at.desc()
        )
        .all()
    )

    return addresses