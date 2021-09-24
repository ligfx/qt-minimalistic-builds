# 1. Start Visual Studio x64 Native Tools command line.
# 2. Run powershell.exe from Native Tools cmd.
# 3. cd to path of qt5-minimalistic-builds repo.

$version_base = "5.15"
$version = "5.15.2"

$qt_sources_url = "https://download.qt.io/official_releases/qt/" + $version_base + "/" + $version + "/single/qt-everywhere-src-" + $version + ".zip"
$qt_archive_file = $pwd.Path + "\qt-" + $version + ".zip"
$qt_src_base_folder = $pwd.Path + "\qt-everywhere-src-" + $version

$tools_folder = $pwd.Path + "\tools\"
$type = "static"
$prefix_base_folder = "qt-" + $version + "-" + $type + "-msvc2019-x86_64"
$prefix_folder = $pwd.Path + "\" + $prefix_base_folder
$build_folder = $pwd.Path + "\bld"

# Download aria2, unpack
$aria2_binary_url = "https://github.com/aria2/aria2/releases/download/release-1.36.0/aria2-1.36.0-win-64bit-build1.zip"
$aria2_archive_file = $aria2_binary_url.split('/')[-1]
$aria2_folder = $aria2_archive_file -replace "\.zip$"
Invoke-WebRequest -Uri "$aria2_binary_url" -OutFile $aria2_archive_file
Expand-Archive $aria2_archive_file -DestinationPath $aria2_folder
ls
ls aria2
exit

# Download Qt sources, unpack.
# $AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
# [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols

Invoke-WebRequest -Uri $qt_sources_url -OutFile $qt_archive_file
& "$tools_folder\7za.exe" x $qt_archive_file

# Configure.
mkdir $build_folder
cd $build_folder

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
nmake
nmake install

# Create final archive.
& "$tools_folder\7za.exe" a -t7z "${prefix_base_folder}.7z" "$prefix_folder" -mmt -mx9
