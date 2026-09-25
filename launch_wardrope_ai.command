#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "========================================"
echo "Wardrope AI wird gestartet..."
echo "========================================"

action=""
if [ -f "/System/Library/CoreServices/Applications/Terminal.app/Contents/MacOS/Terminal" ]; then
  action="open_terminal"
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "Python wurde nicht gefunden."
  echo "Bitte installiere Python 3 zuerst."
  echo "Dann dieses Script erneut ausführen."
  read -p "Drücken Sie Enter zum Beenden..." 
  exit 1
fi

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter wurde nicht gefunden."
  echo "Bitte installiere Flutter zuerst: https://flutter.dev/docs/get-started/install/macos"
  echo "Danach dieses Script erneut ausführen."
  read -p "Drücken Sie Enter zum Beenden..." 
  exit 1
fi

# Backend
cd "$SCRIPT_DIR/backend"
if [ ! -d ".venv" ]; then
  echo "Virtual Environment wird erstellt..."
  python3 -m venv .venv
fi

source .venv/bin/activate
pip install -r requirements.txt >/dev/null 2>&1 || true

echo "Backend wird gestartet..."
nohup uvicorn app.main:app --host 0.0.0.0 --port 8000 >/tmp/wardrope_backend.log 2>&1 &

# Frontend
cd "$SCRIPT_DIR/frontend"

echo "Flutter-Abhängigkeiten werden überprüft..."
flutter pub get >/dev/null 2>&1 || true

echo "Frontend wird gestartet..."
nohup flutter run -d macos >/tmp/wardrope_frontend.log 2>&1 &

echo ""
echo "================================================="
echo "Wardrope AI wurde gestartet."
echo "Das Frontend öffnet sich in einem macOS-Fenster."
echo ""
echo "Wenn die App nicht erscheint, prüfe die Logs hier:"
echo "- Backend: /tmp/wardrope_backend.log"
echo "- Frontend: /tmp/wardrope_frontend.log"
echo "================================================="
echo ""

# Optional: keep script window open briefly so user can see the message
sleep 3
exit 0
