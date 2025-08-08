

# MacOS build and ship

This dir has everything to build and ship a .app to the Mac App Store.

## Building

The app is built by a github action workflow that runs on commits of to main. There is one artifact, a ditto-zipped .app file.

## Shipping

Ship to the developer submission by running create_release_candidate_app_store.sh. This script downloads the artifact, pulls in the build_number.txt from the flightpath repo, signs the app, creates a pkg file, verifies it, and sends it to Apple using Transporter.


