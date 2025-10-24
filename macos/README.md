

# MacOS build and ship

This dir has everything to build and ship a .app to the Mac App Store.

## Building

The app is built by a github action workflow that runs on commits of to main. There is one artifact, a ditto-zipped .app file.

## Shipping

Ship to the developer submission by running create_release_candidate_app_store.sh. This script downloads the artifact, pulls in the build_number.txt from the flightpath repo, signs the app, creates a pkg file, verifies it, and sends it to Apple using Transporter.

## Release Steps

MACOS RELEASES:

Use build.sh and aliases.sh where present.

1.  Do a release of CsvPath
2.  Update FlightPath Server to the new CsvPath
3.  Update the FlightPath Server version and do a build.sh
4.  Update the FlightPath Data version in pyproject and flightpath/assets/build_number.txt to match
5.  Do build.sh and make sure to commit the flightpath_server wheel to assets
6.  Test Server manually from Server repo using RapidAPI and FlightPath
7.  Run the github actions in flightpath_packaging to create new macos app
8.  Make sure the release number is the same for mac and windows: e.g. 1.1.86 it comes from: ../../flightpath/flightpath/assets/build_number.txt
9.  Run the test installer build in flightpath_packaging/macos
10.  test the installer
    - Server API calls
    - Use of FlightPath Data
    - Use of FlightPath Data with OTLP and backend configured
11.  do a prod installer build and ship to apple
    - if the create_release_candidate_app_store.sh fails at the end due to transporter use the Transporter GUI
12. - copy prod and test installers to google drive versions dir




