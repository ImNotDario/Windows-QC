@echo off
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
goto main
:main
cls
echo Welcome to Windows QC PostOOBE
type assets\1.txt
REM 1 is Create User
REM 2 is Registry Tweaks
REM 3 is Set Up Windows
choice /c 1234 /n /m "Do: "
goto c%ERRORLEVEL%
:c0
goto main
:c1
cls
set /p username="Username? "
set /p password="Password (leave blank if none)? "
type assets\2.txt
choice /c YN /n /m "Y/n? "
goto c1c%ERRORLEVEL%
:c1c0
net user /add %username% %password% >nul
net localgroup users /add %username% >nul
goto main
:c1c1
net user /add %username% %password% >nul
net localgroup users /add %username% >nul
net localgroup administrators /add %username% >nul
goto main
:c1c2
net user /add %username% %password% >nul
net localgroup users /add %username% >nul
goto main
:c2
cls
echo Registry Tweaks
echo 1 - Verbose On Logon
echo 2 - Add Command Prompt to Context Menu
echo 3 - Old Windows Photo Viewer
echo 4 - Back
choice /c 1234 /n /m "Tweak: "
goto c2c%ERRORLEVEL%
:c2c0
goto main
:c2c1
cls
type assets\3.txt
choice /c ED /n
goto c2c1c%ERRORLEVEL%
:c2c1c0
reg add HKLM\SOFT\Microsoft\Windows\CurrentVersion\Policies\System /v VerboseStatus /t REG_DWORD /d 0 /f
goto c2
:c2c1c1
reg add HKLM\SOFT\Microsoft\Windows\CurrentVersion\Policies\System /v VerboseStatus /t REG_DWORD /d 1 /f
goto c2
:c2c1c2
reg add HKLM\SOFT\Microsoft\Windows\CurrentVersion\Policies\System /v VerboseStatus /t REG_DWORD /d 0 /f
goto c2
:c2c2
cls
type assets\4.txt
choice /c ED /n
goto c2c2c%ERRORLEVEL%
:c2c2c0
reg add HKEY_CLASSES_ROOT\Directory\shell\cmd /v HideBasedOnVelocityId /t REG_DWORD /d 6527944 /f
goto c2
:c2c2c1
reg add HKEY_CLASSES_ROOT\Directory\shell\cmd /v HideBasedOnVelocityId /t REG_DWORD /d 0 /f
goto c2
:c2c2c2
reg add HKEY_CLASSES_ROOT\Directory\shell\cmd /v HideBasedOnVelocityId /t REG_DWORD /d 6527944 /f
goto c2
:c2c3
cls
type assets\5.txt
choice /c ED /n
goto c2c3c%ERRORLEVEL%
:c2c3c0
reg import assets\uwpv.reg
goto c2
:c2c3c1
reg import assets\wpv.reg
goto c2
:c2c3c2
reg import assets\uwpv.reg
goto c2
:c2c4
goto main
:c3
echo Please Wait
powershell assets\setbg.ps1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName /t REG_SZ /d "Windows QC" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ReleaseId /t REG_SZ /d "10.0.0QC" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v Model /t REG_SZ /d "Windows 10 (modified)" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v Manufacturer /t REG_SZ /d "Microsoft" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v SupportURL /t REG_SZ /d "microsoft.com" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v SupportPhone /t REG_SZ /d "0800801046" /f
md C:\Windows\system32\bootstrap
copy assets\bootstrapper.bat C:\Windows\system32\bootstrap
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /t REG_SZ /d "cmd.exe /c C:\Windows\system32\bootstrap\bootstrapper.bat" /f
echo Finishing Up
copy assets\removepostinstall.bat C:\Windows\system32\bootstrap
echo Removing Post Install Wizard
C:\Windows\system32\bootstrap\removepostinstall.bat
echo Batch Job Done.
pause

exit
