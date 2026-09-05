from sqlalchemy import Column, BigInteger, String, DateTime
from sqlalchemy.sql import func

from ..database import Base


class User(Base):
    __tablename__ = "users"

    user_id = Column(BigInteger, primary_key=True, index=True)
    firebase_uid = Column(String(128), unique=True, nullable=False)
    name = Column(String(100), nullable=False)
    email = Column(String(150), unique=True)
    phone = Column(String(15), unique=True)
    role = Column(String(20), nullable=False)

    created_at = Column(
        DateTime,
        server_default=func.now()
    )

    updated_at = Column(
        DateTime,
        server_default=func.now(),
        onupdate=func.now()
    )