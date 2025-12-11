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

## Bug Fixes Applied

This version includes fixes for critical issues in the original driver:

### 1. Dialog Box Freeze Fix
**Problem:** Opening dialog boxes (file pickers, popups) caused the entire UI to freeze.

**Cause:** The driver used blocking `mutex_lock()` in the frame update path, causing cascading blockage during rapid frame updates.

**Fix:** Changed to non-blocking `mutex_trylock()` in `drm/msdisp_drm_modeset.c`. When the lock is busy, frames are skipped instead of blocking the UI.

### 2. Kernel Crash Fix
**Problem:** System crashed with page fault in `usb_hal_state_machine` when dialogs appeared.

**Cause:** Missing bounds checking and NULL pointer validation in cursor buffer handling code.

**Fix:** Added comprehensive validation in `usb_hal/usb_hal_thread.c`:
- NULL pointer checks for all buffer accesses
- Bounds validation for cursor buffer offsets
- Dimension validation before buffer operations
- Prevention of out-of-bounds memory access in cursor blending loop

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

### Build

```bash
make clean
make
```

### Install & Load

```bash
# Quick reload (unloads old, installs new, loads modules)
sudo ./reload_fixed_driver.sh

# Or manually:
sudo cp drm/usbdisp_drm.ko /lib/modules/$(uname -r)/extra/
sudo cp drm/usbdisp_usb.ko /lib/modules/$(uname -r)/extra/
sudo depmod -a
sudo modprobe usbdisp_drm
sudo modprobe usbdisp_usb
```

### Configure Display

After loading the driver:

```bash
# List display providers
xrandr --listproviders

# Associate USB display with main GPU (adjust numbers as needed)
xrandr --setprovideroutputsource 1 0

# Check available outputs
xrandr
```

## Kernel Module Info

The driver produces two kernel modules:
- `usbdisp_drm.ko` - DRM (Direct Rendering Manager) driver
- `usbdisp_usb.ko` - USB HAL (Hardware Abstraction Layer) driver

## Tested On

- Ubuntu 24.04 with kernel 6.8.0-88-generic
- Dell Vostro 3500 laptop

## Known Limitations

- Some applications with custom cursor rendering (e.g., Postman) may have invisible cursors on the USB display. The cursor functionality works (items highlight on hover), but the cursor image may not be visible.

## Troubleshooting

### Check if driver is loaded
```bash
lsmod | grep usbdisp
```

### Check USB device detection
```bash
lsusb | grep 345f
```

### View driver logs
```bash
sudo dmesg | grep -E "(msdisp|usb_hal|usbdisp)"
```

### Check driver statistics
```bash
cat /sys/bus/usb/drivers/msdisp_usb/*/frame
```

## Contributing

Issues and pull requests are welcome. When reporting bugs, please include:
- Kernel version (`uname -r`)
- Driver logs (`dmesg | grep msdisp`)
- Steps to reproduce

## Credits

- Original driver: MacroSilicon Technology Co., Ltd.
- Bug fixes: Community contributions
