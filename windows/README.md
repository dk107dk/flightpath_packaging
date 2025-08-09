# Windows build and ship

This dir has everything to build and ship a .exe to the Microsoft Store.

## Building

The app is built locally by build.bat running a Pyinstaller script in a tmp dir in the flightpath repo. The exe is moved to the dist dir here.

## Shipping

Prepare to upload to a developer submission by running create\_windows\_release.ps1 in a Powershell terminal start as administrator. This script builds the exe and packages it as an .msix. It creates a test .msix that is signed and the prod .msix that is unsigned. Upload the prod .msix into the Store submission.

