# Desktop Files

`.desktop` files are text-based descriptors used by Linux desktop environments to define application launchers. They include metadata such as the application's name, description, icon, command to execute, and other properties. They follow the [freedesktop.org Desktop Entry Specification](https://specifications.freedesktop.org/desktop-entry-spec/).

Here are some of the locations where `.desktop` files are stored that I have come across in Fedora.

| Location                                           | Purpose                               |
| -------------------------------------------------- | ------------------------------------- |
| `/usr/share/applications/`                         | System wide installations             |
| `~/.local/share/applications/`                     | User-specific installations, eg, PWAs |
| `/var/lib/flatpak/app/<APP-ID>/current/active/...` | Flatpak installations                 |
