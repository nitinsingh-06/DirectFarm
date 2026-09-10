from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from ..database import get_db
from ..models.user import User
from ..models.farmer_profile import FarmerProfile
from ..schemas.farmer_profile import (
    FarmerProfileCreate,
    FarmerProfileResponse
)


router = APIRouter(
    prefix="/farmer-profile",
    tags=["Farmer Profile"]
)


# ============================================================
# CREATE FARMER PROFILE
# ============================================================

@router.post(
    "/",
    response_model=FarmerProfileResponse
)
def create_farmer_profile(
    profile_data: FarmerProfileCreate,
    db: Session = Depends(get_db)
):

    # --------------------------------------------------------
    # Find user
    # --------------------------------------------------------

    user = (
        db.query(User)
        .filter(
            User.user_id == profile_data.user_id
        )
        .first()
    )

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found"
        )

    # --------------------------------------------------------
    # Make sure user is farmer
    # --------------------------------------------------------

    if user.role != "farmer":
        raise HTTPException(
            status_code=400,
            detail="User is not a farmer"
        )

    # --------------------------------------------------------
    # Check existing profile
    # --------------------------------------------------------

    existing_profile = (
        db.query(FarmerProfile)
        .filter(
            FarmerProfile.user_id ==
            profile_data.user_id
        )
        .first()
    )

    if existing_profile:
        raise HTTPException(
            status_code=400,
            detail="Farmer profile already exists"
        )

    # --------------------------------------------------------
    # Create profile
    # --------------------------------------------------------

    new_profile = FarmerProfile(
        user_id=profile_data.user_id,
        farm_name=profile_data.farm_name,
        farm_location=profile_data.location,
        aadhaar=profile_data.aadhaar,
        crops=profile_data.crops
    )

    db.add(new_profile)

    db.commit()

    db.refresh(new_profile)

    return new_profile


# ============================================================
# GET FARMER PROFILE
# ============================================================

@router.get(
    "/{user_id}",
    response_model=FarmerProfileResponse
)
def get_farmer_profile(
    user_id: int,
    db: Session = Depends(get_db)
):

    profile = (
        db.query(FarmerProfile)
        .filter(
            FarmerProfile.user_id == user_id
        )
        .first()
    )

    if not profile:
        raise HTTPException(
            status_code=404,
            detail="Farmer profile not found"
        )

    return profile