@echo off
setlocal
pause
:: Specify the URL for the update file
set "UpdateURL=https://raw.githubusercontent.com/ImNotDario/Windows-QC/main/bootstrapper.bat"

:: Set the path for the local update file
set "LocalUpdateFile=%TEMP%\bootstrapper_update.bat"
pause
:: Calculate hash of local batch file
certutil -hashfile "%~f0" SHA256 > "%TEMP%\local_hash.txt"
for /f "usebackq skip=1 delims=" %%a in ("%TEMP%\local_hash.txt") do (
    set "local_hash=%%a"
    goto :nextline
)
:nextline
pause
:: Calculate hash of downloaded update batch file, if it exists
if exist "%LocalUpdateFile%" (
    certutil -hashfile "%LocalUpdateFile%" SHA256 > "%TEMP%\update_hash.txt"
    for /f "usebackq skip=1 delims=" %%a in ("%TEMP%\update_hash.txt") do (
        set "update_hash=%%a"
        goto :nextline2
    )
) else (
    set "update_hash="
)
:nextline2

pause
pause
:: Compare the hashes
if "%local_hash%"=="%update_hash%" (
    :: Hashes are equal, exit without updating
    echo No updates available.
    pause
    exit /b
) else (
    :: Hashes are different or update file doesn't exist, replace the current batch file with the updated version
    echo Updating...
    powershell -command "(New-Object System.Net.WebClient).DownloadFile('%UpdateURL%', '%~f0')"
)
pause
:: Clean up
del "%TEMP%\local_hash.txt"
if exist "%TEMP%\update_hash.txt" del "%TEMP%\update_hash.txt"

endlocal
echo test
pause
