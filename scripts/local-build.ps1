# Local build script for testing
param(
    [string]$Architecture = "x64",
    [string]$SourcePath = "..\..\flightpath"  # Adjust path to your local source
)

Write-Host "Building FlightPath for $Architecture..." -ForegroundColor Green

# Check if source exists
if (-not (Test-Path $SourcePath)) {
    Write-Error "Source path not found: $SourcePath"
    exit 1
}

# Build steps similar to the GitHub Actions workflow
# This helps you test locally before pushing to CI
Push-Location $SourcePath
try {
    # Install dependencies
    poetry install
    # Build executable
    poetry run pyinstaller --name "FlightPath" --windowed --onedir flightpath/main.py

    Write-Host "Build completed successfully!" -ForegroundColor Green
} finally {
    Pop-Location
}

