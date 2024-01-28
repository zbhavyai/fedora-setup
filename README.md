# Fedora Workstation Setup

This guide provides an overview of setting up a development environment on a new [Fedora Workstation](https://fedoraproject.org/workstation/). Certain aspects of this guide are automated for convenience.

## What's automated

- Package installation and removal via `dnf`
- Installation of Flatpak applications
- Configuration of `.bashrc`
- Configuration of `.gitconfig`
- Configuration of `.vimrc`
- Customization of Gnome Terminal
- SSH configuration

## How to use

Just run the [setup.sh](setup.sh) script. It will ask for password as some commands require `sudo` privileges.

```shell
./setup.sh
```
