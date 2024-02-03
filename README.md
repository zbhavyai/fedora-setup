# Fedora Workstation Setup

Welcome to the guide for setting up a development environment on a new [Fedora Workstation](https://fedoraproject.org/workstation/). This guide aims to streamline the setup process, automating certain tasks for my own convenience.

## What's automated

- Package installation and removal using `dnf`
- Font management, including installation and removal
- Installation of Flatpak applications
- Tweak to ignore lid switch behavior
- Configuration of essential files:
  - `.bashrc`
  - `.gitconfig`
  - `.vimrc`
- Customization options for the Gnome Terminal
- SSH configuration for seamless remote access
- Installation of VS Code extensions

## What's not automated

Certain software packages or configurations tailored to specific needs won't be automatically set up. This includes software that isn't universally required or configurations that demand manual intervention.

## How to use

To begin the setup process, simply execute the [setup.sh](setup.sh) script. You may be prompted to enter your password, as some commands require `sudo` privileges.

```shell
./setup.sh
```
