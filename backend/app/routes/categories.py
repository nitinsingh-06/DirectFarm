from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.models.category import Category


router = APIRouter(
    prefix="/categories",
    tags=["Categories"],
)


# ============================================================
# GET ALL CATEGORIES
# ============================================================

@router.get("/")
def get_categories(
    db: Session = Depends(get_db),
):
    try:
        categories = (
            db.query(Category)
            .order_by(Category.category_id.asc())
            .all()
        )

        return [
            {
                "category_id": category.category_id,
                "name": category.name,
                "description": category.description,
                "created_at": category.created_at,
            }
            for category in categories
        ]

    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Failed to fetch categories: {str(e)}",
        )