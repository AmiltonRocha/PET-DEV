@echo off
echo ========================================
echo    PET SAUDE - INICIANDO FLUTTER WEB
echo ========================================
echo.

echo [1/2] Configurando PATH do Flutter...
set PATH=%PATH%;C:\flutter-sdk\flutter\bin

echo [2/2] Iniciando Flutter Web...
echo.
echo ✅ Flutter Web iniciado em http://localhost:8080
echo ✅ Conectando com backend em http://localhost:3000
echo.
echo Pressione Ctrl+C para parar o Flutter
echo.

flutter run -d web-server --web-port 8080

pause
