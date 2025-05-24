# Visual Studio Code

Below settings are handled by Ansible, but its here for reference.

### User Settings

1. Press `Ctrl`+`Shift`+`P`
2. Type `Preferences: Open User Settings (JSON)`
3. Copy content from [this file](files/settings.jsonc)

### Keyboard Shortcuts

This is mainly for cycling tabs in the visible order

1. Press `Ctrl`+`Shift`+`P`
2. Type `Preferences: Open Keyboard Shortcuts (JSON)`
3. Copy content from [this file](files/keybindings.jsonc)

## Using Flatpak VS Code

> [!NOTE]
> Avoid using flatpak-vscode.

flatpak-vscode needs some additional settings to work properly, especially when using integrated terminal, or container extensions.

### Start vscode from anywhere

The [`~/.bashrc`](../dotfiles/files/.bashrc) file should automatically detect the flatpak installation of VS Code and set an alias, to keep using the `code .` command to open any directory/repository in VS Code from the command line.

### Integrated Terminal

Update the settings to use `host-spawn bash` inside the sandbox.

```jsonc
{
  // TERMINAL -----------------------------------------------------------------
  "terminal.integrated.profiles.linux": {
    "bash": { "path": "host-spawn", "args": ["bash"] }
  }
}
```

### Container extensions

Configure `ms-vscode-remote.remote-containers` and `ms-azuretools.vscode-docker` extensions to work with flatpak-vscode, follow these steps. Credits - [source](https://github.com/flathub/com.visualstudio.code/issues/55#issuecomment-1409226145).

1. Get `docker.sock` inside the flatpak

   ```shell
   flatpak override --user --filesystem=/run/docker.sock com.visualstudio.code
   ```

2. Update the settings

   ```jsonc
   // CONTAINER ----------------------------------------------------------------
   {
     "dev.containers.dockerPath": "/run/host/usr/bin/docker",
     "dev.containers.dockerComposePath": "/run/host/usr/bin/docker-compose",
     "docker.dockerPath": "/run/host/usr/bin/docker"
   }
   ```
