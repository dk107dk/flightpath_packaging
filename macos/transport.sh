
echo -e '\nStarting transport.sh to send .itmsp file to apple...\n'
echo -e 'historically, iTMSTransporter has usually failed to upload. use the GUI instead.'

echo -e "using the following vars: "
echo -e "  - app specific password:     $APP_SPECIFIC_PASSWORD"
echo -e "  - apple ID:     $APPLE_ID"

echo -e '\nuploading package...\n'
xcrun /usr/local/itms/bin/iTMSTransporter -m upload -f ./6745823097.itmsp -u $APPLE_ID -p $APP_SPECIFIC_PASSWORD -v eXtreme
#
# this uses assetFile, but that doesn't work with .itmsp files.
# keeping it ffr. we will need to switch in the mid-term.
#
#xcrun iTMSTransporter -m upload -assetFile ./6745823097.itmsp -u @env:APPLE_ID -p @env:APP_SPECIFIC_PASSWORD -v detailed



