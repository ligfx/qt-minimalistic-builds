# 1. Start Visual Studio x64 Native Tools command line.
# 2. Run powershell.exe from Native Tools cmd.
# 3. cd to path of repo.
# 4. Run this script.


$skip = @(
  "qt3d",
  "qtactiveqt",
  "qtandroidextras",
  "qtcanvas3d",
  "qtcharts",
  "qtconnectivity",
  "qtdatavis3d",
  "qtdeclarative",
  "qtdoc",
  "qtfeedback",
  "qtgamepad",
  "qtgraphicaleffects",
  "qtlocation",
  "qtlottie",
  "qtmacextras",
  "qtmultimedia",
  "qtnetwork",
  "qtnetworkauth",
  "qtpurchasing",
  "qtquick3d",
  "qtquickcontrols",
  "qtquickcontrols2",
  "qtquicktimeline",
  "qtremoteobjects",
  "qtscript",
  "qtscxml",
  "qtsensors",
  "qtserialbus",
  "qtserialport",
  "qtspeech",
  "qtsvg",
  "qtvirtualkeyboard",
  "qtwayland",
  "qtwebchannel",
  "qtwebengine",
  "qtwebglplugin",
  "qtwebsockets",
  "qtwebview",
  "qtx11extras",
  "qtxml",
  "qtxmlpatterns",
)
$excludes = $skips | % { "-x!" + $_ }

# Get jom
$env:Path += (";" + $pwd.Path + "\tools")

# Download Qt sources, unpack.
Add-MpPreference -ExclusionPath $pwd.Path
Write-Output "$(Get-Date)"
aria2c "https://download.qt.io/official_releases/qt/5.15/5.15.2/single/qt-everywhere-src-5.15.2.zip.meta4"
Write-Output "$(Get-Date)"
7z x "qt-everywhere-src-5.15.2.zip" -aoa -bsp1 @excludes
Write-Output "$(Get-Date)"
$qt_src = $pwd.Path + "\qt-everywhere-src-5.15.2"
$prefix = $pwd.Path + "\qt-5.15.2-mscv2017-x86_64"
ls
ls "$qt_src"

# Configure.
mkdir "build"
cd "build"

& "$qt_src\configure.bat" -debug-and-release `
    -opensource -confirm-license `
    -platform win32-msvc `
    -list-features `
    -list-modules `
    -opengl desktop `
    -no-iconv -no-dbus -no-icu -no-fontconfig -no-freetype -qt-harfbuzz `
    -nomake examples -nomake tests `
    -skip qt3d `
    -skip qtactiveqt `
    -skip qtandroidextras `
    -skip qtcanvas3d `
    -skip qtcharts `
    -skip qtconnectivity `
    -skip qtdatavis3d `
    -skip qtdeclarative `
    -skip qtdoc `
    -skip qtfeedback `
    -skip qtgamepad `
    -skip qtgraphicaleffects `
    -skip qtlocation `
    -skip qtlottie `
    -skip qtmacextras `
    -skip qtmultimedia `
    -skip qtnetwork `
    -skip qtnetworkauth `
    -skip qtpurchasing `
    -skip qtquick3d `
    -skip qtquickcontrols `
    -skip qtquickcontrols2 `
    -skip qtquicktimeline `
    -skip qtremoteobjects `
    -skip qtscript `
    -skip qtscxml `
    -skip qtsensors `
    -skip qtserialbus `
    -skip qtserialport `
    -skip qtspeech `
    -skip qtsvg `
    -skip qtvirtualkeyboard `
    -skip qtwayland `
    -skip qtwebchannel `
    -skip qtwebengine `
    -skip qtwebglplugin `
    -skip qtwebsockets `
    -skip qtwebview `
    -skip qtx11extras `
    -skip qtxml `
    -skip qtxmlpatterns `
    -mp `
    -D "JAS_DLL=0" `
    -static `
    -feature-relocatable `
    -ltcg `
    -prefix $prefix

# Compile.
& "$tools_folder\jom.exe"
& "$tools_folder\jom.exe" install
#nmake
#nmake install

# Create final archive.
ls
