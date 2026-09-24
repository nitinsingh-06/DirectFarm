from sqlalchemy import (
    Column,
    BigInteger,
    String,
    Numeric,
    DateTime,
    ForeignKey,
    Text,
)
from sqlalchemy.sql import func

from app.core.database import Base


class Payment(Base):
    __tablename__ = "payments"

    # ============================================================
    # PAYMENT ID
    # ============================================================

    payment_id = Column(
        BigInteger,
        primary_key=True,
        index=True,
        autoincrement=True,
    )

    # ============================================================
    # ORDER
    # ============================================================

    order_id = Column(
        BigInteger,
        ForeignKey(
            "orders.order_id",
            ondelete="CASCADE",
        ),
        nullable=False,
        unique=True,
        index=True,
    )

    # ============================================================
    # PAYMENT INFORMATION
    # ============================================================

    amount = Column(
        Numeric(10, 2),
        nullable=False,
    )

    method = Column(
        String(30),
        nullable=False,
        default="COD",
    )

    status = Column(
        String(30),
        nullable=False,
        default="Pending",
    )

    transaction_id = Column(
        String(150),
        nullable=True,
        unique=True,
    )

    provider = Column(
        String(50),
        nullable=True,
    )

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

    paid_at = Column(
        DateTime,
        nullable=True,
    )