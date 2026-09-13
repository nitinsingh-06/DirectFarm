import os
import uuid

from fastapi import APIRouter, Depends, File, HTTPException, UploadFile
from sqlalchemy.orm import Session
from pydantic import BaseModel

from backend.app.models.farmer_profile import FarmerProfile

from ..database import get_db
from ..models.user import User
from ..schemas.user import UserCreate, UserProfileUpdate, UserResponse


router = APIRouter(
    prefix="/users",
    tags=["Users"]
)


# ============================================================
# UPDATE USER
# ============================================================

class UserUpdate(BaseModel):
    name: str
    email: str | None = None
    phone: str | None = None


@router.put("/{user_id}", response_model=UserResponse)
def update_user(
    user_id: int,
    user_data: UserUpdate,
    db: Session = Depends(get_db)
):
    user = (
        db.query(User)
        .filter(User.user_id == user_id)
        .first()
    )

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found"
        )

    user.name = user_data.name
    user.email = user_data.email
    user.phone = user_data.phone

    db.commit()
    db.refresh(user)

    return user


# ============================================================
# CREATE USER
# ============================================================

@router.post("/", response_model=UserResponse)
def create_user(
    user_data: UserCreate,
    db: Session = Depends(get_db)
):
    existing_user = (
        db.query(User)
        .filter(User.firebase_uid == user_data.firebase_uid)
        .first()
    )

    if existing_user:
        raise HTTPException(
            status_code=400,
            detail="User already exists"
        )

    new_user = User(
        firebase_uid=user_data.firebase_uid,
        name=user_data.name,
        email=user_data.email,
        phone=user_data.phone,
        role=user_data.role
    )

    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return new_user


# ============================================================
# GET USER BY FIREBASE UID
# ============================================================

@router.get(
    "/by-firebase/{firebase_uid}",
    response_model=UserResponse
)
def get_user_by_firebase_uid(
    firebase_uid: str,
    db: Session = Depends(get_db)
):
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

    return user


# ============================================================
# GET ALL USERS
# ============================================================

@router.get("/", response_model=list[UserResponse])
def get_users(
    db: Session = Depends(get_db)
):
    return db.query(User).all()

@router.post("/{user_id}/profile-image", response_model=UserResponse)
async def upload_profile_image(
    user_id: int,
    file: UploadFile = File(...),
    db: Session = Depends(get_db)
):
    # Find user
    user = (
        db.query(User)
        .filter(User.user_id == user_id)
        .first()
    )

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found"
        )

    # Get file extension
    original_name = file.filename or ""
    extension = original_name.lower().split(".")[-1]

    if extension not in ["jpg", "jpeg", "png"]:
        raise HTTPException(
            status_code=400,
            detail="Only JPG, JPEG and PNG images are allowed"
        )

    if extension == "jpeg":
        extension = "jpg"

    # Generate unique filename
    filename = f"{user_id}_{uuid.uuid4().hex}.{extension}"

    # Upload directory
    upload_dir = os.path.join(
        os.path.dirname(
            os.path.dirname(
                os.path.dirname(__file__)
            )
        ),
        "uploads",
        "profiles"
    )

    os.makedirs(upload_dir, exist_ok=True)

    # Full file path
    file_path = os.path.join(
        upload_dir,
        filename
    )

    # Save image
    contents = await file.read()

    with open(file_path, "wb") as buffer:
        buffer.write(contents)

    # Save URL in database
    image_url = f"/uploads/profiles/{filename}"

    user.profile_image_url = image_url

    db.commit()
    db.refresh(user)

    return user


# ============================================================
# UPDATE USER PROFILE
# ============================================================

@router.put("/{user_id}/profile", response_model=UserResponse)
def update_user_profile(
    user_id: int,
    profile_data: UserProfileUpdate,
    db: Session = Depends(get_db)
):

    # --------------------------------------------------------
    # FIND USER
    # --------------------------------------------------------

    user = (
        db.query(User)
        .filter(User.user_id == user_id)
        .first()
    )

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found"
        )

    # --------------------------------------------------------
    # CHECK EMAIL
    # --------------------------------------------------------

    existing_email = (
        db.query(User)
        .filter(
            User.email == profile_data.email,
            User.user_id != user_id
        )
        .first()
    )

    if existing_email:
        raise HTTPException(
            status_code=400,
            detail="Email already exists"
        )

    # --------------------------------------------------------
    # CHECK PHONE
    # --------------------------------------------------------

    existing_phone = (
        db.query(User)
        .filter(
            User.phone == profile_data.phone,
            User.user_id != user_id
        )
        .first()
    )

    if existing_phone:
        raise HTTPException(
            status_code=400,
            detail="Phone number already exists"
        )

    # --------------------------------------------------------
    # UPDATE USERS TABLE
    # --------------------------------------------------------

    user.name = profile_data.name.strip()
    user.email = profile_data.email.strip()
    user.phone = profile_data.phone.strip()

    # --------------------------------------------------------
    # UPDATE FARMER PROFILE
    # --------------------------------------------------------

    farmer_profile = (
        db.query(FarmerProfile)
        .filter(
            FarmerProfile.user_id == user_id
        )
        .first()
    )

    if farmer_profile:
        farmer_profile.description = profile_data.bio.strip()

    # --------------------------------------------------------
    # SAVE
    # --------------------------------------------------------

    db.commit()

    db.refresh(user)

    return user