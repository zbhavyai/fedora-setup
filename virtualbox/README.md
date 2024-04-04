# VirtualBox

VirtualBox is an open-source virtualization software developed by Oracle. It enables users to run multiple guest operating systems simultaneously on a single physical machine, facilitating easy experimentation, development, and testing of software across different environments. With support for a wide range of host and guest OS platforms, VirtualBox offers features such as snapshots, virtual networking, and seamless integration with the host system.

## Setup

Before using the VirtualBox, one could turn the secure boot off in the BIOS settings. This can avoid some issues like the one mentioned below.

```shell
There were problems setting up VirtualBox.  To re-start the set-up process, run
  /sbin/vboxconfig
as root.  If your system is using EFI Secure Boot you may need to sign the
kernel modules (vboxdrv, vboxnetflt, vboxnetadp, vboxpci) before you can load
them. Please see your Linux system's documentation for more information.
```

## Updated launcher

Find the updated launcher at [virtualbox.desktop](virtualbox.desktop). This sets the `env GDK_BACKEND=x11` to fix some issues with running VirtualBox on Wayland. These might eventually be fixed in the future versions of VirtualBox.

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
