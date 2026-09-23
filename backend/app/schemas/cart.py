from pydantic import BaseModel, Field
from typing import Optional
from decimal import Decimal
from datetime import datetime


# ============================================================
# ADD ITEM
# ============================================================

class CartItemCreate(BaseModel):
    product_id: int

    quantity: int = Field(
        default=1,
        ge=1,
    )


# ============================================================
# UPDATE QUANTITY
# ============================================================

class CartItemUpdate(BaseModel):
    quantity: int = Field(
        ge=1,
    )


# ============================================================
# CART ITEM RESPONSE
# ============================================================

class CartItemResponse(BaseModel):
    cart_item_id: int
    cart_id: int
    product_id: int

    name: str
    price: Decimal
    unit: str

    image_url: Optional[str] = None
    farm: Optional[str] = None
    location: Optional[str] = None

    quantity: int

    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True