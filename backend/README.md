# Wardrope AI

## Backend
```bash
cd backend
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

## Frontend
```bash
cd frontend
flutter pub get
flutter run -d macos
```

## Build for macOS
```bash
cd frontend
flutter build macos
```
