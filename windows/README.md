# Windows build and ship

This dir has everything to build and ship a .exe to the Microsoft Store.

## Building

Create an installer by running create_windows_release.ps1 in a Powershell terminal 
started as administrator. 

create_windows_release.ps1 builds the app by executing build.bat.  build.bat updates 
c:\dev\flightpath by pulling from Git and doing Poetry update. It then runs a Pyinstaller script in 
a tmp dir in the flightpath repo. The exe is moved to the dist dir here.

If you don't use build.bat, remember to git pull and poetry update in c:\dev\flightpath. PyInstaller 
only builds what it finds, it does not prep the codebase in any way.

## Testing

Use the installer test VM for testing. It has the correct cert loaded and is otherwise plain vanella. 
The msix is too big to copy or run -- ~200mb. Get it to the machine via Google Drive. 

## Shipping

This script builds the exes and packages them as an .msix. It creates a test .msix that 
is signed and the prod .msix that is unsigned. Upload the prod .msix into the Store submission.
Microsoft will sign the prod .msix as part of their process.

