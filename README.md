# wsltty.appx

Windows Store Appx package of Wsltty, terminal for Windows Subsystem for Linux with Mintty.

## How to build

### Get wsltty

Clone, or download and unpack, the [wsltty.appx] repository. 
Download the wsltty.zip file from [wsltty.appx releases]. 
Extract the whole `/bin` and `/usr` folder from wsltty.zip 
and **place those folders in the previous clone directory** (i.e. of wsltty.appx repository).

### Install MS development tools

* Install [Windows SDK](https://developer.microsoft.com/windows/downloads/windows-10-sdk)
  for the tools `makepri.exe`, `makeappx.exe`, `makecert.exe`, `pvk2pfx.exe`, `signtool.exe`
* Install [Build Tools for Visual Studio](https://www.visualstudio.com/thank-you-downloading-visual-studio/?sku=BuildTools&rel=15)
  from the [Visual Studio download page](https://www.visualstudio.com/downloads/)
  for the tool `msbuild.exe`

### Build wsltty app

Now run the `build.cmd` batch file. You will be asked to enter password three times for creating CER, PVK and PFX files.

## How to install

### Certificate

Activate / double-click the certificate file, ...

### App

Activate / double-click `wsltty.appx`.

## Customization

* Change tile background color: Change the hex value of `BackgroundColor` attribute of `uap:VisualElements` tag in AppxManifest.xml file. Find more HEX color code at [W3Schools Colors Hexadecimal].
* Change wsltty.ico file: The wsltty.ico was made using GIMP from [NewTux.SVG]. Make 16px, 24px, 32px, 48px, 128px and 256px sizes .PNG files and combine them into .ICO file using GIMP.
* Change Assets: Change any image in Assets folder. Just make sure to name the .PNG file according to the previous file and maintain its resolution.

## Developers

For further details, read the [developers page] carefully.

<!--Links-->
[developers page]: DEVELOP.md
[wsltty.appx]: https://github.com/mintty/wsltty.appx.git
[wsltty.appx releases]: https://github.com/mintty/wsltty.appx/releases
[W3Schools Colors Hexadecimal]: https://www.w3schools.com/colors/colors_hexadecimal.asp
[NewTux.SVG]: https://commons.wikimedia.org/wiki/File:NewTux.svg

<!--END-->
