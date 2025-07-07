# VirtualBox

VirtualBox is an open-source virtualization software developed by Oracle. Its a Type 2 hypervisor.

## Setup

1. Install the updated VirtualBox package. For example, on Fedora 42, using `VirtualBox-7.0` causes missing header files, like below. So, try the latest one available, which is `VirtualBox-7.1` at the time of writing this.

   ```shell
   grep 'No such file or directory' /var/log/vbox-setup.log
   ```

   ```shell
   combined-agnostic1.c:38:10: fatal error: internal/iprt.h: No such file or directory
   combined-agnostic2.c:38:10: fatal error: internal/iprt.h: No such file or directory
   combined-os-specific.c:38:10: fatal error: the-linux-kernel.h: No such file or directory
   common/string/strformatrt.c:42:10: fatal error: iprt/string.h: No such file or directory
   linux/../SUPDrvInternal.h:47:10: fatal error: VBox/cdefs.h: No such file or directory
   SUPDrvInternal.h:47:10: fatal error: VBox/cdefs.h: No such file or directory
   SUPLibAll.c:41:10: fatal error: VBox/sup.h: No such file or directory
   ```

2. If you see errors like kernel driver is either not loaded or not set up correctly, then do this -

   ```shell
   sudo /sbin/vboxconfig
   ```

3. If you have another KVM installed, like Virt Manager, then you may see an error like below.

   ```shell
   VirtualBox can't enable the AMD-V extension. Please disable the KVM kernel extension, recompile your kernel and reboot (VERR_SVM_IN_USE).
   ```

   Temporarily disable the KVM by this, and launch VirtualBox again.

   ```shell
   sudo modprobe -r kvm_amd kvm
   ```

## Updated launcher

Find the updated launcher at [virtualbox.desktop](../roles/virtualbox/files/virtualbox.desktop). This sets the `env GDK_BACKEND=x11` to fix some issues with running VirtualBox on Wayland. These might eventually be fixed in the future versions of VirtualBox.

## Port forwarding

1. Go to `Settings` > `Network` > `Advanced` > `Port Forwarding`

2. Add a new rule

3. Set the following values:

   | Name   | Protocol | Host IP | Host Port | Guest I | Guest Port |
   | ------ | -------- | ------- | --------- | ------- | ---------- |
   | Rule 1 | TCP      |         | 2222      |         | 22         |
   | Rule 2 | TCP      |         | 9090      |         | 9090       |
   | Rule 3 | TCP      |         | 3306      |         | 3306       |

   - `Host IP` is set to nothing - which is equivalent to `0.0.0.0`. It means that any machine that can access your Host on TCP port `2222` will be able to talk to the SSH on your guest. You may also set it to `127.0.0.1`.

   - Leave `Guest IP` blank. You may set it to `10.0.2.15`, but not really necessary.

## Setting up Fedora Server

Fedora Server would only use upto 15G of your harddisk size. Read more about it [here](https://lists.fedoraproject.org/archives/list/server@lists.fedoraproject.org/thread/D7ZK7SILYDYAATRFS6BFWZQWS6KSRGDG/).

But, remember that the whole disk is still utilized. Check the partitioning using

```shell
lsblk
```

To claim back all the remaining disk and extend the root partition,

```shell
lvresize -L 100%FREE -r fedora/root
```

Also refer to these links

- [https://unix.stackexchange.com/questions/616780/fedora-server-32-install-does-not-claim-full-disk](https://unix.stackexchange.com/questions/616780/fedora-server-32-install-does-not-claim-full-disk)
- [https://gist.github.com/181192/cf7eb42a25538ccdb8d0bb7dd57cf236](https://gist.github.com/181192/cf7eb42a25538ccdb8d0bb7dd57cf236).
