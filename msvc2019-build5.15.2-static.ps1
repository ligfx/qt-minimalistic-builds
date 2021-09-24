# 1. Start Visual Studio x64 Native Tools command line.
# 2. Run powershell.exe from Native Tools cmd.
# 3. cd to path of qt5-minimalistic-builds repo.

# $version_base = "5.15"
# $version = "5.15.2"

# $qt_sources_url = "https://download.qt.io/official_releases/qt/" + $version_base + "/" + $version + "/single/qt-everywhere-src-" + $version + ".tar.xz.meta4"
# $qt_archive_file = $qt_sources_url.split('/')[-1] -replace "\.meta4$"
# $qt_src_base_folder = $pwd.Path + "\qt-everywhere-src-" + $version

# $tools_folder = $pwd.Path + "\tools\"
# $type = "static"
# $install_folder = $pwd.Path + "\qt-5.15.2-mscv2017-x86_64"
# $prefix_folder = $pwd.Path + "\" + $prefix_base_folder
# $build_folder = $pwd.Path + "\bld"


# Download Qt sources, unpack.
Add-MpPreference -ExclusionPath $pwd.Path
Write-Output "$(Get-Date)"
aria2c "https://download.qt.io/official_releases/qt/5.15/5.15.2/single/qt-everywhere-src-5.15.2.zip.meta4"
Write-Output "$(Get-Date)"

Add-Type -Assembly "System.IO.Compression.Filesystem"
[System.IO.Compression.ZipFile]::ExtractToDirectory("qt-everywhere-src-5.15.2.zip", ".", $true)

# 7z x "qt-everywhere-src-5.15.2.zip" -aoa
# Expand-Archive "qt-everywhere-src-5.15.2.zip"
Write-Output "$(Get-Date)"
# 7z x "qt-everywhere-src-5.15.2.tar.xz" -aoa -bb
# 7z x "qt-everywhere-src-5.15.2.tar" -aoa -bb
$qt_src_base_folder = $pwd.Path + "\qt-everywhere-src-5.15.2"
$install_folder = $pwd.Path + "\qt-5.15.2-mscv2017-x86_64"
ls

# Configure.
mkdir "build"
cd "build"

& "$qt_src_base_folder\configure.bat" -debug-and-release \
    -opensource -confirm-license \
    -platform win32-msvc2017 \
    -list-modules \
    -opengl desktop \
    -no-iconv -no-dbus -no-icu -no-fontconfig -no-freetype -qt-harfbuzz \
    -nomake examples -nomake tests \
    -skip qt3d \
    -skip qtactiveqt \
    -skip qtandroidextras \
    -skip qtcanvas3d \
    -skip qtcharts \
    -skip qtconnectivity \
    -skip qtdatavis3d \
    -skip qtdoc \
    -skip qtgamepad \
    -skip qtgraphicaleffects \
    -skip qtlocation \
    -skip qtlottie \
    -skip qtmacextras \
    -skip qtmultimedia \
    -skip qtnetwork \
    -skip qtnetworkauth \
    -skip qtpurchasing \
    -skip qtquick3d \
    -skip qtquickcontrols \
    -skip qtquickcontrols2 \
    -skip qtquicktimeline \
    -skip qtremoteobjects \
    -skip qtscript \
    -skip qtscxml \
    -skip qtsensors \
    -skip qtserialbus \
    -skip qtserialport \
    -skip qtspeech \
    -skip qtsvg \
    -skip qtvirtualkeyboard \
    -skip qtwayland \
    -skip qtwebchannel
    -skip qtwebengine \
    -skip qtwebsockets \
    -skip qtwebview \
    -skip qtx11extras \
    -skip qtxml \
    -skip qtxmlpatterns \
    -mp \
    -D "JAS_DLL=0" \
    -static \
    -feature-relocatable \
    -ltcg \
    -prefix $prefix_folder

# Compile.
& "$tools_folder\jom.exe"
& "$tools_folder\jom.exe" install
#nmake
#nmake install

# Create final archive.
ls
# 7z a -t7z "${prefix_base_folder}.7z" "$prefix_folder" -mmt -mx9
