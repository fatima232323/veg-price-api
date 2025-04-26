@echo off
echo Starting Flask server...
start cmd /k "cd servicehub_ml && python api.py"

echo Starting Flutter app...
cd servicehub
flutter run -d chrome 