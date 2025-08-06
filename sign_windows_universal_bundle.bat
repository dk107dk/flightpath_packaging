@echo off
setlocal enabledelayedexpansion

echo ========================================
echo Signing FlightPath Test Universal
echo ========================================

REM Configuration
set APP_NAME=FlightPathData
set BASE_DIR=C:\dev\flightpath_packaging\universal
set DIST_DIR=%BASE_DIR%\dist
set VERSION = "1.1.15"
set BUNDLE_NAME=%APP_NAME%-Universal-test.msixbundle



C:\"Program Files (x86)"\"Windows Kits"\10\bin\10.0.26100.0\arm64\signtool sign /f c:\dev\flightpath\packaging\assets\FlightPathCert.pfx /p hangzhou /fd SHA256 %DIST_DIR%\%BUNDLE_NAME%

