# Mac Mini

The Mac Mini is a compact desktop computer designed and manufactured by Apple Inc. It is known for its small form factor, making it a versatile and space-efficient choice for users who want the macOS experience without a built-in display.

## Problem with WiFi

After installing Fedora 39 on [Mac mini (Late 2014)](https://support.apple.com/kb/SP710?locale=en_GB), WiFi may not be detected. Follow the steps below to resolve the issue.

## Solution

Credits to [source1](https://jaehoo.wordpress.com/2022/10/10/bye-bye-mac-os-hello-fedora-workstation/) and [source2](https://www.reddit.com/r/Fedora/comments/u6474g/fedora_36_macbook_pro_users_my_wifi_fix/).

1. Connect to internet using USB tethering or Ethernet cable.

2. Download RPM Fusion non-free repository.

   ```shell
   wget http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
   ```

3. Install the downloaded RPM.

   ```shell
   sudo dnf install -y rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
   ```

4. Install Broadcom WiFi driver.

   ```shell
   sudo dnf install -y broadcom-wl
   ```

5. Install the development headers for current kernel

   ```shell
   sudo dnf install kernel-devel
   ```

6. Compile drivers

   ```shell
   sudo akmods --force
   ```

7. Generate module dependencies

   ```shell
   sudo depmod -a
   ```

8. Load `wl` kernel module

   ```shell
   sudo modprobe wl
   ```

9. Reboot

   ```shell
   shutdown -r now
   ```
