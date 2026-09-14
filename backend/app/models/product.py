from sqlalchemy import Column, BigInteger, String, Text, Numeric, Integer, DateTime, ForeignKey
from sqlalchemy.sql import func
from ..database import Base


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
        ForeignKey("users.user_id"),
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

    category = Column(
        String(100),
        nullable=False,
        index=True
    )

    # ============================================================
    # PRICE & QUANTITY
    # ============================================================

    price = Column(
        Numeric(10, 2),
        nullable=False
    )

    quantity = Column(
        Integer,
        nullable=False,
        default=0
    )

    # ============================================================
    # PRODUCT IMAGE
    # ============================================================

    image_url = Column(
        String(500),
        nullable=True
    )

    # ============================================================
    # TIMESTAMPS
    # ============================================================

    created_at = Column(
        DateTime,
        server_default=func.now()
    )

    updated_at = Column(
        DateTime,
        server_default=func.now(),
        onupdate=func.now()
    )