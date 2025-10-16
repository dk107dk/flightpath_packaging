

# MacOS build and ship

This dir has everything to build and ship a .app to the Mac App Store.

## Building

The app is built by a github action workflow that runs on commits of to main. There is one artifact, a ditto-zipped .app file.

## Shipping

Ship to the developer submission by running create_release_candidate_app_store.sh. This script downloads the artifact, pulls in the build_number.txt from the flightpath repo, signs the app, creates a pkg file, verifies it, and sends it to Apple using Transporter.

## Release Steps

MACOS RELEASES:

Use build.sh and aliases.sh where present.

1.  do a release of CsvPath
2.  update FlightPath Server to the new CsvPath
3.  update the FlightPath Server version and do a build.sh
4.  update the FlightPath Data version in pyproject and flightpath/assets/build_number.txt to match
5.  do build.sh
6.  test Server manually from Server repo using RapidAPI and FlightPath
7.  run the github actions in flightpath_packaging to create new macos app
8.  run the test installer build in flightpath_packaging/macos
9.  test the installer
    - Server API calls
    - Use of FlightPath Data
    - Use of FlightPath Data with OTLP and backend configured
10.  do a prod installer build and ship to apple
    - if the create_release_candidate_app_store.sh fails at the end due to transporter use the Transporter GUI





