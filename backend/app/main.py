from pathlib import Path

from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from sqlalchemy import text

from .core.database import engine, Base

# ============================================================
# IMPORT MODELS
# ============================================================

from .models.user import User
from .models.farmer_profile import FarmerProfile
from .models.product import Product
from .models.category import Category
from .models.address import Address
from .models.cart import Cart, CartItem

# ORDER MODELS
from .models.order import Order
from .models.order_item import OrderItem
from .models.payment import Payment



# ============================================================
# IMPORT ROUTES
# ============================================================

from .routes.users import router as users_router
from .routes.auth import router as auth_router
from .routes.farmer_profile import router as farmer_profile_router
from .routes.product import router as products_router
from .routes.product_images import router as product_images_router
from .routes.address import router as address_router
from .routes.cart import router as cart_router
from .routes.orders import router as orders_router


# ============================================================
# CREATE FASTAPI APP
# ============================================================

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
# UPLOADS DIRECTORY
# ============================================================

BASE_DIR = Path(__file__).resolve().parent.parent

UPLOADS_DIR = BASE_DIR / "uploads"

UPLOADS_DIR.mkdir(
    parents=True,
    exist_ok=True
)


# ============================================================
# SERVE UPLOADED FILES
# ============================================================

app.mount(
    "/uploads",
    StaticFiles(
        directory=str(UPLOADS_DIR)
    ),
    name="uploads"
)


# ============================================================
# REGISTER ROUTES
# ============================================================

app.include_router(
    users_router
)

app.include_router(
    auth_router
)

app.include_router(
    farmer_profile_router
)

app.include_router(
    products_router
)

app.include_router(
    product_images_router
)

app.include_router(
    address_router
)

app.include_router(
    cart_router
)

app.include_router(orders_router)


# ============================================================
# ROOT ENDPOINT
# ============================================================

@app.get("/")
def root():
    return {
        "message": "FarmDirect Backend is running"
    }


# ============================================================
# HEALTH CHECK
# ============================================================

@app.get("/health")
def health():

    try:

        with engine.connect() as connection:

            connection.execute(
                text("SELECT 1")
            )

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