
echo "Starting cleaner.sh to clean up build leftovers"
echo -e "using the following vars: "
echo -e "  - keychain installer path:   $KEYCHAIN_INSTALLER_PATH"
echo -e "  - keychain app path:         $KEYCHAIN_APP_PATH"
echo -e "  - clean-up keychains:        $CLEANUP_KEYCHAINS"
echo -e "  - clean-up dirs:             $CLEANUP_DIRS"
echo -e "  - clean-up dirs:             $CLEANUP_ITMSP"

if [ "$CLEANUP_DIRS" = true ]; then
    if [ -d "pkg" ]; then
        echo -e "cleaning up pkg"
        rm -Rf ./pkg
    fi
fi

if [ "$CLEANUP_DIRS" = true ]; then
    if [ -d "dist" ]; then
        echo -e "cleaning up dist"
        rm -Rf ./dist
    fi
fi

if [ "$CLEANUP_DIRS" = true ]; then
    if [ -d "tmp" ]; then
        echo -e "cleaning up tmp"
        rm -Rf ./tmp
    fi
fi

if [ "$CLEANUP_ITMSP" = true ]; then
    if [ -f "6745823097.itmsp" ]; then
        rm -Rf ./6745823097.itmsp
    fi
fi

if [ "$CLEANUP_KEYCHAINS" = true ]; then
    if [ -f "$KEYCHAIN_INSTALLER_PATH" ]; then
        echo -e "cleaning up keychains"
        security delete-keychain "$KEYCHAIN_INSTALLER_PATH"
        security list-keychains -s \
            ~/Library/Keychains/login.keychain-db \
            /Library/Keychains/System.keychain
    fi
fi

if [ "$CLEANUP_KEYCHAINS" = true ]; then
    if [ -f "$KEYCHAIN_APP_PATH" ]; then
        echo -e "cleaning up keychains"
        security delete-keychain "$KEYCHAIN_APP_PATH"
        security list-keychains -s \
            ~/Library/Keychains/login.keychain-db \
            /Library/Keychains/System.keychain
    fi
fi




