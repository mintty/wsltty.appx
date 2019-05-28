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
ver=`(cd "$pfx86/Windows Kits/10/bin"; ls -dr 10.*) | sed -e 1q`
sdkpath="$pfx86/Windows Kits/10/bin/$ver/$arch"

PATH="$buildpath:$sdkpath:$PATH"

echo "$buildpath"
echo "$sdkpath"
type makepri || exit 9
type MSBuild || exit 9
type makeappx || exit 9
type makecert || exit 9
type pvk2pfx || exit 9
type signtool || exit 9

#############################################################################
# clean before build

echo cleaning old build artefacts >&2
rm -fr build
rm -f privatekeyfile.pvk certfile.cer pfxfile.pfx wsltty_unsigned.appx

#############################################################################
# build

# build resources.pri
echo copying assets >&2
mkdir build
cp -Rlp Assets build/
cp AppXManifest.xml build/

rm -fr build/resources.pri # or makepri.exe would stall in confirmation prompt
makepri.exe new /pr build /cf resources.pri.xml /mn 'build\AppXManifest.xml' /of 'build\resources.pri'

# copy bin, usr, ico file
echo copying mintty >&2
cp -Rlp bin build/
cp -Rlp usr build/
cp -flp wsltty.ico build/bin/

# build launcher
MSBuild.exe /nologo /verbosity:minimal 'Launcher\Launcher.csproj'
cp Launcher/Launcher.exe Launcher/Launcher.exe.config build/bin/

# build appx package
makeappx.exe pack /l /d build /p wsltty_unsigned.appx

# sign appx
makecert.exe -a sha256 -r -sv privatekeyfile.pvk -n "CN=mintty" certfile.cer
#-> privatekeyfile.pvk certfile.cer
pvk2pfx.exe -pvk privatekeyfile.pvk -spc certfile.cer -pfx pfxfile.pfx
#-> pfxfile.pfx
cp -fp wsltty_unsigned.appx wsltty.appx
signtool.exe sign /fd sha256 /a /f pfxfile.pfx wsltty.appx
#-> wsltty.appx signed

# cleanup
rm -fr build

#############################################################################
# end
