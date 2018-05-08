# wsltty.appx

Windows Store Appx package of wsltty, terminal for Windows Subsystem for Linux with mintty. mintty is the [Cygwin] Terminal emulator, also available for [MSYS] and [Msys2].

## How to install

Download the 3 files attached to the release in the
[Release area](https://github.com/mintty/wsltty.appx/releases):
the appx package `wsltty.appx`,
the installation certificate `certfile.cer`,
and the install script `install_appx.cmd` (also in the repository).

Run the `install_appx.cmd` batch script as administrator.

### What the installer does

The installer batch script enables Developer Mode with two registry settings
(for Appx sideloading).
Then it installs the certificate `certfile.cer` to
TrustedPeople certificate store in Local Machine.
This allows to install the Appx package with `Add-AppxPackage` cmdlet
from Powershell. With uninstall option, these steps will be reversed.

<img height=258 align=right src=wsltty.appx.png>

### Manual installation

You can install the certificate as described in the [Developers page](DEVELOP).

Then run (double-click) the appx package to install it.

<br clear=all>

## How to build

Read the **[developers page]** to know how to build this Appx package.

## How it works

The Appx package will be installed in `C:\ProgramFiles\WindowsApps\mintty.wsltty-xyz` folder. When it is launched the Launcher copies `wslbridge-backend` to `C:\Users\user_name\AppData\Local\packages\mintty.wsltty-xyz\LocalCache` folder. The Launcher also configures correct paths for icon and mintty configuration file (.minttyrc or mintty.config). Then mintty and wslbridge are executed from same `WindowsApps` folder . But the backend executes from `LocalCache` folder because there are restrictions to execute backend from `WindowsApps`. The Launcher may be removed in future releases.

## Authors

* Thomas Wolff – mintty
* Ryan Prichard – wslbridge
* Biswapriyo Nath – appx build, certification and installation

and others.

## License

This project is licensed under the GNU Public License v3 or higher – see the [LICENSE.mintty](LICENSE.mintty) file for details. You are free to study, modify, distribute the source code and publish your own version.

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
