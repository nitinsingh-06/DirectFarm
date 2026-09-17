from sqlalchemy import (
    Column,
    BigInteger,
    String,
    Text,
    DateTime,
)

from sqlalchemy.sql import func

from ..database import Base


class Category(Base):
    __tablename__ = "categories"

    # ============================================================
    # CATEGORY ID
    # ============================================================

    category_id = Column(
        BigInteger,
        primary_key=True,
        index=True
    )

    # ============================================================
    # CATEGORY NAME
    # ============================================================

    name = Column(
        String(100),
        unique=True,
        nullable=False
    )

    # ============================================================
    # DESCRIPTION
    # ============================================================

    description = Column(
        Text,
        nullable=True
    )

    # ============================================================
    # CREATED AT
    # ============================================================

    created_at = Column(
        DateTime,
        server_default=func.current_timestamp()
    )