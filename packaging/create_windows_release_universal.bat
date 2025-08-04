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
set BASE_DIR=C:\dev\flightpath
set PACKAGING_DIR=%BASE_DIR%\packaging
set DIST_DIR=%PACKAGING_DIR%\dist
set BUNDLE_DIR=%DIST_DIR%\bundle
set MAKEAPPX="C:\Program Files (x86)\Windows Kits\10\bin\10.0.26100.0\arm64\makeappx.exe"

REM Check if GitHub token is set
if "%GITHUB_TOKEN%"=="" (
    echo ERROR: FLIGHTPATH_GITHUB_TOKEN environment variable not set
    echo Please set it to your GitHub Personal Access Token
    exit /b 1
)

echo Step 1: Building ARM64 MSIX...
cd /d %BASE_DIR%
poetry run pyinstaller FlightPath-Data-windows.spec
if errorlevel 1 (
    echo ERROR: ARM64 build failed
    exit /b 1
)

%MAKEAPPX% pack /d "%DIST_DIR%\%APP_NAME%" /p "%DIST_DIR%\%APP_NAME%-arm64.msix" /l /o
if errorlevel 1 (
    echo ERROR: ARM64 MSIX packaging failed
    exit /b 1
)
echo ✅ ARM64 MSIX created successfully

echo.
echo Step 2: Downloading latest x64 MSIX from GitHub Actions...

REM Create bundle directory
if not exist "%BUNDLE_DIR%" mkdir "%BUNDLE_DIR%"

REM PowerShell script to download latest x64 artifact
powershell -ExecutionPolicy Bypass -Command ^
"$headers = @{'Authorization' = 'Bearer %GITHUB_TOKEN%'; 'Accept' = 'application/vnd.github.v3+json'}; ^
Write-Host 'Getting latest workflow runs...'; ^
$runs = Invoke-RestMethod -Uri 'https://api.github.com/repos/%REPO_OWNER%/%REPO_NAME%/actions/runs?status=success&per_page=10' -Headers $headers; ^
$latestRun = $runs.workflow_runs | Where-Object { $_.name -eq 'Build Universal MSIX Package' -or $_.name -like '*MSIX*' } | Select-Object -First 1; ^
if (-not $latestRun) { Write-Error 'No successful workflow runs found'; exit 1 }; ^
Write-Host \"Found run: $($latestRun.id) from $($latestRun.created_at)\"; ^
$artifacts = Invoke-RestMethod -Uri $latestRun.artifacts_url -Headers $headers; ^
$x64Artifact = $artifacts.artifacts | Where-Object { $_.name -eq 'msix-x64' } | Select-Object -First 1; ^
if (-not $x64Artifact) { Write-Error 'No x64 artifact found'; exit 1 }; ^
Write-Host \"Downloading artifact: $($x64Artifact.name)\"; ^
$zipPath = '%BUNDLE_DIR%\x64-artifact.zip'; ^
Invoke-RestMethod -Uri $x64Artifact.archive_download_url -Headers $headers -OutFile $zipPath; ^
Write-Host 'Extracting x64 MSIX...'; ^
Expand-Archive -Path $zipPath -DestinationPath '%BUNDLE_DIR%\x64-temp' -Force; ^
$x64Msix = Get-ChildItem '%BUNDLE_DIR%\x64-temp\*.msix' | Select-Object -First 1; ^
if ($x64Msix) { ^
    Copy-Item $x64Msix.FullName '%BUNDLE_DIR%\%APP_NAME%-x64.msix'; ^
    Write-Host \"✅ Downloaded: $($x64Msix.Name)\"; ^
} else { ^
    Write-Error 'No MSIX file found in artifact'; ^
    exit 1 ^
}; ^
Remove-Item $zipPath -Force; ^
Remove-Item '%BUNDLE_DIR%\x64-temp' -Recurse -Force"

if errorlevel 1 (
    echo ERROR: Failed to download x64 MSIX
    exit /b 1
)

echo.
echo Step 3: Copying ARM64 MSIX to bundle directory...
copy "%DIST_DIR%\%APP_NAME%-arm64.msix" "%BUNDLE_DIR%\"
if errorlevel 1 (
    echo ERROR: Failed to copy ARM64 MSIX
    exit /b 1
)

echo.
echo Step 4: Creating Universal MSIX Bundle...

REM Get version from one of the MSIX files for naming
for %%f in ("%BUNDLE_DIR%\*.msix") do (
    set MSIX_FILE=%%~nf
    goto :got_filename
)
:got_filename

REM Extract version from filename (assumes format: AppName-arch-version.msix)
for /f "tokens=3 delims=-" %%a in ("%MSIX_FILE%") do set VERSION=%%a

if "%VERSION%"=="" (
    echo WARNING: Could not extract version, using timestamp
    for /f "tokens=1-3 delims=/ " %%a in ('date /t') do set VERSION=%%c%%a%%b
    for /f "tokens=1-2 delims=: " %%a in ('time /t') do set VERSION=!VERSION!-%%a%%b
)

set BUNDLE_NAME=%APP_NAME%-Universal-%VERSION%.msixbundle

echo Creating bundle: %BUNDLE_NAME%
%MAKEAPPX% bundle /d "%BUNDLE_DIR%" /p "%DIST_DIR%\%BUNDLE_NAME%" /l /o

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
if exist "%BUNDLE_DIR%\*.msix" del "%BUNDLE_DIR%\*.msix"

echo.
echo Build completed successfully!
pause
