from fastapi import (
    APIRouter,
    Depends,
    HTTPException,
    Query,
)

from sqlalchemy.orm import Session

from app.core.database import get_db
from app.firebase import verify_firebase_token

from app.models.address import Address
from app.models.user import User

from app.schemas.address import (
    AddressCreate,
    AddressUpdate,
)


router = APIRouter(
    prefix="/addresses",
    tags=["Addresses"],
)


# ============================================================
# GET MY ADDRESSES
# ============================================================

@router.get("/me")
def get_my_addresses(
    id_token: str = Query(...),
    db: Session = Depends(get_db),
):
    decoded_token = verify_firebase_token(
        id_token
    )

    firebase_uid = decoded_token.get(
        "uid"
    )

    user = (
        db.query(User)
        .filter(
            User.firebase_uid
            == firebase_uid
        )
        .first()
    )

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found",
        )

    addresses = (
        db.query(Address)
        .filter(
            Address.user_id
            == user.user_id
        )
        .order_by(
            Address.is_default.desc(),
            Address.created_at.desc(),
        )
        .all()
    )

    return [
        {
            "address_id": address.address_id,
            "user_id": address.user_id,
            "full_name": address.full_name,
            "phone": address.phone,
            "address_line": address.address_line,
            "landmark": address.landmark,
            "city": address.city,
            "state": address.state,
            "pincode": address.pincode,
            "label": address.label,
            "is_default": address.is_default,
        }
        for address in addresses
    ]


# ============================================================
# CREATE ADDRESS
# ============================================================

@router.post("")
def create_address(
    data: AddressCreate,
    id_token: str = Query(...),
    db: Session = Depends(get_db),
):
    decoded_token = verify_firebase_token(
        id_token
    )

    firebase_uid = decoded_token.get(
        "uid"
    )

    user = (
        db.query(User)
        .filter(
            User.firebase_uid
            == firebase_uid
        )
        .first()
    )

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found",
        )

    # If this address is default,
    # remove default from previous addresses.
    if data.is_default:
        (
            db.query(Address)
            .filter(
                Address.user_id
                == user.user_id
            )
            .update(
                {
                    Address.is_default:
                        False
                },
                synchronize_session=False,
            )
        )

    # If this is the first address,
    # automatically make it default.
    existing_count = (
        db.query(Address)
        .filter(
            Address.user_id
            == user.user_id
        )
        .count()
    )

    is_default = (
        data.is_default
        or existing_count == 0
    )

    address = Address(
        user_id=user.user_id,
        full_name=data.full_name,
        phone=data.phone,
        address_line=data.address_line,
        landmark=data.landmark,
        city=data.city,
        state=data.state,
        pincode=data.pincode,
        label=data.label,
        is_default=is_default,
    )

    db.add(address)
    db.commit()
    db.refresh(address)

    return {
        "message": "Address created successfully",
        "address_id":
            address.address_id,
    }


# ============================================================
# UPDATE ADDRESS
# ============================================================

@router.put("/{address_id}")
def update_address(
    address_id: int,
    data: AddressUpdate,
    id_token: str = Query(...),
    db: Session = Depends(get_db),
):
    decoded_token = verify_firebase_token(
        id_token
    )

    firebase_uid = decoded_token.get(
        "uid"
    )

    user = (
        db.query(User)
        .filter(
            User.firebase_uid
            == firebase_uid
        )
        .first()
    )

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found",
        )

    address = (
        db.query(Address)
        .filter(
            Address.address_id
            == address_id,
            Address.user_id
            == user.user_id,
        )
        .first()
    )

    if not address:
        raise HTTPException(
            status_code=404,
            detail="Address not found",
        )

    update_data = data.model_dump(
        exclude_unset=True
    )

    if update_data.get(
        "is_default"
    ) is True:
        (
            db.query(Address)
            .filter(
                Address.user_id
                == user.user_id,
                Address.address_id
                != address_id,
            )
            .update(
                {
                    Address.is_default:
                        False
                },
                synchronize_session=False,
            )
        )

    for key, value in update_data.items():
        setattr(
            address,
            key,
            value,
        )

    db.commit()
    db.refresh(address)

    return {
        "message": "Address updated successfully",
        "address_id":
            address.address_id,
    }


# ============================================================
# DELETE ADDRESS
# ============================================================

@router.delete("/{address_id}")
def delete_address(
    address_id: int,
    id_token: str = Query(...),
    db: Session = Depends(get_db),
):
    decoded_token = verify_firebase_token(
        id_token
    )

    firebase_uid = decoded_token.get(
        "uid"
    )

    user = (
        db.query(User)
        .filter(
            User.firebase_uid
            == firebase_uid
        )
        .first()
    )

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found",
        )

    address = (
        db.query(Address)
        .filter(
            Address.address_id
            == address_id,
            Address.user_id
            == user.user_id,
        )
        .first()
    )

    if not address:
        raise HTTPException(
            status_code=404,
            detail="Address not found",
        )

    was_default = address.is_default

    db.delete(address)
    db.commit()

    # If the deleted address was default,
    # make another address default.
    if was_default:
        next_address = (
            db.query(Address)
            .filter(
                Address.user_id
                == user.user_id
            )
            .order_by(
                Address.created_at.desc()
            )
            .first()
        )

        if next_address:
            next_address.is_default = True
            db.commit()

    return {
        "message": "Address deleted successfully"
    }