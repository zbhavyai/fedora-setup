# Fedora Workstation Setup

The goal is to automate as much as possible to a reasonable extent. This means that there will be manual intervention involved, such as some application configuration after installation.

## What does it cover

- Some cleanup tasks like removing unused packages and fonts.
- Java development environment setup.
- VS Code installation, configuration, and installation of extensions for all the profiles.
- Installation of additional fonts.
- Installation of Google Chrome
- Installation of some Flatpak applications
- Update key bindings for the GNOME Shell
- Setup of dotfiles like `.bashrc`, `.gitconfig`, `.vimrc`, ssh `config`.
- Some miscellaneous settings like
  - Tweak to ignore lid switch behavior
  - App folders in the GNOME shell
  - Interface settings like icon theme, fonts, color theme, etc.
- Customizing preferences for GNOME apps like GNOME Text Editor, Nautilus, and Terminal

## How to use

1. Ensure you have `python-libdnf5` installed.

   ```shell
   sudo dnf install --assumeyes python3-libdnf5
   ```

1. Create a python virtual environment, activate it, and install the dependencies

   ```shell
   make init
   ```

1. Run one of the playbooks

   ```shell
   make java
   ```
