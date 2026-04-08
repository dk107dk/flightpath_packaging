echo -e '\nStarting itmsp.sh to create itmsp wrapper for package...\n'
echo -e "using the following vars: "
echo -e "  none"

#
# Step: prep itmsp file
#
rm -Rf 6745823097
rm -Rf 6745823097.itmsp
mkdir clean_itmsp
cp ./pkg/FlightPath-Data.pkg ./clean_itmsp

#
#   - update the metadata.xml
. ./calculate_metadata.sh
#
#   - close the .itmsp
#   this causes an mv error because why? seems to work, tho.
mv ./clean_itmsp ./6745823097.itmsp


