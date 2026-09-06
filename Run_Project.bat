@echo off
setlocal enabledelayedexpansion
title Smart Queue Management System Launcher

:: Ensure working directory is the script's directory
cd /d "%~dp0"

echo ======================================================================
echo           STARTING SMART QUEUE MANAGEMENT SYSTEM
echo ======================================================================
echo.

:: Checking if ports 9999 or 5173 are already in use and freeing them if needed
echo [1/3] Checking ports 9999 and 5173...

netstat -ano | findstr :9999 >nul
if %errorlevel% equ 0 (
    echo [WARNING] Port 9999 is in use. Attempting to terminate existing process...
    for /f "tokens=5" %%a in ('netstat -aon ^| findstr :9999') do (
        taskkill /f /pid %%a 2>nul
    )
)

netstat -ano | findstr :5173 >nul
if %errorlevel% equ 0 (
    echo [WARNING] Port 5173 is in use. Attempting to terminate existing process...
    for /f "tokens=5" %%a in ('netstat -aon ^| findstr :5173') do (
        taskkill /f /pid %%a 2>nul
    )
)

:: Starting Spring Boot Backend
echo [2/3] Starting Backend Server on port 9999...
if exist "%~dp0apache-maven-3.9.9\bin\mvn.cmd" (
    start "Smart Queue Backend" cmd /k "color 0A && cd /d "%~dp0backend" && "%~dp0apache-maven-3.9.9\bin\mvn.cmd" spring-boot:run"
) else (
    start "Smart Queue Backend" cmd /k "color 0A && cd /d "%~dp0backend" && mvn spring-boot:run"
)

:: Starting React Frontend (Vite)
echo [3/3] Starting Frontend Server on port 5173...
if exist "%~dp0node_portable\node-v22.12.0-win-x64\npm.cmd" (
    if not exist "%~dp0frontend\node_modules" (
        echo [INFO] node_modules not found. Installing dependencies...
        call "%~dp0node_portable\node-v22.12.0-win-x64\npm.cmd" --prefix "%~dp0frontend" install
    )
    start "Smart Queue Frontend" cmd /k "color 0B && cd /d "%~dp0frontend" && "%~dp0node_portable\node-v22.12.0-win-x64\npm.cmd" run dev"
) else (
    if not exist "%~dp0frontend\node_modules" (
        echo [INFO] node_modules not found. Installing dependencies...
        cd /d "%~dp0frontend" && call npm install && cd /d "%~dp0"
    )
    start "Smart Queue Frontend" cmd /k "color 0B && cd /d "%~dp0frontend" && npm run dev"
)

echo.
echo ======================================================================
echo  SUCCESS: Backend and Frontend launchers executed!
echo  - Backend API: http://localhost:9999/swagger-ui.html
echo  - Frontend Web App: http://localhost:5173
echo ======================================================================
echo.
echo Press any key to close this launcher window (servers will keep running in separate windows).
pause
