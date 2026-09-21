from pydantic import BaseModel
from typing import Optional


class AddressCreate(BaseModel):
    full_name: str
    phone: str
    address_line: str
    landmark: Optional[str] = None
    city: str
    state: str
    pincode: str
    label: str = "Home"
    is_default: bool = False


class AddressUpdate(BaseModel):
    full_name: Optional[str] = None
    phone: Optional[str] = None
    address_line: Optional[str] = None
    landmark: Optional[str] = None
    city: Optional[str] = None
    state: Optional[str] = None
    pincode: Optional[str] = None
    label: Optional[str] = None
    is_default: Optional[bool] = None