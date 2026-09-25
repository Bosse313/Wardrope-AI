# Wardrope AI

A smart wardrobe app MVP built with Flutter (frontend) and FastAPI (backend). It helps you organize clothing, track laundry status, and generate outfit suggestions.

## Features
- Add wardrobe items manually
- Organize items by category
- Mark items as clean, worn, or in wash
- Generate simple outfit suggestions
- Track which items are currently in the wash
- Clean, minimal UI for fast daily use

## Stack
- Frontend: Flutter
- Backend: FastAPI
- Database: SQLite

## Quick start

### 1) Backend
```bash
cd backend
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### 2) Frontend
```bash
cd frontend
flutter pub get
flutter run -d macos
```

### 3) Build macOS app
```bash
cd frontend
flutter build macos
```

The macOS app bundle will be created in:
```text
frontend/build/macos/Build/Products/Release/
```

## Notes
This is an MVP and intentionally keeps logic simple so it runs locally without external services. It is designed to be extended later with real image recognition and more advanced outfit recommendations.
