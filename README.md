# Fedora Workstation Setup

Welcome to the guide for setting up a development environment on a new [Fedora Workstation](https://fedoraproject.org/workstation/) with GNOME DE. This guide aims to streamline the setup process, automating certain tasks for my own convenience. This also serve as my dotfiles repository.

## What's automated

- Package installation and removal using `dnf`
- Font management, including installation and removal
- Installation of Google Chrome
- Installation of some Flatpak applications
- Update key bindings for the GNOME Shell
- Configuration of essential configuration files:
  - `.bashrc`
  - `.gitconfig`
  - `.vimrc`
- SSH configuration for seamless remote access
- Installation of VS Code and some extensions
- Some miscellaneous settings like
  - Tweak to ignore lid switch behavior
  - App folders in the GNOME shell
  - Interface settings like icon theme, fonts, color theme, etc.
- Customizing preferences for GNOME apps like GNOME Text Editor, Nautilus, and Terminal

## What's not automated

Certain software packages or configurations tailored to specific needs won't be automatically set up - like [konsole](./konsole/) and [pgadmin](./postgres/) which I don't need on all the machines. This includes software that isn't universally required or configurations that demand manual intervention.

## How to use

1. Ensure you have `python-libdnf5` installed.

   ```shell
   sudo dnf install --assumeyes python3-libdnf5
   ```

1. Create a python virtual environment, activate it, and install the dependencies

   ```shell
   python -m venv .venv/PY-TEMP
   source .venv/PY-TEMP/bin/activate
   pip install -r requirements.txt
   ```

1. Run the playbook

   ```shell
   ansible-playbook playbooks/laptop.yaml
   ```
