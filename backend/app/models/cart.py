from sqlalchemy import (
    Column,
    BigInteger,
    Integer,
    String,
    Text,
    Numeric,
    DateTime,
    ForeignKey,
    UniqueConstraint,
)
from sqlalchemy.sql import func

from app.core.database import Base

class Cart(Base):
    __tablename__ = "carts"

    cart_id = Column(
        BigInteger,
        primary_key=True,
        index=True,
        autoincrement=True,
    )

    user_id = Column(
        BigInteger,
        ForeignKey(
            "users.user_id",
            ondelete="CASCADE",
        ),
        nullable=False,
        unique=True,
        index=True,
    )

    created_at = Column(
        DateTime,
        server_default=func.current_timestamp(),
    )

    updated_at = Column(
        DateTime,
        server_default=func.current_timestamp(),
        onupdate=func.current_timestamp(),
    )


class CartItem(Base):
    __tablename__ = "cart_items"

    cart_item_id = Column(
        BigInteger,
        primary_key=True,
        index=True,
        autoincrement=True,
    )

    cart_id = Column(
        BigInteger,
        ForeignKey(
            "carts.cart_id",
            ondelete="CASCADE",
        ),
        nullable=False,
        index=True,
    )

    product_id = Column(
        BigInteger,
        ForeignKey(
            "products.product_id",
            ondelete="CASCADE",
        ),
        nullable=False,
        index=True,
    )

    # ============================================================
    # PRODUCT SNAPSHOT
    # ============================================================

    name = Column(
        String(150),
        nullable=False,
    )

    price = Column(
        Numeric(10, 2),
        nullable=False,
    )

    unit = Column(
        String(30),
        nullable=False,
    )

    image_url = Column(
        Text,
        nullable=True,
    )

    farm = Column(
        String(150),
        nullable=True,
    )

    location = Column(
        String(200),
        nullable=True,
    )

    # ============================================================
    # QUANTITY
    # ============================================================

    quantity = Column(
        Integer,
        nullable=False,
        default=1,
    )

    # ============================================================
    # TIMESTAMPS
    # ============================================================

    created_at = Column(
        DateTime,
        server_default=func.current_timestamp(),
    )

    updated_at = Column(
        DateTime,
        server_default=func.current_timestamp(),
        onupdate=func.current_timestamp(),
    )

    __table_args__ = (
        UniqueConstraint(
            "cart_id",
            "product_id",
            name="uq_cart_product",
        ),
    )