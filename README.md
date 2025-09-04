 
Hertale

A complete mobile + backend solution for home-cooked meal/tiffin services.

Repo note: If your folders are named differently (e.g., Hertale/Hertale/tiffin_tales_app for the Flutter app and Hertale_Backend for Django), treat them as frontend and backend respectively throughout this README.

📁 Repository Structure
Hertale-updated/
├─ frontend/            # Flutter mobile app  (or: Hertale/Hertale/tiffin_tales_app)
└─ backend/             # Django REST API      (or: Hertale_Backend)

🧭 Overview / Workflow

Users browse meals → add to cart → authenticate (Firebase Auth) → place order.

App reads/writes data via Django REST API (orders, menus, profile).

Firebase used for Auth (and optional Firestore for selected features).

Payments (optional) can be integrated later via Razorpay/Stripe.

🧰 Tech Stack

Frontend: Flutter (Dart), Provider (state), Firebase (Auth/optional Firestore)

Backend: Django, Django REST Framework, django-cors-headers

DB: SQLite (dev) / PostgreSQL (prod)

Build/CI: Gradle (Android), Google Play Console (AAB)

✅ Prerequisites

Flutter SDK (stable), Android SDK/Studio, Java 17+

Python 3.10+, pip, virtualenv

Git, GitHub access

(Optional) Firebase project with google-services.json

▶️ Frontend (Flutter) – Setup & Run
cd frontend
# (or: cd Hertale/Hertale/tiffin_tales_app)

flutter pub get

# Place google-services.json into:
# android/app/google-services.json

flutter run

Configure API Base URL

Set your Django API URL in Flutter:

class AppConfig {
  static const String baseUrl = "http://YOUR_PC_IP:8000";
}

📦 Frontend – Build
# APK
flutter build apk --release

# AAB (Play Console)
flutter build appbundle --release


Artifacts:

APK: build/app/outputs/flutter-apk/app-release.apk

AAB: build/app/outputs/bundle/release/app-release.aab

🛠️ Backend (Django) – Setup & Run
cd backend
# (or: cd ../Hertale_Backend)

python -m venv .venv
.\.venv\Scripts\activate
pip install -r requirements.txt

python manage.py migrate
python manage.py createsuperuser
python manage.py runserver 0.0.0.0:8000

Enable CORS
INSTALLED_APPS += ["corsheaders"]
MIDDLEWARE = ["corsheaders.middleware.CorsMiddleware", *MIDDLEWARE]
CORS_ALLOW_ALL_ORIGINS = True

🔐 Android Signing

android/key.properties:

storeFile=C:/Users/vaira/tiffin_tales_key.jks
storePassword=YOUR_STORE_PASSWORD
keyAlias=tiffin_tales
keyPassword=YOUR_KEY_PASSWORD

🚀 Google Play

Build AAB: flutter build appbundle --release

Go to Play Console → Your App → Production → Create new release

Upload app-release.aab

Add release notes → Review → Rollout

🧪 Test Checklist

App launches with Hertale branding.

Login/Logout works.

API calls reach Django (/api/...).

Release build installs and opens on device.

📄 License / Contact

Internal project for RM Groups — contact your manager for access and distribution guidelines.