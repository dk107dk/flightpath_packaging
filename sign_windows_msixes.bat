:: this was already done
:: C:\"Program Files (x86)"\"Windows Kits"\10\bin\10.0.26100.0\arm64\signtool sign /f c:\dev\flightpath\packaging\assets\FlightPathCert.pfx /p hangzhou /fd SHA256 C:\dev\flightpath_packaging\universal\arm64\FlightPathData-arm64-test.msix


C:\"Program Files (x86)"\"Windows Kits"\10\bin\10.0.26100.0\x64\signtool sign /f c:\dev\flightpath\packaging\assets\FlightPathCert.pfx /p hangzhou /fd SHA256 "C:\dev\flightpath_packaging\universal\x64\FlightPathData-test-x64.msix"

:: verify fails due to trust root for both x64 and arm64, but the installer will run anyway, at least in developer mode
:: C:\"Program Files (x86)"\"Windows Kits"\10\bin\10.0.26100.0\x64\signtool verify /pa "C:\dev\flightpath_packaging\universal\x64\FlightPathData-test-x64.msix"
