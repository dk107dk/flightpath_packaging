
echo.
echo ************ copying ************ 
call copy_msixes.bat

echo.
echo ************ signing ************
call sign_windows_msixes.bat

echo.
echo ************ creating prod universal ************
call create_windows_universal.bat

echo.
echo ************ creating test universal ************
call create_windows_universal_test.bat

echo.
echo ************ signing test universal ************
call sign_windows_universal_bundle.bat

