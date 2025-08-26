
Use build.bat if you just want an exe

Use create_windows_release.bat to create an MSIX. It calls build.bat for you.

To create a winget package you need to: 
    - sign the msix
    - upload the msix in a release on the flightpath_packaging repo
    - run winget_create.bat
    
   This step is completely unproven. To do it we need an idividual developer code-signing cert from SSL.com or similar. 
   The self-signing workflow we use for testing the FlightPath Data installers should work here as well, so we can try 
   this out before buying the cert. Doesn't look like it will be a problem, just a PIA to figure out and the cost.
  
