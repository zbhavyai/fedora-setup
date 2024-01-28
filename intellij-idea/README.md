# IntelliJ IDEA

IntelliJ IDEA is a integrated development environment (IDE) developed by JetBrains for Java, Kotlin, and other JVM-based languages. Renowned for its robust features, intelligent code assistance, and seamless integration with popular frameworks and technologies, IntelliJ IDEA empowers developers to streamline their workflow and boost productivity.

## Installation

1. The installation is done via Flatpak and is included in the [install](../flatpak/install.txt) file.

2. Use the terminal `/usr/bin/env -- flatpak-spawn --host --env=TERM=xterm-256color bash`. It's also included in the settings.

## Settings Import

1. Recreate the zip file from extracted settings.

   ```shell
   pushd intellij-idea/settings
   zip -r settings.zip *
   mv settings.zip ..
   popd
   ```

## Settings Export

While exporting settings, only include the following:

- Code Style
- Default Font
- Editor Colors
- Editor Colors (schemes)
- External Diff
- InlayHintsSettings, DeclarativeInlayHintsSettings, CodeVisionSettings
- KeymapFlagsStorage
- Keymaps
- Keymaps (schemes)
- ParameterNameHintsSettings
- RefactoringSettings
- StatusBar, General, Registry
- Terminal
- UI Settings

2. Import the `settings.zip` file.

## Downloaded Plugins

1. Open the IDE. Don't open any project, close if already open.
2. Go to Plugins -> Installed.
3. Filter plugins by `Downloaded`.
4. Copy all downloaded ones using `Ctrl+A` and `Ctrl+C`.
5. Maintain the list

   ```
   GitHub Copilot
   JPA Buddy
   SonarLint
   ```
