from sqlalchemy import (
    Column,
    BigInteger,
    String,
    Boolean,
    DateTime,
    ForeignKey,
)
from sqlalchemy.sql import func

from app.core.database import Base


class ProductImage(Base):
    __tablename__ = "product_images"

    image_id = Column(
        BigInteger,
        primary_key=True,
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

    image_url = Column(
        String,
        nullable=False,
    )

    is_primary = Column(
        Boolean,
        nullable=False,
        default=False,
    )

    created_at = Column(
        DateTime,
        server_default=func.current_timestamp(),
    )