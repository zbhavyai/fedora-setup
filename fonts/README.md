# Fonts

In Fedora, a wide array of fonts comes pre-installed by default. However, I often find this list to be excessively long, making it challenging to navigate and select the fonts I truly desire to use. While searching for specific fonts is feasible, the abundance of options can still be overwhelming.

However, removing these fonts isn't always straightforward, as many of them are dependencies for other packages. Removing fonts may result in the removal of essential packages, which I want to avoid. Therefore, I'm only able to remove a small subset of the pre-installed fonts, focusing on those that are least essential to my needs."

## List installed fonts

```shell
dnf list --installed | grep font | sort | awk '{print $1}'
```
