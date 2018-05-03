#! /bin/sh

#############################################################################
# set tool path

pfx86=`env | sed -e "s,^ProgramFiles(x86)=,," -e t -e d`
pfx86=`cygpath "$pfx86"`

buildpath="$pfx86/Microsoft Visual Studio/2017/BuildTools/MSBuild/15.0/Bin"

case `uname -m` in
i686)	arch=x86;;
x86_64)	arch=x64;;
*)	echo unknown uname -m; exit;;
esac
sdkpath="$pfx86/Windows Kits/10/bin/10.0.16299.0/$arch"

PATH="$buildpath:$sdkpath:$PATH"

#############################################################################
# clean before build

rm -fr build
rm -f privatekeyfile.pvk certfile.cer pfxfile.pfx wsltty.appx

#############################################################################
# build

# build resources.pri
mkdir build
cp -Rlp Assets build/
cp AppXManifest.xml build/

makepri.exe new /pr build /cf resources.pri.xml /mn 'build\AppXManifest.xml' /of build\resources.pri

# copy bin, usr, ico file
cp -Rlp bin build/
cp -Rlp usr build/
cp -lp wsltty.ico build/bin/

# build launcher
MSBuild.exe 'Launcher\Launcher.csproj'
cp Launcher/Launcher.exe Launcher/Launcher.exe.config build/bin/

# build appx package
makeappx.exe pack /l /d build /p wsltty.appx

# sign appx
makecert.exe -a sha256 -r -sv privatekeyfile.pvk -n "CN=mintty" certfile.cer
pvk2pfx.exe -pvk privatekeyfile.pvk -spc certfile.cer -pfx pfxfile.pfx
signtool.exe sign /fd sha256 /a /f pfxfile.pfx wsltty.appx

# cleanup
rm -fr build

#############################################################################
# end
