echo -e '\nStarting transport_verify.sh to verify .itmsp file with apple...\n'

echo -e "using the following vars: "
echo -e "  - app specific password:     $APP_SPECIFIC_PASSWORD"
echo -e "  - apple ID:     $APPLE_ID"

echo -e '\nverifying package...\n'
xcrun /usr/local/itms/bin/iTMSTransporter -m verify -f ./6745823097.itmsp -u $APPLE_ID -p $APP_SPECIFIC_PASSWORD -v eXtreme
#xcrun /usr/local/itms/bin/iTMSTransporter -m verify -f ./6745823097.itmsp -u @env:APPLE_ID -p @env:APP_SPECIFIC_PASSWORD -v eXtreme

