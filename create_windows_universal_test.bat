@echo off
setlocal enabledelayedexpansion

echo ========================================
echo Building FlightPath Universal Test
echo ========================================

set APP_NAME=FlightPathData
set BASE_DIR=C:\dev\flightpath_packaging\universal
set DIST_DIR=%BASE_DIR%\dist
set BUNDLE_DIR=%DIST_DIR%\bundle_test
set X64_DIR=%BASE_DIR%\x64
set ARM64_DIR=%BASE_DIR%\arm64
set MAKEAPPX="C:\Program Files (x86)\Windows Kits\10\bin\10.0.26100.0\arm64\makeappx.exe"
set VERSION = "1.1.15"
set BUNDLE_NAME=%APP_NAME%-Universal-test.msixbundle


MD %DIST_DIR%
MD %BUNDLE_DIR%

echo.
echo Step: Copying %ARM64_DIR%\FlightPathData-test-arm64.msix to bundle directory...
copy "%ARM64_DIR%\FlightPathData-test-arm64.msix" "%BUNDLE_DIR%\"
if errorlevel 1 (
    echo ERROR: Failed to copy ARM64 MSIX
    exit /b 1
)

echo.
echo Step: Copyign %X64_DIR%\FlightPathData-test-x64.msix to bundle directory...
copy "%X64_DIR%\FlightPathData-test-x64.msix" "%BUNDLE_DIR%\"
if errorlevel 1 (
    echo ERROR: Failed to copy X64 MSIX
    exit /b 1
)

echo.
echo Step: Creating Universal MSIX: %BUNDLE_NAME%
%MAKEAPPX% bundle /d "%BUNDLE_DIR%" /p "%DIST_DIR%\%BUNDLE_NAME%" /o
:: %MAKEAPPX% bundle /d "%BUNDLE_DIR%" /p "%DIST_DIR%\%BUNDLE_NAME%" /l /o
if errorlevel 1 (
    echo ERROR: Universal bundle creation failed
    exit /b 1
)

echo.
echo ========================================
echo ✅ SUCCESS! Test Universal Bundle created
echo ========================================
echo.
echo Files created:
echo   Universal Bundle: %DIST_DIR%\%BUNDLE_NAME%
echo.

C:\"Program Files (x86)"\"Windows Kits"\10\bin\10.0.26100.0\x64\signtool sign /f c:\dev\flightpath\packaging\assets\FlightPathCert.pfx /p hangzhou /fd SHA256 %DIST_DIR%\%BUNDLE_NAME%

