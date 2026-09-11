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


# ============================================================
# REQUEST MODELS
# ============================================================

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


# ============================================================
# VERIFY FIREBASE TOKEN
# ============================================================

@router.post("/verify")
def verify_token(
    data: TokenRequest
):
    try:
        decoded_token = verify_firebase_token(
            data.id_token
        )

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


# ============================================================
# REGISTER USER
# ============================================================

@router.post("/register")
def register_user(
    data: RegisterRequest,
    db: Session = Depends(get_db)
):
    try:
        # --------------------------------------------------------
        # VERIFY FIREBASE ID TOKEN
        # --------------------------------------------------------

        decoded_token = verify_firebase_token(
            data.id_token
        )

        firebase_uid = decoded_token["uid"]

        # --------------------------------------------------------
        # VERIFY FIREBASE UID
        # --------------------------------------------------------

        if firebase_uid != data.firebase_uid:
            raise HTTPException(
                status_code=401,
                detail="Firebase UID does not match token"
            )

        # --------------------------------------------------------
        # CHECK IF USER ALREADY EXISTS
        # --------------------------------------------------------

        existing_user = (
            db.query(User)
            .filter(
                User.firebase_uid == firebase_uid
            )
            .first()
        )

        if existing_user:
            raise HTTPException(
                status_code=400,
                detail="User already exists"
            )

        # --------------------------------------------------------
        # GET NAME
        # Buyer sends: name
        # Farmer sends: full_name
        # --------------------------------------------------------

        name = data.name or data.full_name

        if not name:
            raise HTTPException(
                status_code=400,
                detail="Name is required"
            )

        # --------------------------------------------------------
        # GET PHONE
        # Prefer phone from Firebase token
        # --------------------------------------------------------

        phone = (
            decoded_token.get("phone_number")
            or data.phone
        )

        # --------------------------------------------------------
        # CREATE DATABASE USER
        # --------------------------------------------------------

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

        # --------------------------------------------------------
        # RETURN USER DATA
        # --------------------------------------------------------

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


# ============================================================
# LOGIN USER
# ============================================================

@router.post("/login")
def login_user(
    data: TokenRequest,
    db: Session = Depends(get_db)
):
    try:
        # --------------------------------------------------------
        # VERIFY FIREBASE ID TOKEN
        # --------------------------------------------------------

        decoded_token = verify_firebase_token(
            data.id_token
        )

        # --------------------------------------------------------
        # GET FIREBASE UID
        # --------------------------------------------------------

        firebase_uid = decoded_token["uid"]

        # --------------------------------------------------------
        # FIND USER IN POSTGRESQL
        # --------------------------------------------------------

        existing_user = (
            db.query(User)
            .filter(
                User.firebase_uid == firebase_uid
            )
            .first()
        )

        # --------------------------------------------------------
        # USER NOT REGISTERED
        # --------------------------------------------------------

        if existing_user is None:
            raise HTTPException(
                status_code=404,
                detail="User is not registered in FarmDirect"
            )

        # --------------------------------------------------------
        # LOGIN SUCCESS
        # --------------------------------------------------------

        return {
            "message": "Login successful",
            "user_id": existing_user.user_id,
            "firebase_uid": existing_user.firebase_uid,
            "name": existing_user.name,
            "email": existing_user.email,
            "phone": existing_user.phone,
            "role": existing_user.role
        }

    except ValueError as e:
        raise HTTPException(
            status_code=401,
            detail=str(e)
        )