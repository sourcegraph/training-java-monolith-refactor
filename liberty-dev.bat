@echo off
REM Liberty Development Server Startup Script for Windows
REM This script starts the Liberty server in development mode

echo Starting Big Bad Monolith on WebSphere Liberty...
echo =======================================================

REM Build the application first
echo Building application...
call gradlew.bat clean build

if %ERRORLEVEL% neq 0 (
    echo Build failed. Please check the errors above.
    exit /b 1
)

REM Start Liberty in development mode
echo Starting Liberty server in development mode...
echo Server will be available at: http://localhost:9080/big-bad-monolith
echo API endpoints will be available at: http://localhost:9080/big-bad-monolith/api/
echo.
echo Press Ctrl+C to stop the server
echo.

call gradlew.bat libertyDev

echo Server stopped.
