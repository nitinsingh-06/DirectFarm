from fastapi import FastAPI
from sqlalchemy import text

from .database import engine, Base

# Import models so SQLAlchemy knows about them
from .models.user import User
from .models.farmer_profile import FarmerProfile

from .routes.users import router as users_router
from .routes.auth import router as auth_router
from .routes.farmer_profile import router as farmer_profile_router


app = FastAPI(
    title="FarmDirect API"
)


# ============================================================
# CREATE DATABASE TABLES
# ============================================================

Base.metadata.create_all(
    bind=engine
)


# ============================================================
# ROUTES
# ============================================================

app.include_router(users_router)

app.include_router(auth_router)

app.include_router(farmer_profile_router)


# ============================================================
# ROOT
# ============================================================

@app.get("/")
def root():
    return {
        "message": "FarmDirect Backend is running"
    }


# ============================================================
# HEALTH
# ============================================================

@app.get("/health")
def health():
    try:
        with engine.connect() as connection:
            connection.execute(text("SELECT 1"))

        return {
            "status": "healthy",
            "database": "connected"
        }

    except Exception as e:
        return {
            "status": "unhealthy",
            "database": "disconnected",
            "error": str(e)
        }