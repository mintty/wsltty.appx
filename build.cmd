@echo off

::Clean before build 
cd %~dp0 
color 0F 
title Building wsltty Appx package... 
rd /S /Q build >NUL 
del /F /Q privatekeyfile.pvk certfile.cer pfxfile.pfx wsltty_unsigned.appx wsltty.appx >NUL 
cls 

::Set Environment 
echo [92mSetting command line environment...[0m    
set PATH=%ProgramFiles(x86)%\Windows Kits\10\bin\10.0.17134.0\x64;%ProgramFiles(x86)%\Windows Kits\10\bin\10.0.16299.0\x64;%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin;%ProgramFiles(x86)%\Microsoft Visual Studio\2017\BuildTools\MSBuild\15.0\Bin;%PATH% 

echo. 
echo [92mFinding all required programs...[0m    
echo. 
where makepri.exe msbuild.exe makeappx.exe makecert.exe pvk2pfx.exe signtool.exe 
echo. 
set /p choice=[92mAre all six executables present? yes or no (y^|n)?[0m    
if %choice%==y goto build 
if %choice%==n goto end 
pause 

:build

::Build resources.pri 
mkdir build 
xcopy Assets build\Assets /E /K /I 
copy AppXManifest.xml build 
MakePri.exe new /pr build /cf resources.pri.xml /mn build\AppXManifest.xml /of build\resources.pri 
echo. 

::Copy bin, usr folder and ico file 
echo [92mCheck if bin and usr folder is present...[0m    
pause 
if exist "bin" (
    xcopy bin build\bin /E /K /I 
) else (
    echo [91mbin folder absent...[0m    
    goto end 
)
if exist "usr" (
    xcopy usr build\usr /E /K /I 
) else (
    echo [91musr folder absent...[0m    
    goto end 
)
copy wsltty.ico build\bin 
echo. 

::Build Launcher 
echo [92mCompiling Launcher...[0m    
msbuild.exe /nologo /verbosity:minimal Launcher\Launcher.csproj 
copy Launcher\Launcher.exe build\bin 
copy Launcher\Launcher.exe.config build\bin 
copy wsltty.ico build\bin 
echo. 

::Build Appx package
echo [92mDo you want to make Appx Package?...[0m    
pause 
MakeAppx.exe pack /l /d build /p wsltty_unsigned.appx 
if exist "wsltty_unsigned.appx" (
goto SignAppx
) else (
echo [91mwsltty_unsigned.appx is not present...[0m    
goto end
)

:SignAppx
echo [92mDo you want to sign wsltty.appx?[0m    
pause
MakeCert.exe -a sha256 -r -sv privatekeyfile.pvk -n "CN=mintty" certfile.cer 
Pvk2Pfx.exe -pvk privatekeyfile.pvk -spc certfile.cer -pfx pfxfile.pfx 
copy wsltty_unsigned.appx wsltty.appx 
SignTool.exe sign /fd sha256 /a /f pfxfile.pfx wsltty.appx 

:end
pause 
rd /S /Q build 
exit /b 
::END#
