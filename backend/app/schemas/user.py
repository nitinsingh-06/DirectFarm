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

    class Config:
        from_attributes = True