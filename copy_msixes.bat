
set BASE_DIR=C:\dev\flightpath_packaging\universal
set X64_DIR=%BASE_DIR%\x64
set ARM64_DIR=%BASE_DIR%\arm64

mkdir %X64_DIR%
mkdir %ARM64_DIR%

copy ..\flightpath\packaging\dist\FlightPathData-arm64.msix %ARM64_DIR%
copy ..\flightpath\packaging\dist\FlightPathData-test-arm64.msix %ARM64_DIR%

copy C:\Users\python\Downloads\FlightPathData-x64.msix.zip %X64_DIR%
copy C:\Users\python\Downloads\FlightPathData-test-x64.msix.zip %X64_DIR%

tar -xf %X64_DIR%\FlightPathData-x64.msix.zip -C %X64_DIR%
tar -xf %X64_DIR%\FlightPathData-test-x64.msix.zip -C %X64_DIR% 

del /q %X64_DIR%\FlightPathData-x64.msix.zip
del /q %X64_DIR%\FlightPathData-test-x64.msix.zip



