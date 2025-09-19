@echo off
echo ========================================
echo    PET SAUDE - INICIANDO BACKEND
echo ========================================
echo.

echo [1/3] Navegando para pasta backend...
cd backend

echo [2/3] Instalando dependencias...
call npm install

echo [3/3] Iniciando servidor...
echo.
echo ✅ Backend iniciado em http://localhost:3000
echo ✅ API pronta para receber requisições do Flutter Web
echo.
echo Pressione Ctrl+C para parar o servidor
echo.

call npm start

pause
