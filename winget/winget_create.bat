
::
:: pulls a release msix to create the winget package
:: the msix must be signed
::
::    wingetcreate.exe new https://github.com/dk107dk/flightpath_server/releases/download/v0.0.1-alpha/FlightPathServer-arm64-test.msix

:: --------------------------------------------------------------

::
:: this version is an attempt to create an .exe only package; no code signing
::
    wingetcreate.exe new https://github.com/dk107dk/flightpath_server/releases/download/v0.0.1-alpha/FlightPathServer.exe

