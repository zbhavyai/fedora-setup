# Flatpak

Flatpak is a software distribution framework for Linux-based operating systems. It allows developers to package, distribute, and run applications in a sandboxed environment. Flatpak apps are self-contained and isolated from the underlying system, ensuring compatibility across different distributions. They include all necessary dependencies, libraries, and runtimes, providing consistent behavior on various systems. Flatpak simplifies the installation process for users, reduces dependency conflicts, and enhances system security by providing a secure and controlled environment for running applications.

## Get all the installed apps

```shell
flatpak list --app --columns=application
```

## adw-gtk3 Theme

This theme is an unofficial GTK3 port of libadwaita. Since I use this theme for the Legacy GTK3 apps (via `gnome-tweaks`), I installed it via the package manager. Without its equivalent in the flatpak installed, flatpak apps like Eclipse and Chromium render in light mode only.

```shell
flatpak install flathub org.gtk.Gtk3theme.adw-gtk3-dark
```

> Its categorized as `runtime` (not `app`) and hence not dumped by the [script](./dump-installed.sh).

## Installed Location

Check installed location of a flatpak app or runtime. Sometimes required to tweak the configuration files, like to update memory settings for eclipse.

```shell
flatpak info --show-location <application-id> [branch]
```

Example:

```shell
flatpak info --show-location org.eclipse.Java
```
