# Settings for Virtual Box

Update file `/usr/share/applications/virtualbox.desktop` with [virtualbox.desktop](virtualbox.desktop).

## Setting up port forwarding

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

But, do remember that the whole disk is still utilized. Check the partitioning using

```bash
$ lsblk
```

To claim back all the remaning disk and extend the root partition,

```bash
$ lvresize -L 100%FREE -r fedora/root
```

Also checks links at [here](https://unix.stackexchange.com/questions/616780/fedora-server-32-install-does-not-claim-full-disk) and [here](https://gist.github.com/181192/cf7eb42a25538ccdb8d0bb7dd57cf236).
