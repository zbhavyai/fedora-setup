# Flatpak

Flatpak allows running applications in a sandboxed environment. Flatpak apps are self-contained and isolated from the underlying system, ensuring compatibility across different distributions.

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
