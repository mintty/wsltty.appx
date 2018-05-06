# wsltty.appx

Windows Store Appx package of wsltty, terminal for Windows Subsystem for Linux with mintty. mintty is the [Cygwin] Terminal emulator, also available for [MSYS] and [Msys2]. 

## How to install

Run the `install_appx.cmd` batch script as administrator. This batch script enables Developer Mode with two registry settings (for Appx sideloading). Then it installs the certificate `certfile.cer` to TrustedPeople certificate store in Local Machine. This allows to install the Appx package with `Add-AppxPackage` cmdlet from Powershell. With uninstall option, these steps will be done in reverse. 

## Project Overview

* Assets: All the PNG images for start menu tiles and taskbar icons. Splash and wide images are not added as those distort the Tux image. 
* Launcher: C# source code and project file for Launcher to launch `mintty` with proper arguments. 
* AppxManifest.xml: This XML file contains information the system needs to deploy, display, or update a Universal Windows Platform (UWP) app. This info includes package identity, package dependencies, required capabilities, visual elements, and extensibility points. 
* NewTux.svg: A SVG image to create all the Assets and wsltty.ico file. Source: https://commons.wikimedia.org/wiki/File:NewTux.svg and Based on original image by Larry Ewing, made in GIMP. Attribution: lewing@isc.tamu.edu Larry Ewing and The GIMP. 
* resource.pri.xml: A XML file to create PRI file with `MakePri.exe` command line tool. A PRI file is an index of application resources (i.e. strings, files, etc). This file is generated with `MakePri.exe createconfig` command. 
* resources.pri_dump.xml: A XML file is created (or dumped) after making resources.pri file. This does not require for building process. One can dump this XML file from PRI file with `MakePri.exe dump` command and compare that to check if anything is missing or changed. 
* wsltty.ico: An icon file for mintty window. 

## Customization

* Change tile background color: Change the hex value of `BackgroundColor` attribute of `uap:VisualElements` tag in AppxManifest.xml file. Find more HEX color code at [W3Schools Colors Hexadecimal].
* Change wsltty.ico file: The wsltty.ico was made using GIMP from [NewTux.SVG]. Make 16px, 24px, 32px, 48px, 128px and 256px sizes .PNG files and combine them into .ICO file using GIMP. 
* Change Assets: Change any image in Assets folder. Just make sure to name the .PNG file according to the previous file and maintain it's resolution. 
* Change locale: Replace `en-US` in `resources.pri.xml` and `AppxManifest.xml` file with your own locale. e.g. `en-GB` for UK, `fr-FR` for France, `el-GR` for Greek etc. 

## How to build

Read the **[developers page]** to know how to build this Appx package. 

## How it works

The Appx package will be installed in `C:\ProgramFiles\WindowsApps\mintty.wsltty-xyz` folder. When it is launched the Launcher copies `wslbridge-backend` to `C:\Users\user_name\AppData\Local\packages\mintty.wsltty-xyz\LocalCache` folder. The Launcher also configures correct paths for icon and mintty configuration file (.minttyrc or mintty.config). Then mintty and wslbridge are executed from same `WindowsApps` folder . But the backend executes from `LocalCache` folder because there are restrictions to execute backend from `WindowsApps`. The Launcher may be removed in future releases. 

## Authors

* Thomas Wolff - mintty 
* Ryan Prichard - wslbridge 

and others. 

## License

This project is licensed under the GNU Public License v3 or higher - see the [LICENSE.mintty](LICENSE.mintty) file for details. You are free to study, modify, distribute the source code and publish your own version. 

<!--Links-->

[Cygwin]: https://www.cygwin.com/ 
[MSYS]: http://mingw.org/wiki/MSYS 
[Msys2]: https://github.com/msys2 
[developers page]: DEVELOP.md 
[wsltty.appx]: https://github.com/mintty/wsltty.appx.git 
[wsltty.appx releases]: https://github.com/mintty/wsltty.appx/releases 
[W3Schools Colors Hexadecimal]: https://www.w3schools.com/colors/colors_hexadecimal.asp 
[NewTux.SVG]: https://commons.wikimedia.org/wiki/File:NewTux.svg 

<!--END-->
