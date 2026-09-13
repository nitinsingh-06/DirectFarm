from pydantic import BaseModel, EmailStr
from typing import Optional


class UserCreate(BaseModel):
    firebase_uid: str
    name: str
    email: Optional[EmailStr] = None
    phone: Optional[str] = None
    role: str


class UserResponse(BaseModel):
    user_id: int
    firebase_uid: str
    name: str
    email: Optional[EmailStr] = None
    phone: Optional[str] = None
    role: str
    profile_image_url: Optional[str] = None
    
    class Config:
        from_attributes = True


class UserProfileUpdate(BaseModel):
    name: str
    email: str
    phone: str
    bio: str