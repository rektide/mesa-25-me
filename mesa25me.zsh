#!/usr/bin/env zsh

# run this script to generate i386 packages where version 25.0.0-1 has been replaced with 25.0.1-1

set -e

# variables
SOURCE_BASE="http://ftp.us.debian.org/debian/pool/main/m/mesa/"
SOURCE_VERSION=25.0.0-1
DESTINATION_VERSION=25.0.1-1
ARCHITECTURE=i386
PACKAGES=(libegl-mesa0
    libgbm1
    libgl1-mesa-dri
    libglx-mesa0
    mesa-libgallium
    mesa-va-drivers
    mesa-vulkan-drivers
    mesa-vdpau-drivers)

# generate the official filename
deb() {
    echo ${1:-$pkg}_${2:-$SOURCE_VERSION}_${ARCHITECTURE}.deb
}

# Downlaod each deb file
echo downloading
for pkg in ${PACKAGES[@]}
do
    echo pkg $pkg
    wget -N ${SOURCE_BASE}$(deb)
done

set -x

echo rebuilding
sudo rm -rf tmp
for pkg in ${PACKAGES[@]}
do
    echo
    echo "processing $pkg..."

    # Create a temporary directory
    TEMP=tmp/$pkg
    mkdir -p $TEMP

    # Extract the deb file
    sudo dpkg-deb -R $(deb) $TEMP

    # Modify the control file to update the version
    sudo sed -i "s/$SOURCE_VERSION/$DESTINATION_VERSION/g" $TEMP/DEBIAN/control

    # Repackage the deb file with the new version
    sudo dpkg-deb --root-owner-group -b $TEMP $(deb $pkg $DESTINATION_VERSION)
done
