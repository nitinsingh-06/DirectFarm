from sqlalchemy import Column, BigInteger, String, DateTime
from sqlalchemy.sql import func

from app.core.database import Base

class User(Base):
    __tablename__ = "users"

    # ============================================================
    # USER ID
    # ============================================================

    user_id = Column(
        BigInteger,
        primary_key=True,
        index=True
    )

    # ============================================================
    # FIREBASE
    # ============================================================

    firebase_uid = Column(
        String(128),
        unique=True,
        nullable=False
    )

    # ============================================================
    # BASIC USER INFORMATION
    # ============================================================

    name = Column(
        String(100),
        nullable=False
    )

    email = Column(
        String(150),
        unique=True
    )

    phone = Column(
        String(15),
        unique=True
    )

    role = Column(
        String(20),
        nullable=False
    )

    # ============================================================
    # PROFILE IMAGE
    # ============================================================

    profile_image_url = Column(
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