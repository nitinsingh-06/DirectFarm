import os
import firebase_admin
from firebase_admin import credentials, auth
from dotenv import load_dotenv

load_dotenv()

firebase_credentials = os.getenv(
    "FIREBASE_CREDENTIALS"
)

if not firebase_admin._apps:
    cred = credentials.Certificate(firebase_credentials)
    firebase_admin.initialize_app(cred)

def verify_firebase_token(id_token: str):
    try:
        decoded_token = auth.verify_id_token(id_token)

        print("Firebase token verified successfully")
        print("Firebase UID:", decoded_token.get("uid"))

        return decoded_token

    except Exception as e:
        print("FIREBASE TOKEN ERROR:", repr(e))
        raise ValueError(
            f"Invalid Firebase token: {str(e)}"
        )