from sqlalchemy import (
    Column,
    BigInteger,
    Integer,
    String,
    Text,
    Numeric,
    DateTime,
    ForeignKey,
)
from sqlalchemy.sql import func

from app.core.database import Base


class OrderItem(Base):
    __tablename__ = "order_items"

    # ============================================================
    # ORDER ITEM ID
    # ============================================================

    order_item_id = Column(
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
        index=True,
    )

    # ============================================================
    # PRODUCT
    # ============================================================

    product_id = Column(
        BigInteger,
        ForeignKey(
            "products.product_id",
            ondelete="SET NULL",
        ),
        nullable=True,
        index=True,
    )

    # ============================================================
    # FARMER
    # ============================================================

    farmer_id = Column(
        BigInteger,
        ForeignKey(
            "farmer_profiles.farmer_id",
            ondelete="SET NULL",
        ),
        nullable=True,
        index=True,
    )

    # ============================================================
    # PRODUCT SNAPSHOT
    # ============================================================

    product_name = Column(
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
# ITEM TOTAL
# ============================================================

total_price = Column(
    Numeric(10, 2),
    nullable=False,
)

# ============================================================
# FARMER ORDER STATUS
# ============================================================

status = Column(
    String(30),
    nullable=False,
    default="pending",
    index=True,
)

# ============================================================
# TIMESTAMP
# ============================================================

created_at = Column(
    DateTime,
    server_default=func.current_timestamp(),
    nullable=False,
)