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
    print("========================================")
    print("VERIFY FIREBASE TOKEN CALLED")
    print("TOKEN RECEIVED:", bool(id_token))
    print("TOKEN LENGTH:", len(id_token) if id_token else 0)
    print("========================================")

    try:
        decoded_token = auth.verify_id_token(id_token)

        print("========================================")
        print("FIREBASE TOKEN VERIFIED SUCCESSFULLY")
        print("UID:", decoded_token.get("uid"))
        print("EMAIL:", decoded_token.get("email"))
        print("PROJECT:", decoded_token.get("aud"))
        print("========================================")

        return decoded_token

    except Exception as e:
        print("========================================")
        print("FIREBASE TOKEN VERIFICATION FAILED")
        print("ERROR TYPE:", type(e).__name__)
        print("ERROR:", repr(e))
        print("========================================")

        raise ValueError(
            f"Invalid Firebase token: {str(e)}"
        )