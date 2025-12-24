#!/bin/bash

# Exit immediately if any command fa#!/bin/bash
set -e

echo "[INFO] Starting driver installation..."

echo "[INFO] Cleaning previous builds..."
# 1. Build clean driver (removes the log spam)
make clean && make

echo "[INFO] Unloading existing modules..."
# 2. Install to system
sudo rmmod usbdisp_drm usbdisp_usb || true

echo "[INFO] Removing old drivers from system folder..."
sudo rm -f /lib/modules/$(uname -r)/extra/usbdisp_drm.ko
sudo rm -f /lib/modules/$(uname -r)/extra/usbdisp_usb.ko

echo "[INFO] Installing new drivers..."
sudo cp drm/usbdisp_drm.ko /lib/modules/$(uname -r)/extra/
sudo cp drm/usbdisp_usb.ko /lib/modules/$(uname -r)/extra/
sudo depmod -a

echo "[INFO] Configuring startup..."
# 3. Configure startup (adds to /etc/modules if not already there)
echo "[INFO] Configuring startup via systemd service (using bash wrapper for absolute paths)..."
# 3. Configure systemd service (loads from /lib/modules/$(uname -r)/extra/)
sudo cp usbdisp.service /etc/systemd/system/
sudo systemctl daemon-reload
# Re-enable to ensure it picks up the change
sudo systemctl enable usbdisp.service
sudo systemctl restart usbdisp.service

echo "[SUCCESS] Driver installed and configured for startup."
# 4. Load now
sudo modprobe usbdisp_drm
sudo modprobe usbdisp_usb

echo "[INFO] Restarting display manager to detect new driver..."
# Restart display manager to pick up the new driver immediately
sudo systemctl restart display-manager

echo "[SUCCESS] Driver installed and configured for startup."
