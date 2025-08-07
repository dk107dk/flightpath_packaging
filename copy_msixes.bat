
set BASE_DIR=C:\dev\flightpath_packaging\universal
set X64_DIR=%BASE_DIR%\x64
set ARM64_DIR=%BASE_DIR%\arm64

mkdir %X64_DIR%
mkdir %ARM64_DIR%

RD /Q /S .\artifacts
mkdir artifacts
poetry run python pull_artifacts.py
copy artifacts\FlightPathData-x64.msix %X64_DIR%
copy artifacts\FlightPathData-test-x64.msix %X64_DIR%

copy ..\flightpath\packaging\dist\FlightPathData-arm64.msix %ARM64_DIR%
copy ..\flightpath\packaging\dist\FlightPathData-test-arm64.msix %ARM64_DIR%


