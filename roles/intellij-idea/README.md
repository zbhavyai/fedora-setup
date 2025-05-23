# IntelliJ IDEA

IntelliJ IDEA is a integrated development environment (IDE) developed by JetBrains for Java, Kotlin, and other JVM-based languages. Renowned for its robust features, intelligent code assistance, and seamless integration with popular frameworks and technologies, IntelliJ IDEA empowers developers to streamline their workflow and boost productivity.

## Installation

1. The installation is done via Flatpak and is included in the [install](../flatpak/install.txt) file.

2. Use the terminal `/usr/bin/env -- flatpak-spawn --host --env=TERM=xterm-256color bash`. It's also included in the settings.

3. To use the system's JDK, first install the openjdk flatpak extension, and then set environment variable `FLATPAK_ENABLE_SDK_EXT=openjdk17` using Flatseal. This step is not included in settings yet.

   ```shell
   flatpak install flathub org.freedesktop.Sdk.Extension.openjdk17
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
