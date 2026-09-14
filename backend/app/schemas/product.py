from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class ProductCreate(BaseModel):
    name: str = Field(..., min_length=2, max_length=150)
    description: str | None = None
    category: str = Field(..., min_length=2, max_length=100)
    price: Decimal = Field(..., gt=0)
    quantity: int = Field(..., ge=0)
    image_url: str | None = None


class ProductResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    product_id: int
    farmer_id: int
    name: str
    description: str | None
    category: str
    price: Decimal
    quantity: int
    image_url: str | None