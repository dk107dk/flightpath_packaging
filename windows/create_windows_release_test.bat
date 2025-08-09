:: 
:: don't run this script directly. instead run the create_windows_release.ps1 in an admin powershell terminal.
:: 

:: RD /S /Q dist

:: poetry run pyinstaller FlightPath-Data-windows.spec

:: RD /S /Q c:\dev\flightpath\packaging\dist\FlightPathData

mkdir dist\FlightPathData

copy dist\FlightPathData.exe dist\FlightPathData
copy assets\AppxManifest.xml dist\FlightPathData
copy assets\logo44x44.png dist\FlightPathData
copy assets\logo150x150.png dist\FlightPathData
copy assets\logo.png dist\FlightPathData

C:\"Program Files (x86)"\"Windows Kits"\10\bin\10.0.26100.0\arm64\makeappx pack /d dist\FlightPathData /p dist\FlightPathData-test-arm64.msix



