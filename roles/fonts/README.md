# Fonts

Fedora comes with a large selection of pre-installed fonts, which can make it hard to find and manage the ones you actually want. While you can search for specific fonts, the sheer number of options can be overwhelming.

Removing unwanted fonts isn’t always simple, since many are required by other packages. To avoid breaking dependencies, I only remove a small number of non-essential fonts.

## List installed fonts

```shell
dnf list --installed | grep font | sort | awk '{print $1}'
```
