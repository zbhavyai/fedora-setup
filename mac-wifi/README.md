# WiFi Connectivity

After installing Fedora 39 on [Mac mini (Late 2014)](https://support.apple.com/kb/SP710?locale=en_GB), WiFi may not be detected. Follow the steps below to resolve the issue.

## Solution

Credits to [source1](https://jaehoo.wordpress.com/2022/10/10/bye-bye-mac-os-hello-fedora-workstation/) and [source2](https://www.reddit.com/r/Fedora/comments/u6474g/fedora_36_macbook_pro_users_my_wifi_fix/).

1. Connect to internet using USB tethering or Ethernet cable.

2. Download RPM Fusion non-free repository.

   ```bash
   wget http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
   ```

3. Install the downloaded RPM.

   ```bash
   sudo dnf install -y rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
   ```

4. Install Broadcom WiFi driver.

   ```bash
   sudo dnf install -y broadcom-wl
   ```

5. Compile drivers

   ```bash
   sudo akmods --force
   ```

6. Generate module dependencies

   ```bash
   sudo depmod -a
   ```

7. Load `wl` kernel module

   ```bash
   sudo modprobe wl
   ```

8. Reboot

   ```bash
   shutdown -r now
   ```
