from sqlalchemy import (
    Column,
    BigInteger,
    Integer,
    String,
    Numeric,
    DateTime,
    ForeignKey,
    Text,
)
from sqlalchemy.sql import func

from app.core.database import Base


class Order(Base):
    __tablename__ = "orders"

    # ============================================================
    # ORDER ID
    # ============================================================

    order_id = Column(
        BigInteger,
        primary_key=True,
        index=True,
        autoincrement=True,
    )

    # ============================================================
    # ORDER NUMBER
    # Example: FD2609240001
    # ============================================================

    order_number = Column(
        String(30),
        unique=True,
        nullable=False,
        index=True,
    )

    # ============================================================
    # BUYER
    # ============================================================

    user_id = Column(
        BigInteger,
        ForeignKey(
            "users.user_id",
            ondelete="CASCADE",
        ),
        nullable=False,
        index=True,
    )

    # ============================================================
    # DELIVERY ADDRESS
    # ============================================================

    address_id = Column(
        Integer,
        ForeignKey(
            "addresses.address_id",
            ondelete="SET NULL",
        ),
        nullable=True,
        index=True,
    )

    # ============================================================
    # ORDER STATUS
    # ============================================================

    status = Column(
        String(30),
        nullable=False,
        default="processing",
        index=True,
    )

    # ============================================================
    # PRICE DETAILS
    # ============================================================

    subtotal = Column(
        Numeric(10, 2),
        nullable=False,
        default=0,
    )

    delivery_fee = Column(
        Numeric(10, 2),
        nullable=False,
        default=0,
    )

    discount = Column(
        Numeric(10, 2),
        nullable=False,
        default=0,
    )

    total_amount = Column(
        Numeric(10, 2),
        nullable=False,
        default=0,
    )

    # ============================================================
    # PAYMENT
    # ============================================================

    payment_method = Column(
        String(30),
        nullable=False,
        default="COD",
    )

    payment_status = Column(
        String(30),
        nullable=False,
        default="Pending",
    )

    # ============================================================
    # OPTIONAL NOTE
    # ============================================================

    note = Column(
        Text,
        nullable=True,
    )

    # ============================================================
    # TIMESTAMPS
    # ============================================================

    created_at = Column(
        DateTime,
        server_default=func.current_timestamp(),
        nullable=False,
    )

    updated_at = Column(
        DateTime,
        server_default=func.current_timestamp(),
        onupdate=func.current_timestamp(),
        nullable=False,
    )