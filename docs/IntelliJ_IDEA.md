# IntelliJ IDEA

IntelliJ IDEA is a IDE for JVM-based languages.

## Installation

1. The installation is done via Flatpak and is included in the [install](../flatpak/install.txt) file.

2. Use the terminal `/usr/bin/env -- flatpak-spawn --host --env=TERM=xterm-256color bash`.

3. To use the system's JDK, first install the openjdk flatpak extension, and then set environment variable `FLATPAK_ENABLE_SDK_EXT=openjdk`.

   ```shell
   flatpak install flathub org.freedesktop.Sdk.Extension.openjdk
   flatpak override --user --env=FLATPAK_ENABLE_SDK_EXT=* com.jetbrains.IntelliJ-IDEA-Community
   ```

## Settings Import

1. Recreate the zip file from extracted settings.

   ```shell
   pushd intellij-idea/settings
   zip -r settings.zip *
   mv settings.zip ..
   popd
   ```

2. Import the `settings.zip` file.

## Settings Export

While exporting settings, only include the following:

- Code Style (schemes)
- DeclarativeInlayHintsSettings, InlayHintsSettings, CodeVisionSettings
- Default Font
- Editor Colors
- Editor Colors (schemes)
- External Diff
- General, StatusBar, Registry
- Keymaps
- Keymaps (schemes)
- ParameterNameHintsSettings
- Refactoring, RefactoringSettings
- Terminal
- UI Settings
