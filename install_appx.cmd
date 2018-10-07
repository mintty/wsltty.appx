@echo off

::Check administrator privilege
fsutil dirty query %systemdrive% >nul
if %errorlevel% == 0 (
    goto Options
) else (
    echo [91mError: Access denied...[0m
    echo [91mRun this batch file as administrator...[0m
    pause
    exit /b
)

:Options
cd %~dp0
color 0F
title Installing wsltty.appx...

set /p choice=[92mInstall (i) or Uninstall (u). Press "i" or "u"?[0m 
if %choice%==i goto Install
if %choice%==u goto Uninstall
pause

:Install
echo.
echo [92mEnabling Developer Mode...[0m
set X="HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
reg add %X% /V "AllowAllTrustedApps" /T REG_DWORD /D "1" /F
reg add %X% /V "AllowDevelopmentWithoutDevLicense" /T REG_DWORD /D "1" /F

echo.
echo [92mAdding certificate to Trusted People Store...[0m
certutil -addstore TrustedPeople certfile.cer
echo.
echo [92mInstalling Appx Package...[0m
Powershell Add-AppxPackage -Path wsltty.appx
pause
exit /b

:Uninstall
echo.
echo [92mDisabling Developer Mode...[0m
set X="HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
reg delete %X% /V "AllowAllTrustedApps" /F
reg delete %X% /V "AllowDevelopmentWithoutDevLicense" /F

echo.
echo [92mRemoving certificate from Trusted People Store...[0m
certutil -delstore TrustedPeople mintty
echo.
echo [92mUninstalling Appx Package...[0m
Powershell Get-AppxPackage *wsltty* ^| Remove-AppxPackage
pause
exit /b
::END#
