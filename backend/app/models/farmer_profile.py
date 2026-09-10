from sqlalchemy import Column, BigInteger, String, Text, ForeignKey, DateTime
from sqlalchemy.dialects.postgresql import ARRAY
from sqlalchemy.sql import func

from ..database import Base


class FarmerProfile(Base):
    __tablename__ = "farmer_profiles"

    farmer_id = Column(
        BigInteger,
        primary_key=True,
        index=True
    )

    user_id = Column(
        BigInteger,
        ForeignKey(
            "users.user_id",
            ondelete="CASCADE"
        ),
        unique=True,
        nullable=False
    )

    farm_name = Column(
        String(150),
        nullable=False
    )

    farm_location = Column(
        Text,
        nullable=True
    )

    description = Column(
        Text,
        nullable=True
    )

    aadhaar = Column(
        String(12),
        nullable=True
    )

    crops = Column(
        ARRAY(Text),
        nullable=True
    )

    created_at = Column(
        DateTime,
        server_default=func.now()
    )