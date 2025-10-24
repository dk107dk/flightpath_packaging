cd ..\..\flightpath
git pull
poetry update

cd ..\flightpath_packaging\windows

RD /S /Q .\dist
mkdir .\dist

RD /S /Q ..\..\flightpath\tmp
mkdir ..\..\flightpath\tmp

copy FlightPath-Data-windows.spec ..\..\flightpath\tmp
cd ..\..\flightpath\tmp

poetry run pyinstaller FlightPath-Data-windows.spec

move dist\FlightPathData.exe ..\..\flightpath_packaging\windows\dist
move dist\FlightPathServer.exe ..\..\flightpath_packaging\windows\dist

cd ..\..\flightpath_packaging\windows

:: RD /S /Q ..\..\flightpath\tmp