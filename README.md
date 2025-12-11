NOTE: This directory is intended to be published as the root of the ms9132-drm-linux repository.

ms9132-drm-linux
=================

Short description
-----------------
This repository contains the MacroSilicon MS9132 Linux DRM driver sources (USB display adapter driver). The files in `DRM_SourceCode_V3.0.3.12` were extracted from the vendor source distribution and adapted here for distribution under the original license.

Origin & Attribution
--------------------
- Original vendor: MacroSilicon Technology Co., Ltd.
- Upstream/source archive referenced: `MS91xx_Linux_Drm_SourceCode_V3.0.1.3.zip` (as noted in the distributed sources).
- This repository includes source files found in `DRM_SourceCode_V3.0.3.12`.

License
-------
All source files in this repository are licensed under the GNU General Public License version 2 (GPLv2). See the `DRM_SourceCode_V3.0.3.12/LICENSE` file or the top-level `LICENSE` file for the full text.

What is included here
----------------------
- `DRM_SourceCode_V3.0.3.12/` — the DRM and HAL sources, build scripts, and vendor-provided artifacts.
- Utility scripts: `insmod.sh`, `reload_fixed_driver.sh`, and helper files inside the `DRM_SourceCode_V3.0.3.12` directory.

Build & install (basic)
-----------------------
These are general steps — your distribution and kernel version may require adjustments.

1. Install kernel headers and build dependencies for your running kernel (example for Debian/Ubuntu):

```bash
sudo apt-get install build-essential linux-headers-$(uname -r)
```

2. Build the driver (kbuild)

```bash
cd DRM_SourceCode_V3.0.3.12
make
```

If building against a different kernel version, set `KVER` or `KDIR` when invoking `make`. See the included `Makefile`.

3. Load the modules (example)

```bash
cd DRM_SourceCode_V3.0.3.12
sudo ./insmod.sh
```

Or use `insmod`/`modprobe` directly with the built `.ko` files from `drm/`.

Notes and warnings
------------------
- Kernel modules and compiled objects included in vendor archives (e.g., `.o`, `.ko`) may not be portable across kernel versions — prefer building on-target.
- This driver interacts with the kernel USB and DRM subsystems; load/unload only with appropriate privileges and care.
- If you redistribute modified versions, comply with GPLv2 requirements: preserve copyright notices, include license text, and provide source.

How to cite/source
------------------
If you publish or distribute this code, include a note linking back to the original vendor archive and this repository. Example sentence to include in a `NOTICE` or documentation:

"Driver sources based on MacroSilicon MS91xx/MS9132 Linux DRM source (MS91xx_Linux_Drm_SourceCode_V3.0.1.3.zip) and distributed under GPLv2."

Next recommended steps
----------------------
- Review and remove any compiled artifacts you do not want in the repository (e.g., `.o`, `.ko`, intermediate build files). These are present currently; consider adding a `.gitignore` to exclude them if you plan to keep the repo source-only.
- Optionally rename repo to `ms9132-drm-linux` (recommended) when creating the remote on GitHub.

Recent changes (from git commits)
--------------------------------
- `dcf32ac` (2025-12-11) — Add USB HAL interface and implementation for MacroSilicon chips 913x and 912.
- `9bfefaa` (2025-12-11) — Update READMEs for `ms9132-drm-linux` rename and add `.gitignore`.
- `ed75db2` (2025-12-11) — Add README: origin, license, build and usage for ms9132 DRM.
- `5fbc06e` (2025-12-11) — Add DRM_SourceCode_V3.0.3.12 DRM source (expanded) and GPLv2 LICENSE.

Build note (local test)
----------------------
- I built the driver locally (kbuild) on this host; the build completed successfully and produced kernel modules in `drm/`:

```
drm/usbdisp_drm.ko
drm/usbdisp_usb.ko
```

`modinfo` on these modules reports `vermagic: 6.8.0-88-generic`, so they were built against the headers found on this machine.

Contact / Issues
----------------
Create issues in the repository or contact the maintainer(s) listed in repository metadata.
