from typing import Literal

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from sqlalchemy.orm import Session

from ..database import get_db
from ..firebase import verify_firebase_token
from ..models.user import User


router = APIRouter(
    prefix="/auth",
    tags=["Authentication"]
)


class TokenRequest(BaseModel):
    id_token: str


class RegisterRequest(BaseModel):
    id_token: str
    firebase_uid: str
    role: Literal["buyer", "farmer", "admin"]
    phone: str | None = None
    name: str | None = None
    full_name: str | None = None
    email: str | None = None


@router.post("/verify")
def verify_token(data: TokenRequest):

    try:
        decoded_token = verify_firebase_token(data.id_token)

        return {
            "message": "Firebase token verified successfully",
            "firebase_uid": decoded_token["uid"],
            "phone_number": decoded_token.get("phone_number"),
        }

    except ValueError as e:
        raise HTTPException(
            status_code=401,
            detail=str(e)
        )


@router.post("/register")
def register_user(
    data: RegisterRequest,
    db: Session = Depends(get_db)
):
    try:
        # Verify Firebase ID token
        decoded_token = verify_firebase_token(data.id_token)

        firebase_uid = decoded_token["uid"]

        # Don't trust a different UID sent by Flutter
        if firebase_uid != data.firebase_uid:
            raise HTTPException(
                status_code=401,
                detail="Firebase UID does not match token"
            )

        # Check whether user already exists
        existing_user = (
            db.query(User)
            .filter(User.firebase_uid == firebase_uid)
            .first()
        )

        if existing_user:
            raise HTTPException(
                status_code=400,
                detail="User already exists"
            )

        # Buyer sends "name"
        # Farmer sends "full_name"
        name = data.name or data.full_name

        if not name:
            raise HTTPException(
                status_code=400,
                detail="Name is required"
            )

        # Use phone from Firebase token when available
        phone = decoded_token.get("phone_number") or data.phone

        new_user = User(
            firebase_uid=firebase_uid,
            name=name,
            email=data.email,
            phone=phone,
            role=data.role
        )

        db.add(new_user)
        db.commit()
        db.refresh(new_user)

        return {
            "message": "User registered successfully",
            "user_id": new_user.user_id,
            "firebase_uid": new_user.firebase_uid,
            "name": new_user.name,
            "email": new_user.email,
            "phone": new_user.phone,
            "role": new_user.role
        }

    except ValueError as e:
        raise HTTPException(
            status_code=401,
            detail=str(e)
        )