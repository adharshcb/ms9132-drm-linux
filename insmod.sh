#编译以及加载的示例脚本
make clean
make
sleep 5
sudo insmod ./drm/usbdisp_drm.ko
sudo insmod ./drm/usbdisp_usb.ko
sleep 2
sudo systemctl restart display-manager
lsmod | grep usbdisp
