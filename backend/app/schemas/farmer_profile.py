from pydantic import BaseModel
from typing import List, Optional


class FarmerProfileCreate(BaseModel):
    user_id: int
    farm_name: str
    location: str
    aadhaar: str
    crops: List[str]


class FarmerProfileUpdate(BaseModel):
    farm_name: str
    farm_type: Optional[str] = None
    farm_size: Optional[float] = None
    crops: Optional[List[str]] = None
    certifications: Optional[str] = None
    years_of_experience: Optional[int] = None


class FarmerProfileResponse(BaseModel):
    farmer_id: int
    user_id: int

    farm_name: str

    farm_location: Optional[str] = None

    description: Optional[str] = None

    aadhaar: Optional[str] = None

    crops: Optional[List[str]] = None

    farm_type: Optional[str] = None

    farm_size: Optional[float] = None

    certifications: Optional[str] = None

    years_of_experience: Optional[int] = None

    class Config:
        from_attributes = True