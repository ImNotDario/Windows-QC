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
    echo There is no internet connection, or download failed.
	echo Running debootstrapped.
	explorer.exe
)

:: Execute the downloaded update file
call "%LocalUpdateFile%"

:: Clean up
del "%LocalUpdateFile%"

endlocal