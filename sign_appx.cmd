@echo off

::Set Environment 
cd %~dp0 
color 0F 
title Signing Appx file...
del /f /q privatekeyfile.pvk certfile.cer pfxfile.pfx wsltty.appx >NUL 
set PATH=%ProgramFiles(x86)%\Windows Kits\10\bin\10.0.17134.0\x64;%ProgramFiles(x86)%\Windows Kits\10\bin\10.0.16299.0\x64;%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin;%ProgramFiles(x86)%\Microsoft Visual Studio\2017\BuildTools\MSBuild\15.0\Bin;%PATH%

::Sign Appx 
echo [92mDo you want to sign wsltty.appx?[0m    
pause 

MakeCert.exe -a sha256 -r -sv privatekeyfile.pvk -n "CN=mintty" certfile.cer 
Pvk2Pfx.exe -pvk privatekeyfile.pvk -spc certfile.cer -pfx pfxfile.pfx 

if exist "wsltty_unsigned.appx" (
    copy wsltty_unsigned.appx wsltty.appx 
    SignTool.exe sign /fd sha256 /a /f pfxfile.pfx wsltty.appx 
) else (
echo [91mwsltty_unsigned.appx is not present...[0m    
goto end
)

:end
pause 
exit /b 
::END#
