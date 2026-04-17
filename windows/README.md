# Windows build and ship

This dir has everything to build and ship a .exe to the Microsoft Store.

## driver script

For most cases, just run create_windows_release.ps1. That script calls build.bat, etc. to create a test package and the msix for the Microsoft Store.

## New certificates

If you have a certificate issue and need to create a new cert, just run:
    create_cert.ps1. 

The installer build will use the assets\FlightPathCert.pfx. You'll install the new cert on the test machine as a root CA cert. After doing that, the msix should install.

Installing a .pfx requires: 
- download to an admin account on the target machine
- install the .pfx using: 
    Import-PfxCertificate `
     -FilePath "FlightPathCert.pfx" `
     -CertStoreLocation Cert:\LocalMachine\TrustedPeople `
     -Password (ConvertTo-SecureString "hangzhou" -AsPlainText -Force)
- test by installing the .msix. There should be no hiccups or workflow in doing the install.

## Building

You must pull the flightpath repo before building an installer. Installers are created by build.bat running a Pyinstaller script in a tmp dir in the flightpath repo. The Data and Server exes are moved to the dist dir here.

## Shipping:

Prepare to upload to a developer submission by running create_windows_release.ps1 in a Powershell terminal started as administrator. This script builds the exe and packages it as an .msix. It creates a test .msix that is signed and the prod .msix that is unsigned. Upload the prod .msix into the Store submission.


## Steps
WINDOWS RELEASES:

Use build.sh and aliases.sh where present.

1.  Do a release.sh of CsvPath
2.  Update FlightPath Server to the new CsvPath
3.  Update the FlightPath Server version and do a build.sh
4.  Run server unit tests and test manually from Server repo using RapidAPI and FlightPath
5.  Update the FlightPath Data version in pyproject and flightpath/assets/build_number.txt
6.  Do build.sh and make sure to commit the flightpath_server wheel to assets
7.  Update the AppxManifest version numbers to match flightpath/flightpath/assets/build_number.txt
8.  Run the test installer build in flightpath_packaging/windows
9.  Test the installer on installer test vm as the david user
    - Server API calls
    - Use of FlightPath Data
    - Use of FlightPath Data with OTLP and backend configured
10. - do a prod installer build
11. - Rename installers to include version number
11. - Copy prod and test installers to google drive versions dir
12. - Test installer on EC2 instance. Use test_assets/key.pem to start server and login.
12. - Upload prod to Microsoft, update submission, and submit
13. - Publish after submission accepted
14. - Test install from store




