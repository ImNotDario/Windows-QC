@echo off
setlocal

:: Specify the URL for the update file
set "UpdateURL=https://raw.githubusercontent.com/ImNotDario/Windows-QC/main/bootstrapper.bat"

:: Set the path for the local update file
set "LocalUpdateFile=%TEMP%\bootstrapper_update.bat"

:: Download the update file from the URL
powershell -command "(New-Object System.Net.WebClient).DownloadFile('%UpdateURL%', '%LocalUpdateFile%')"

:: Check if the download was successful
if not exist "%LocalUpdateFile%" (
    echo Failed to download the update file.
    exit /b 1
)

:: Calculate hash of local batch file
certutil -hashfile "%~f0" SHA256 > "%TEMP%\local_hash.txt"
for /f "usebackq delims=" %%a in ("%TEMP%\local_hash.txt") do set "local_hash=%%a"

:: Calculate hash of downloaded update batch file
certutil -hashfile "%LocalUpdateFile%" SHA256 > "%TEMP%\update_hash.txt"
for /f "usebackq delims=" %%a in ("%TEMP%\update_hash.txt") do set "update_hash=%%a"

:: Compare the hashes
if "%local_hash%"=="%update_hash%" (
    :: Hashes are equal, exit without updating
    echo No updates available.
    pause
    exit /b
) else (
    :: Hashes are different, replace the current batch file with the updated version
    echo Updating...
    copy /y "%LocalUpdateFile%" "%~f0"
)

:: Clean up
del "%TEMP%\local_hash.txt"
del "%TEMP%\update_hash.txt"
del "%LocalUpdateFile%"

endlocal
