#
# run this script from ./packaging
#
echo -e '\nclearing...\n'
. ./cleaner.sh
#
mkdir pkg
mkdir dist
mkdir tmp
#
#
#
#echo -e '\nupdate build number...\n'
#. ./env.sh
#
#
#echo -e '\nbuilding installer...\n'
#
# the ID hash needs to be the developer's not the installer creator's ID
#
#poetry run pyinstaller ./FlightPath\ Data-no-codesign.spec
#. ./build_app.sh
#
# pull the most recent workflow artifact. we don't yet have this setup to
# provide a good build number or etc.
#
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
xattr -dr com.apple.quarantine ./dist/FlightPath\ Data.app/*
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
echo -e '\ncreating package...\n'
. ./pkg.sh

#
# ship to apple
#
echo -e '\nverifying .itmsp file with apple...\n'
. ./transport_verify.sh

echo -e '\ntransporting .itmsp file to apple...\n'
echo -e 'TRANSPORT IS SWITCHED OFF FOR TESTING!'
#. ./transport.sh

#
# clean up to help prevent junk from going into git
#
#cd ..
#. ./cleaner.sh
echo -e 'CLEANER IS SWITCHED OFF FOR TESTING!'


