
Use build.bat if you just want an exe

Use create_windows_release.bat to create an MSIX. It calls build.bat for you.

To create a winget package you need to:
    - sign the msix
    - upload the msix in a release on the flightpath_packaging repo
    - run winget_create.bat

Packaging and installing FlightPath Server as an MSIX or .exe using Winget works.

Releasing to the public packages repo is unproven. To do it we need an idividual developer code-signing cert from SSL.com or similar.

There are problems: the liability of shipping signed code through winget is substantial because we have more than 50% (finger in the air) of the responsibility for the binary not being malware. That's unacceptable until we're incorporated. LLC + cert would ultimately cost ~$1000 + a lot of bother in year one with no incremental improvement in the business outlook.

Shipping just the .exe through WinGet works, in principle, but Windows Defender flags it as malware. That is unlikely to be surmountable, so we're back to option one.

Instead of either option, we're going to try adding a --server-mode flag to the FlightPath Data exe. It appears that running from the commandline is doable -- tried it, works fine. And according to Copilot a small change to the manifest <Capabilities> will allow it to be a network listener on a high port. We don't have any reason to prefer 80 or 443 over an arbitrary high port, so a non-issue.

This dir's scripts work if we come back to a code-signed MSIX strategy in the future.



