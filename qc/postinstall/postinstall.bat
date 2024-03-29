@echo off
goto main
:main
echo Welcome to Windows QC
echo Finishing up
echo Actions
echo 1 Run LiteExplorer
echo 2 Finish Up
choice /c 12 /n /m "Action: "
goto x%ERRORLEVEL%
:x0
goto main
:x1
exp.exe
goto main
:x2
oobe\windeploy
Reagentc /enable
Reagentc /Info /Target C:\Windows
echo When Windows Boot Status says Getting Ready, press any key
pause
echo Creating Administrator Account
set /p username="Username? "
set /p password="Password (leave empty if none)? "
net user /add %username% %password%
net localgroup users /add  %username%
net localgroup administrators /add %username%
echo Bypassing OOBE
reg add HKLM\SYSTEM\Setup /v OOBEInProgress /t REG_DWORD /d 0 /f
reg add HKLM\SYSTEM\Setup /v SetupType /t REG_DWORD /d 0 /f
reg add HKLM\SYSTEM\Setup /v SystemSetupInProgress /t REG_DWORD /d 0 /f
echo Adding Post Install to shell
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /t REG_SZ /d "cmd.exe /c C:\Windows\PostInstall\AfterOOBE\main.bat" /f
pause
exit
