from sqlalchemy import (
    Column,
    Integer,
    BigInteger,
    String,
    Boolean,
    DateTime,
    ForeignKey,
)
from sqlalchemy.sql import func

from app.core.database import Base


class Address(Base):
    __tablename__ = "addresses"

    address_id = Column(
        Integer,
        primary_key=True,
        index=True,
    )

    user_id = Column(
        BigInteger,
        ForeignKey("users.user_id"),
        nullable=False,
        index=True,
    )

    full_name = Column(
        String(150),
        nullable=False,
    )

    phone = Column(
        String(20),
        nullable=False,
    )

    address_line = Column(
        String(255),
        nullable=False,
    )

    landmark = Column(
        String(255),
        nullable=True,
    )

    city = Column(
        String(100),
        nullable=False,
    )

    state = Column(
        String(100),
        nullable=False,
    )

    pincode = Column(
        String(10),
        nullable=False,
    )

    label = Column(
        String(20),
        nullable=False,
        default="Home",
    )

    is_default = Column(
        Boolean,
        default=False,
        nullable=False,
    )

    created_at = Column(
        DateTime,
        server_default=func.now(),
    )