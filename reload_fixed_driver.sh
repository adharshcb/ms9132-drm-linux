#!/bin/bash

# Script to reload the FIXED USB display driver V3.0.3.12
# This version supports device ID 0x9133 AND fixes the dialog box freeze issue
set -e

echo "=========================================="
echo "  USB Display Driver V3.0.3.12 - FIXED"
echo "=========================================="
echo
echo "Fix applied: Changed try_lock from 0 to 1 in msdisp_drm_modeset.c:344"
echo "This prevents blocking mutex locks that caused freezes with dialog boxes."
echo
echo "Step 1: Unloading old modules..."
sudo rmmod usbdisp_drm 2>/dev/null || echo "  usbdisp_drm not loaded"
sudo rmmod usbdisp_usb 2>/dev/null || echo "  usbdisp_usb not loaded"

echo
echo "Step 2: Installing new fixed modules..."
sudo mkdir -p /lib/modules/$(uname -r)/extra/
sudo cp ./drm/usbdisp_drm.ko /lib/modules/$(uname -r)/extra/
sudo cp ./drm/usbdisp_usb.ko /lib/modules/$(uname -r)/extra/

echo
echo "Step 3: Updating module dependencies..."
sudo depmod -a

echo
echo "Step 4: Loading fixed modules..."
sudo modprobe usbdisp_drm
sudo modprobe usbdisp_usb

echo
echo "Step 5: Checking module status..."
lsmod | grep usbdisp

echo
echo "=========================================="
echo "  Driver reloaded successfully!"
echo "=========================================="
echo
echo "USB Device:"
lsusb | grep "345f:9133" || echo "  Device not found!"

echo
echo "Display connectors status:"
ls -1 /sys/class/drm/card0-*/status 2>/dev/null | while read f; do
    echo "  $(basename $(dirname $f)): $(cat $f)"
done

echo
echo "=========================================="
echo "IMPORTANT: You need to restart your display manager for changes to take effect:"
echo "  sudo systemctl restart display-manager"
echo
echo "OR reboot your system for a clean start."
echo "=========================================="
echo
echo "After restart, configure the display using:"
echo "  xrandr --listproviders"
echo "  xrandr --setprovideroutputsource 1 0"
echo "  xrandr  # to see available outputs and configure resolution"
echo
