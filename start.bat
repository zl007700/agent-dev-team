@echo off
chcp 65001 >nul
echo =====================================
echo   Agent Team Launcher
echo =====================================
echo.
powershell -ExecutionPolicy Bypass -File "%~dp0start.ps1"
pause
