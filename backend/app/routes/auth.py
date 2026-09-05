from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

from ..firebase import verify_firebase_token

router = APIRouter(
    prefix="/auth",
    tags=["Authentication"]
)


class TokenRequest(BaseModel):
    id_token: str


@router.post("/verify")
def verify_token(data: TokenRequest):

    try:
        decoded_token = verify_firebase_token(data.id_token)

        return {
            "message": "Firebase token verified successfully",
            "firebase_uid": decoded_token["uid"],
            "phone_number": decoded_token.get("phone_number"),
        }

    except ValueError as e:
        raise HTTPException(
            status_code=401,
            detail=str(e)
        )