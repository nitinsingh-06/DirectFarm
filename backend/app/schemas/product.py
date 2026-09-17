from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class ProductCreate(BaseModel):
    name: str = Field(..., min_length=2, max_length=150)
    description: str | None = None
    category_id: int = Field(..., gt=0)
    price: Decimal = Field(..., ge=0)
    unit: str = Field(..., min_length=1, max_length=30)
    quantity_available: Decimal = Field(..., ge=0)
    image_url: str | None = None


class ProductResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    product_id: int
    farmer_id: int
    category_id: int
    name: str
    description: str | None
    price: Decimal
    unit: str
    quantity_available: Decimal
    image_url: str | None
    is_available: bool | None