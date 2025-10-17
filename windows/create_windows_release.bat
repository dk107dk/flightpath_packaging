:: 
:: don't run this script directly. instead run the create_windows_release.ps1 in an admin powershell terminal.
:: 

:: RD /S /Q .\dist

:: poetry run pyinstaller FlightPath-Data-windows.spec

:: RD /S /Q dist\FlightPathData

:: mkdir dist
mkdir dist\FlightPathData

copy dist\FlightPathData.exe dist\FlightPathData
copy dist\FlightPathServer.exe dist\FlightPathData
copy assets\AppxManifestProd\AppxManifest.xml dist\FlightPathData
copy assets\logo44x44.png dist\FlightPathData
copy assets\logo150x150.png dist\FlightPathData
copy assets\logo.png dist\FlightPathData

C:\"Program Files (x86)"\"Windows Kits"\10\bin\10.0.26100.0\arm64\makeappx pack /d dist\FlightPathData /p dist\FlightPathData-arm64.msix

