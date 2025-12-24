# ms9132-drm-linux

Linux DRM driver for MacroSilicon MS9132/MS9133/MS9135 USB display adapters.

## Supported Devices

| Vendor ID | Product ID | Device |
|-----------|------------|--------|
| 0x345f    | 0x9132     | MS9132 USB Display |
| 0x345f    | 0x9133     | MS9133 USB Display |
| 0x345f    | 0x9135     | MS9135 USB Display |

## Origin & License

- **Original vendor:** MacroSilicon Technology Co., Ltd.
- **License:** GNU General Public License version 2 (GPLv2)
- **Based on:** MS91xx_Linux_Drm_SourceCode_V3.0.3.12

See the [LICENSE](LICENSE) file for the full license text.

## New Features & Fixes

This version includes multiple fixes for modern Linux kernels (6.x+):

### 1. Kernel 6.8+ Support
**Fix:** Updated driver callbacks (`remove` function return type) to match newer Linux Kernel API API requirements. Verified working on `6.8.0-90-generic`.

### 2. Dialog Box Freeze Fix
**Fix:** Changed blocking `mutex_lock()` to non-blocking `mutex_trylock()` in the frame update path. This prevents the entire UI from freezing when dialog boxes or popups appear.

### 3. Kernel Crash Fix
**Fix:** Added comprehensive validation in `usb_hal_thread.c` for buffer access and cursor handling to prevent page faults.

### 4. Reliable Auto-Load (Systemd)
**New:** Included a systemd service (`usbdisp.service`) to reliably load the driver modules on boot, replacing the older/unreliable `/etc/modules` method.

## Build & Install

### Prerequisites

```bash
# Debian/Ubuntu
sudo apt-get install build-essential linux-headers-$(uname -r)

# Fedora
sudo dnf install kernel-devel kernel-headers gcc make

# Arch Linux
sudo pacman -S linux-headers base-devel
```

### Quick Install (Recommended)

One script cleans, builds, installs, and configures the driver to load on startup:

```bash
chmod +x set_startup.sh
sudo bash ./set_startup.sh
```

### Manual Build

```bash
make clean
make
```

### Manual Install & Load

1.  **Copy modules:**
    ```bash
    sudo cp drm/usbdisp_drm.ko /lib/modules/$(uname -r)/extra/
    sudo cp drm/usbdisp_usb.ko /lib/modules/$(uname -r)/extra/
    sudo depmod -a
    ```

2.  **Load modules:**
    ```bash
    sudo modprobe usbdisp_drm
    sudo modprobe usbdisp_usb
    ```

3.  **Configure Auto-Load (Manual Systemd):**
    Copy `usbdisp.service` to `/etc/systemd/system/`, then:
    ```bash
    sudo systemctl daemon-reload
    sudo systemctl enable usbdisp.service
    sudo systemctl start usbdisp.service
    ```

## Configure Display

After loading the driver, the display should appear automatically. If not:

```bash
# List display providers
xrandr --listproviders

# Associate USB display with main GPU (adjust numbers as needed)
xrandr --setprovideroutputsource 1 0

# Check available outputs
xrandr
```

## Tested On

- **Ubuntu 24.04** with kernel **6.8.0-90-generic**
- Dell Vostro 3500 laptop

## Troubleshooting

### Check if driver is loaded
```bash
lsmod | grep usbdisp
```

### Check Service Status
```bash
systemctl status usbdisp.service
```
Should show `Active: active (exited)`.

### Check USB device detection
```bash
lsusb | grep 345f
```

### View driver logs
```bash
sudo dmesg | grep -E "(msdisp|usb_hal|usbdisp)"
```

## Contributing

Issues and pull requests are welcome. When reporting bugs, please include:
- Kernel version (`uname -r`)
- Driver logs (`dmesg | grep msdisp`)
- Steps to reproduce
