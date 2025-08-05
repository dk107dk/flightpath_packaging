@echo off
setlocal enabledelayedexpansion

echo ========================================
echo Building FlightPath ARM64 + Universal
echo ========================================

REM Configuration
set REPO_OWNER=dk107dk
set REPO_NAME=flightpath_packaging
set GITHUB_TOKEN=%FLIGHTPATH_GITHUB_TOKEN%
set APP_NAME=FlightPathData

REM Directories
set BASE_DIR=C:\dev\flightpath_packaging\universal
set DIST_DIR=%BASE_DIR%\dist
set BUNDLE_DIR=%DIST_DIR%\bundle
set X64_DIR=%BASE_DIR%\x64
set ARM64_DIR=%BASE_DIR%\arm64

set MAKEAPPX="C:\Program Files (x86)\Windows Kits\10\bin\10.0.26100.0\arm64\makeappx.exe"


echo.
MD %DIST_DIR%
MD %BUNDLE_DIR%

echo.
echo Step: Copying %ARM64_DIR%\FlightPathData-arm64.msix to bundle directory...
copy "%ARM64_DIR%\FlightPathData-arm64.msix" "%BUNDLE_DIR%\"
if errorlevel 1 (
    echo ERROR: Failed to copy ARM64 MSIX
    exit /b 1
)

echo.
echo Step: Copying X64 MSIX to bundle directory...
copy "%X64_DIR%\FlightPathData-x64.msix" "%BUNDLE_DIR%\"
if errorlevel 1 (
    echo ERROR: Failed to copy X64 MSIX
    exit /b 1
)


echo.
echo Step 4: Creating Universal MSIX Bundle...


set VERSION = "1.1.15"
set BUNDLE_NAME=%APP_NAME%-Universal-1.1.15.msixbundle

echo Creating bundle: %BUNDLE_NAME%
%MAKEAPPX% bundle /d "%BUNDLE_DIR%" /p "%DIST_DIR%\%BUNDLE_NAME%" /o
:: %MAKEAPPX% bundle /d "%BUNDLE_DIR%" /p "%DIST_DIR%\%BUNDLE_NAME%" /l /o

if errorlevel 1 (
    echo ERROR: Universal bundle creation failed
    exit /b 1
)

echo.
echo ========================================
echo ✅ SUCCESS! Universal MSIX Bundle created
echo ========================================
echo.
echo Files created:
echo   ARM64 MSIX: %DIST_DIR%\%APP_NAME%-arm64.msix
echo   Universal Bundle: %DIST_DIR%\%BUNDLE_NAME%
echo.
echo Bundle contents:
dir "%BUNDLE_DIR%\*.msix"

REM Cleanup
echo.
echo Cleaning up temporary files...
:: if exist "%BUNDLE_DIR%\*.msix" del "%BUNDLE_DIR%\*.msix"

echo.
echo Build completed successfully!
pause
