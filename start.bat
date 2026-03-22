@echo off
chcp 65001 >nul

echo ======================================
echo   Agent Team Launcher
echo ======================================
echo.

:: 检查 AutoHotkey 是否安装
where ahk.exe >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] AutoHotkey not found, installing...
    powershell -Command "
        $url = 'https://www.autohotkey.com/download/ahk.zip'
        $out = '$env:TEMP\ahk.zip'
        Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing
        Expand-Archive -Path $out -DestinationPath '$env:TEMP\ahk' -Force
        Copy-Item '$env:TEMP\ahk\*' 'C:\Windows' -Force
        Remove-Item $out -Force -EA SilentlyContinue
        Remove-Item '$env:TEMP\ahk' -Recurse -Force -EA SilentlyContinue
    "
    echo [OK] AutoHotkey installed
    echo.
)

:: 启动 AutoHotkey 脚本
echo [INFO] Starting Agent Team...
start "" ahk.exe "%~dp0start.ahk"
