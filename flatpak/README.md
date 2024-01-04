# Flatpak

Flatpak is a software distribution framework for Linux-based operating systems. It allows developers to package, distribute, and run applications in a sandboxed environment. Flatpak apps are self-contained and isolated from the underlying system, ensuring compatibility across different distributions. They include all necessary dependencies, libraries, and runtimes, providing consistent behavior on various systems. Flatpak simplifies the installation process for users, reduces dependency conflicts, and enhances system security by providing a secure and controlled environment for running applications.

## Get all the installed apps

```shell
flatpak list --app --columns=application
```

## Installed Location

Check installed location of a flatpak app or runtime. Sometimes required to tweak the configuration files, like to update memory settings for eclipse.

```shell
flatpak info --show-location <application-id> [branch]
```

Example:

```shell
flatpak info --show-location org.eclipse.Java
```
