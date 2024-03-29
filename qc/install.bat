@echo off
goto main
:main
cls
echo [1] uefi
echo [2] mbr
choice /c 12
if %ERRORLEVEL%==1 goto uefi
if %ERRORLEVEL%==2 goto mbr
goto main
:uefi
diskpart /s uefi.txt
goto nextup
:mbr
diskpart /s mbr.txt
goto nextup
:nextup
cd ..
dism /get-wiminfo /wimfile:install.wim
pause
set /p use="What do you want to use? "
dism /apply-image /imagefile:install.wim /index:%use% /applydir:C:\
md R:\Recovery\WindowsRE
xcopy /h C:\Windows\System32\Recovery\Winre.wim R:\Recovery\WindowsRE
C:\Windows\System32\Reagentc /Setreimage /Path R:\Recovery\WindowsRE /Target C:\Windows
bcdboot C:\Windows
goto copyup
:copyup
md C:\Windows\PostInstall
md C:\Windows\PostInstall\assets
md C:\Windows\PostInstall\AfterOOBE
md C:\Windows\PostInstall\AfterOOBE\assets
cd postinstall
copy *.* C:\Windows\PostInstall
cd assets
copy *.* C:\Windows\PostInstall\assets
cd ..
cd AfterOOBE
copy *.* C:\Windows\PostInstall\AfterOOBE
cd assets
copy *.* C:\Windows\PostInstall\AfterOOBE\assets
goto finish
:finish
reg load HKLM\SOFT C:\Windows\System32\config\SOFTWARE
reg load HKLM\SYS C:\Windows\System32\config\SYSTEM
reg add HKLM\SOFT\Microsoft\Windows\CurrentVersion\Policies\System /v VerboseStatus /t REG_DWORD /d 1 /f
reg add HKLM\SOFT\Microsoft\Windows\CurrentVersion\Policies\System /v EnableCursorSuppression /t REG_DWORD /d 0 /f
reg add HKLM\SYS\Setup /v CmdLine /t REG_SZ /d "cmd /c C:\Windows\PostInstall\postinstall.bat" /f
wpeutil reboot