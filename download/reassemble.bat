@echo off
setlocal enabledelayedexpansion

echo 🔧 Reassembling: 10227_1080p.mp4

:: Combine chunks
copy /b "10227_1080p.mp4.part.*" "10227_1080p.mp4" > nul 2>&1

if not exist "10227_1080p.mp4" (
    echo ❌ Failed to reassemble file
    exit /b 1
)

:: Verify checksum
echo Verifying integrity...

:: Extract hash from certutil output (line 2, remove spaces)
for /f "skip=1 tokens=* delims=" %%h in ('certutil -hashfile "10227_1080p.mp4" SHA256') do (
    set "actual=%%h"
    goto :got_actual
)
:got_actual
set "actual=%actual: =%"

:: Read expected hash from file
set /p expected=<"10227_1080p.mp4.sha256"
for /f "tokens=1" %%a in ("%expected%") do set "expected=%%a"
set "expected=%expected: =%"

:: Compare (case-insensitive)
if /i "%actual%"=="%expected%" (
    echo ✅ Success! File: 10227_1080p.mp4
    for %%A in ("10227_1080p.mp4") do echo Size: %%~zA bytes
    echo.
    echo 🧹 Cleaning up chunks...
    del "10227_1080p.mp4.part.*" 2>nul
    del "10227_1080p.mp4.sha256" 2>nul
    echo ✅ Chunks deleted. Only the final file remains.
) else (
    echo ❌ Checksum verification failed!
    echo Expected: %expected%
    echo Actual:   %actual%
    del "10227_1080p.mp4" 2>nul
    exit /b 1
)

endlocal

