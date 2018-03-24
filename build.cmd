@echo off

::Clean before build
color 0F
rd /s /q build
cls

::Set Environment
set PATH=%ProgramFiles(x86)%\Windows Kits\10\bin\10.0.16299.0\x64;%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin;%ProgramFiles(x86)%\Microsoft Visual Studio\2017\BuildTools\MSBuild\15.0\Bin;%PATH%

echo [92mFinding all required programs...[0m
echo.
where makepri.exe msbuild.exe makeappx.exe makecert.exe pvk2pfx.exe signtool.exe 
echo.
set /p X=[92mAre all six executables present? yes or no (y^|n)?[0m 
if %X%==y goto build
if %X%==n goto end
pause

:build

::Build resources.pri
mkdir build
xcopy Assets build\Assets /E /K /I
copy AppXManifest.xml build
MakePri.exe new /pr build /cf resources.pri.xml /mn build\AppXManifest.xml /of build\resources.pri

::Copy bin and usr folder
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

::Build Launcher
msbuild.exe Launcher\Launcher.csproj
copy Launcher\launcher.exe build\bin
copy Launcher\Launcher.exe.config build\bin
copy wsltty.ico build\bin

::Build Appx package
MakeAppx.exe pack /l /d build /p wsltty.appx
if exist "wsltty.appx" (
goto SignAppx
) else (
echo [91mwsltty.appx is not present...[0m
goto end
)

:SignAppx
set /p X=[92mEnter New Password for PFX file[0m 
set /p Y=[92mEnter the date when the certificate becomes valid (mm/dd/yyyy)[0m 
set /p Z=[92mEnter the date when the certificate expires (mm/dd/yyyy)[0m 
MakeCert.exe -sv privatekeyfile.pvk -n "CN=mintty" certfile.cer -b %Y% -e %Z% -r
Pvk2Pfx.exe -pvk privatekeyfile.pvk -spc certfile.cer -pfx pfxfile.pfx -po %X%
SignTool.exe sign /fd sha256 /a /f pfxfile.pfx /p %X% wsltty.appx

:end
pause
rd /s /q build
::END#