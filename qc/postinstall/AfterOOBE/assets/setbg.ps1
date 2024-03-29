set-itemproperty -path "HKCU:Control Panel\Desktop" -name WallPaper -value "C:\Users\zegs32\Downloads\qc\postinstall\AfterOOBE\assets\bg.bmp"
cmd /c "RUNDLL32.EXE USER32.DLL,UpdatePerUserSystemParameters ,1 ,True"
pause