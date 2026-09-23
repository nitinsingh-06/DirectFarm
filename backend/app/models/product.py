from sqlalchemy import (
    Column,
    BigInteger,
    String,
    Text,
    Numeric,
    Boolean,
    DateTime,
    ForeignKey,
)
from sqlalchemy.sql import func

from app.core.database import Base


class Product(Base):
    __tablename__ = "products"

    # ============================================================
    # PRODUCT ID
    # ============================================================

    product_id = Column(
        BigInteger,
        primary_key=True,
        index=True
    )

    # ============================================================
    # FARMER
    # ============================================================

    farmer_id = Column(
        BigInteger,
        ForeignKey(
            "farmer_profiles.farmer_id",
            ondelete="CASCADE"
        ),
        nullable=False,
        index=True
    )

    # ============================================================
    # CATEGORY
    # ============================================================

    category_id = Column(
        BigInteger,
        ForeignKey(
            "categories.category_id",
            ondelete="RESTRICT"
        ),
        nullable=False,
        index=True
    )

    # ============================================================
    # PRODUCT INFORMATION
    # ============================================================

    name = Column(
        String(150),
        nullable=False
    )

    description = Column(
        Text,
        nullable=True
    )

    # ============================================================
    # PRICE
    # ============================================================

    price = Column(
        Numeric(10, 2),
        nullable=False
    )

    # ============================================================
    # UNIT
    # ============================================================

    unit = Column(
        String(30),
        nullable=False
    )

    # ============================================================
    # QUANTITY
    # ============================================================

    quantity_available = Column(
        Numeric(10, 2),
        nullable=False
    )

    # ============================================================
    # IMAGE
    # ============================================================

    image_url = Column(
        Text,
        nullable=True
    )

    # ============================================================
    # AVAILABILITY
    # ============================================================

    is_available = Column(
        Boolean,
        nullable=True,
        default=True
    )

    # ============================================================
    # TIMESTAMPS
    # ============================================================

    created_at = Column(
        DateTime,
        server_default=func.current_timestamp()
    )

    updated_at = Column(
        DateTime,
        server_default=func.current_timestamp(),
        onupdate=func.current_timestamp()
    )