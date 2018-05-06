## Requirements

* [Windows 10 SDK] 
* [VS Build Tools] 

Download only MSBuildTools Workload (for .NET framework) with this command: `vs_BuildTools.exe --layout C:\BuildTools --add Microsoft.VisualStudio.Workload.MSBuildTools --lang en-US`. This will create a offline installer of MSBuild in `C:\BuildTools` folder. This requires to compile Launcher executable only. 

Windows SDK tools can be found in `%ProgramFiles(x86)%\Windows Kits\10\bin\10.0.16299.0\x64\` folder. MSBuild Tools can be found in `%ProgramFiles(x86)%\Microsoft Visual Studio\2017\BuildTools\MSBuild\15.0\Bin\` folder. These are the default folder and may be changed if you install SDK and Build Tools of different versions and in different folder.

## How to build

* Clone this GitHub repository with `git clone https://github.com/mintty/wsltty.appx.git` and open command prompt in the clone directory.

* Make a folder (e.g. `build`), copy `AppxManifest.xml` file and `Assets` folder (with all PNG images) in that folder.

* Create a configuration file (e.g. `resources.pri.xml`):
    `MakePri createconfig /cf resources.pri.xml /dq en-US /pv 10.0.0` 

* Remove these lines from that XML file:

```xml 
<packaging>
    <autoResourcePackage qualifier="Language"/>
    <autoResourcePackage qualifier="Scale"/>
    <autoResourcePackage qualifier="DXFeatureLevel"/>
</packaging>
```

* Make resources.pri: 
    `MakePri.exe new /pr build /cf resources.pri.xml /mn build\AppXManifest.xml /of build\resources.pri` 

* Build Launcher: 
    `msbuild.exe /nologo /verbosity:minimal Launcher\Launcher.csproj` 

* Copy `Launcher.exe` and `Launcher.exe.config` files in `build\bin` folder. Then copy language and theme files and make `charnames.txt` from mintty repository. Place all the required executables and required user files in build folder as follows:

``` 
build\
|
+---AppxManifest.xml
+---resources.pri
|   
+---Assets\ (all .png files)
|
+---bin\
|   |
|   +---cygwin-console-helper.exe
|   +---cygwin1.dll
|   +---Launcher.exe
|   +---Launcher.exe.config
|   +---mintty.exe
|   +---wslbridge-backend
|   +---wslbridge.exe
|   +---wsltty.ico
|
+---usr\
    |
    +---share\
        |
        +---mintty\
            |
            |---info\
            |   |
            |   +---charnames.txt
            |
            +---lang\ (all .po files)
            |
            +---themes\ (all themes)
```

* Make Appx package: 
     `MakeAppx.exe pack /l /d build /p wsltty.appx` 

* Make certificate: 
    `MakeCert -sv privatekeyfile.pvk -n "CN=mintty" certfile.cer -b mm/dd/yyyy -e mm/dd/yyyy -r` 

* Make PFX: 
    `PVK2PFX –pvk privatekeyfile.pvk –spc certfile.cer –pfx pfxfile.pfx –po yourpfxpassword` 

* Sign Appx: 
    `SignTool.exe sign /fd sha256 /a /f pfxfile.pfx /p yourpfxpassword wsltty.appx` 

* Install Certificate:  Double click on `certfile.cer` file > Click on "Install Certificate" > Choose "Local Machine" > Choose "Place Certificate in the following store" > Click on "Browse" > Scroll down and choose only "Trusted People". The file name, `certfile.cer` can be changed. Alternatively, install certificate with this command as administrator: 
        certutil -addstore TrustedPeople certfile.cer 

## Further Reading

* Microsoft Docs:

  - [How to: Create Your Own Test Certificate](https://msdn.microsoft.com/en-in/library/ff699202.aspx)
  - [Using SignTool to Sign a File](https://msdn.microsoft.com/en-us/library/windows/desktop/aa388170(v=vs.85).aspx)
  - [Guidelines for tile and icon assets](https://docs.microsoft.com/en-us/windows/uwp/design/shell/tiles-and-notifications/app-assets)
  - [Handling data in a converted desktop app with the Desktop Bridge](https://blogs.msdn.microsoft.com/appconsult/2017/03/06/handling-data-in-a-converted-desktop-app-with-the-desktop-bridge/)
  - [Accessing to the files in the installation folder in a Desktop Bridge application](https://blogs.msdn.microsoft.com/appconsult/2017/06/23/accessing-to-the-files-in-the-installation-folder-in-a-desktop-bridge-application/)
  - [Create an app package with the MakeAppx.exe tool](https://docs.microsoft.com/en-us/windows/uwp/packaging/create-app-package-with-makeappx-tool)
  - [MakePri.exe command-line options](https://docs.microsoft.com/en-us/windows/uwp/app-resources/makepri-exe-command-options)

* StackOverflow Q&A:

  - [Why is makepri.exe creating more than one Resources.pri file?](https://stackoverflow.com/questions/38506783/)
  - [Why does not UWP app copy file to AppData folder?](https://stackoverflow.com/questions/48849076/)
  - [How to add executable parameter in start menu shortcut?](https://stackoverflow.com/questions/48792003/)
  - [why do I keep getting a failed when trying to make a .cer for testing?](https://stackoverflow.com/questions/9506671/)

<!--Links-->

[Windows 10 SDK]: https://developer.microsoft.com/en-us/windows/downloads/windows-10-sdk 
[VS Build Tools]: https://www.visualstudio.com/downloads/#build-tools-for-visual-studio-2017 

<!--END-->