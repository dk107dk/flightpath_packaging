#
# run this script from ./packaging
#
. ./cleaner.sh
#
mkdir pkg
mkdir dist
mkdir tmp
#
# pull the most recent workflow artifact. we don't yet have this setup to
# provide a good build number or etc.
#
echo -e '\ndownloading latest .app build from repo\n'
poetry run python pull_artifacts.py

#
# move to another dir. this was a Claude suggestion. make a difference? but doesn't hurt.
# and if we don't do it we are using the dist dir with other build artifacts or deleting
# those artifacts. we switched to copying because we can reuse the app with the pkg version
# if we want to.
#
# first check for quarantine attributes. we've had those and they don't work for Apple.
# if there are problems with hard to read Transporter errors maybe try running this command
# against the whole FP repo -- that was needed at one point.
#
echo -e '\nremoving quarantine attribute, if present\n'
xattr -dr com.apple.quarantine ./dist/FlightPath\ Data.app/*
#
#
#
echo -e '\ncopying app to tmp for next steps\n'
mkdir tmp
cp -R ./dist/FlightPath\ Data.app ./tmp/FlightPath\ Data.app

#
# codesign and validtion. pyinstaller builds can be codesigned, but we (may) need
# the force and deep flags
#
. ./codesign_app_for_store.sh

#
# create pkg
#
. ./pkg.sh
. ./itmsp.sh

#
# ship to apple
#
. ./transport_verify.sh
. ./transport.sh

#
# clean up to help prevent junk hanging around, going into git
#
. ./cleaner.sh


