#!/bin/bash

# Exit immediately if any command fails
set -e

echo "Cleaning previous builds..."
make clean

echo "Compiling modules..."
make

# Wait a bit to ensure build completes
sleep 2

# Ensure the target directory exists with proper permissions
if [ -f /lib/modules/$(uname -r)/extra ]; then
    echo "Removing file blocking /lib/modules/$(uname -r)/extra..."
    sudo rm -f /lib/modules/$(uname -r)/extra
fi

echo "Creating module directory..."
sudo mkdir -p /lib/modules/$(uname -r)/extra/

echo "Copying modules..."
sudo cp ./drm/usbdisp_drm.ko /lib/modules/$(uname -r)/extra/
sudo cp ./drm/usbdisp_usb.ko /lib/modules/$(uname -r)/extra/

echo "Updating module dependencies..."
sudo depmod -a

echo "Modules installed successfully."
echo "You can now load them using:"
echo "  sudo modprobe usbdisp_drm"
echo "  sudo modprobe usbdisp_usb"
