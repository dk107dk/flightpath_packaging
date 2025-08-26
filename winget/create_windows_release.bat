
 RD /S /Q .\dist
 RD /S /Q .\build

call build.bat

mkdir dist\FlightPathServer

copy dist\FlightPathServer.exe dist\FlightPathServer
copy assets\AppxManifest.xml dist\FlightPathServer
copy assets\icons\logo44x44.png dist\FlightPathServer
copy assets\icons\logo150x150.png dist\FlightPathServer
copy assets\icons\logo.png dist\FlightPathServer

C:\"Program Files (x86)"\"Windows Kits"\10\bin\10.0.26100.0\arm64\makeappx pack /d dist\FlightPathServer /p dist\FlightPathServer-arm64.msix

