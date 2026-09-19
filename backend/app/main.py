from pathlib import Path

from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from sqlalchemy import text

from .database import engine, Base

# ============================================================
# IMPORT MODELS
# ============================================================

from .models.user import User
from .models.farmer_profile import FarmerProfile
from .models.product import Product
from .models.category import Category

# ============================================================
# IMPORT ROUTES
# ============================================================

from .routes.users import router as users_router
from .routes.auth import router as auth_router
from .routes.farmer_profile import router as farmer_profile_router
from .routes.product import router as products_router
from .routes.product_images import router as product_images_router
from fastapi.staticfiles import StaticFiles


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
# STATIC FILES - PROFILE IMAGES
# ============================================================

BASE_DIR = Path(__file__).resolve().parent.parent
UPLOADS_DIR = BASE_DIR / "uploads"


app.mount(
    "/uploads",
    StaticFiles(directory="uploads"),
    name="uploads",
)


# ============================================================
# ROUTES
# ============================================================

app.include_router(users_router)

app.include_router(auth_router)

app.include_router(farmer_profile_router)

app.include_router(products_router)
app.include_router(product_images_router)

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
# ==============================================================
# UPLOAD PRODUCT IMAGES
# ==============================================================
app.mount(
    "/uploads",
    StaticFiles(directory=str(UPLOADS_DIR)),
    name="uploads"
)