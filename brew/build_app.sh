#
# this script is just for making a MacOs app without any other packaging. it
# should be called by other scripts, in part to make sure the build number is
# updated correctly.
#
#echo -e '\nupdating build number...\n'
#. ./env.sh

echo -e '\ncreating app...\n'
poetry run pyinstaller ./FlightPath\ Server-no-codesign.spec


