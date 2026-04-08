#!/usr/bin/env zsh
#
# in this script we are code-signing for app store distribution
# with the mac_app_distribution.cer certificate
#
echo "Starting codesign_app_for_store.sh to create sign .app"
echo -e "using the following vars: "
echo -e "keychain path:     $KEYCHAIN_APP_PATH"
echo -e "keychain password: $KEYCHAIN_APP_PASSWORD"
echo -e "p12 path:          $P12_APP_PATH"
echo -e "p12 password:      $P12_APP_PASSWORD"
echo -e "app cert CN:       $APP_CERT_COMMON_NAME"


echo -e "creating keychain"
# Create fresh ephemeral keychain
security create-keychain -p "$KEYCHAIN_APP_PASSWORD" "$KEYCHAIN_APP_PATH"
security set-keychain-settings -t 3600 -u "$KEYCHAIN_APP_PATH"
security unlock-keychain -p "$KEYCHAIN_APP_PASSWORD" "$KEYCHAIN_APP_PATH"

echo -e "adding keychain to search list"
# Add to keychain search list
security list-keychains -s \
  "$KEYCHAIN_APP_PATH" \
  /User/davidkershaw/Library/Keychains/login.keychain-db \
  /Library/Keychains/System.keychain

echo -e "importing p12"
# Import P12 (contains private key + leaf cert together)
security import "$P12_APP_PATH" \
  -k "$KEYCHAIN_APP_PATH" \
  -P "$P12_APP_PASSWORD" \
  -T /usr/bin/codesign \
  -T /usr/bin/productbuild

echo -e "importing intermediate cert. location is hard coded to /Users/davidkershaw/dev/csvpath_devops/mac/certs/trust_chain/AppleWWDRCAG3.cer"
# Import intermediate cert (public, from repo)
security import /Users/davidkershaw/dev/csvpath_devops/mac/certs/trust_chain/AppleWWDRCAG3.cer \
  -k "$KEYCHAIN_APP_PATH" \
  -T /usr/bin/codesign \
  -T /usr/bin/productbuild

# Set ACLs
echo -e "setting ACLs partition list"
security set-key-partition-list \
  -S apple-tool:,apple:,codesign: \
  -s \
  -k "$KEYCHAIN_APP_PASSWORD" \
  "$KEYCHAIN_APP_PATH"

#
# check for quarantine attributes. this is redundant but we're being more aggressive here.
# I'm reluctant to remove it because it doesn't hurt and we had so much trouble getting to
# a working build that I don't want to touch anything.
#
echo -e "clearing attributes"
xattr -cr ./tmp/FlightPath\ Data.app

echo -e "\nsigning app"
#
# try using --identity hash to more specifically call out the right cert, per
# security find-identity -p basic -v
#
#
codesign \
    --verbose=4 \
    --force \
    --deep \
    --options=runtime \
    --keychain $KEYCHAIN_APP_PATH \
    --entitlements ./assets/entitlements.plist \
    --sign "${APP_CERT_COMMON_NAME:q}" \
    --timestamp \
    ./tmp/FlightPath\ Data.app

echo -e "\nverifing code-signed app"
codesign \
    --verbose=4 \
    -vvv \
    --deep \
    --strict \
    ./tmp/FlightPath\ Data.app



