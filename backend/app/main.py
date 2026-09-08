from fastapi import FastAPI
from sqlalchemy import text

from .database import engine
from .routes.users import router as users_router
from .routes.auth import router as auth_router

app = FastAPI(title="FarmDirect API")

app.include_router(users_router)
app.include_router(users_router)
app.include_router(auth_router)


@app.get("/")
def root():
    return {
        "message": "FarmDirect Backend is running"
    }


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