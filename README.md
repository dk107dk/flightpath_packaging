
# Packaging FlightPath


## Platforms

We ship FlightPath through the MacOS Store and the Microsoft Store.

The MacOS build is arm64 only.

The Windows build runs on x64 and arm64 but is built only on arm64 and ships as a single universal .msix. We have "legacy" code to do an x64 build in a Github Actions workflow and create a two-MSIX package universal bundle. However, that doesn't seem to be needed so we stopped doing it because it adds complexity.

# Building for MacOS

The MacOS package build ships its results to Apple using the Transformer CLI/API. If there are any problems with that step, try uploading the resulting .pkg using the Transformer GUI -- that has worked where the CLI failed in the past.

- put your github token in ./macos/assets/github.token (github.token is in .gitignore)
- if a scheduled actions workflow hasn't successfully run, or you need a new .app build, do a commit to main
- run ./aliases.sh to load env vars required for signing
  * APP_SPECIFIC_PASSWORD
  * APPLE_ID
  * FLIGHTPATH_KEYCHAIN_PASSWORD
  * INSTALLER_CERT_COMMON_NAME
  * APP_CERT_COMMON_NAME
- cd into ./macos
- run ./create_release_candidate_app_store.sh

# Building for Windows

The Windows msix build results must be uploaded into the submission manually using the developer portal.

- cd into ./windows
- open a Powershell terminal as Administrator
- run .\create_windows_release.ps1

The result will be in ./dist

Note: the .pfx key is just for testing and can live in github. Install it by double-clicking. Install to "Local Machine" → "Trusted Root Certification Authorities". The password is hangzhou. Put the Windows machine into developer mode. For x86 testing use the existing AWS test instance.


### The other stuff

Everything else in this repo is either old or it relates to the x64-dual-msix Windows package solution; no longer used. After some more housecleaning to handle build numbers better, and after seeing everything working consistently, we can cut most of the extras.
