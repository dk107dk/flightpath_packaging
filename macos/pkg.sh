echo "Starting pkg.sh to create install package"
mkdir pkg

echo -e "using the following vars: "
echo -e "  - keychain installer path:     $KEYCHAIN_INSTALLER_PATH"
echo -e "  - keychain installer password: $KEYCHAIN_INSTALLER_PASSWORD"
echo -e "  - p12 installer path:          $P12_INSTALLER_PATH"
echo -e "  - p12 installer password:      $P12_INSTALLER_PASSWORD"
echo -e "  - installer cert CN: $INSTALLER_CERT_COMMON_NAME"
echo -e "  - build #:           $FLIGHTPATH_BUILD"

security create-keychain -p "$KEYCHAIN_INSTALLER_PASSWORD" "$KEYCHAIN_INSTALLER_PATH"
security set-keychain-settings -t 3600 -u "$KEYCHAIN_INSTALLER_PATH"
security unlock-keychain -p "$KEYCHAIN_INSTALLER_PASSWORD" "$KEYCHAIN_INSTALLER_PATH"
security list-keychains -s \
  "$KEYCHAIN_INSTALLER_PATH" \
  /User/davidkershaw/Library/Keychains/login.keychain-db \
  /Library/Keychains/System.keychain

echo -e "importing installer p12"
# Import P12 (contains private key + leaf cert together)
security import "$P12_INSTALLER_PATH" \
  -k "$KEYCHAIN_INSTALLER_PATH" \
  -P "$P12_INSTALLER_PASSWORD" \
  -T /usr/bin/codesign \
  -T /usr/bin/productbuild

#
# done in codesign
#
echo -e "importing intermediate cert. location is hardcoded to /Users/davidkershaw/dev/csvpath_devops/mac/certs/trust_chain/AppleWWDRCAG3.cer"
# Import intermediate cert (public, from repo)
security import /Users/davidkershaw/dev/csvpath_devops/mac/certs/trust_chain/AppleWWDRCAG3.cer \
  -k "$KEYCHAIN_INSTALLER_PATH" \
  -T /usr/bin/codesign \
  -T /usr/bin/productbuild

#
# may need pkgbuild, but in principle apple-tool;,apple should be enough
#
echo -e "setting ACLs partition list"
security set-key-partition-list \
  -S apple-tool:,apple: \
  -s \
  -k "$KEYCHAIN_INSTALLER_PASSWORD" \
  "$KEYCHAIN_INSTALLER_PATH"

echo -e '\ndoing pkgbuild to create pkg...\n'
pkgbuild --component ./tmp/FlightPath\ Data.app \
         --install-location "/Applications" \
         --identifier com.flightpathdata.flightpath \
         --version $FLIGHTPATH_BUILD \
         ./pkg/component.pkg
#
# Step 2: Build the final package, including the component package
#
echo -e '\ndoing productbuild with pkg to create distribution...\n'
security unlock-keychain -p $KEYCHAIN_INSTALLER_PASSWORD $KEYCHAIN_INSTALLER_PATH
productbuild --product ./assets/product_definition.plist \
             --package-path ./pkg \
             --identifier com.flightpathdata.flightpath \
             --version $FLIGHTPATH_BUILD \
             --sign "$INSTALLER_CERT_COMMON_NAME" \
             --keychain $KEYCHAIN_INSTALLER_PATH \
             --component ./tmp/FlightPath\ Data.app \
             /Applications \
             ./pkg/FlightPath-Data.pkg



