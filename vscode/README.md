# Visual Studio Code

VS Code is a highly customizable source code editor developed by Microsoft. It is designed to be versatile and supports various programming languages through extensions. Some key features of VS Code include an integrated terminal, version control integration (Git), smart code completion, syntax highlighting, and debugging support.

## Settings

Settings are synced when logged in to a Microsoft account, but are here for reference.

### User Settings

1. Press `Ctrl`+`Shift`+`P`
2. Type `Preferences: Open User Settings (JSON)`
3. Copy content from [this file](settings.jsonc)

### Keyboard Shortcuts

This is mainly for cycling tabs in the visible order

1. Press `Ctrl`+`Shift`+`P`
2. Type `Preferences: Open Keyboard Shortcuts (JSON)`
3. Copy content from [this file](keyboardShortcuts.jsonc)

## Using Flatpak VS Code

flatpak-vscode needs some additional settings to work properly, especially when using integrated terminal, or container extensions.

### Start vscode from anywhere

The [`~/.bashrc`](../bash/.bashrc) file should automatically detect the flatpak installation of VS Code and set an alias, to keep using the `code .` command to open any directory/repository in VS Code from the command line.

### Installing extensions

The [main setup script](../setup.sh) assumes the regular installation of VS Code to install extensions. For installing on flatpak-vscode, run the [vscode setup script](setup.sh) inside the flatpak container.

```shell
flatpak run --command=sh com.visualstudio.code
./vscode/setup.sh
```

### Integrated Terminal

Update the settings to use `host-spawn bash` inside the sandbox.

```jsonc
{
  // TERMINAL -----------------------------------------------------------------
  "terminal.integrated.profiles.linux": {
    "bash": {
      "path": "host-spawn",
      "args": ["bash"]
    }
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
