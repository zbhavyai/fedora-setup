# Fedora Setup

_Automated set up of Fedora Workstation and Fedora Server using Ansible_

![Workstation](https://img.shields.io/badge/Workstation-42-blue)
[![Ansible Lint](https://img.shields.io/github/actions/workflow/status/zbhavyai/fedora-setup/ansible-lint.yaml?label=Ansible%20Lint)](https://github.com/zbhavyai/fedora-setup/actions/workflows/ansible-lint.yaml)
[![Shellcheck Lint](https://img.shields.io/github/actions/workflow/status/zbhavyai/fedora-setup/shell-lint.yaml?label=Shellcheck%20Lint)](https://github.com/zbhavyai/fedora-setup/actions/workflows/shell-lint.yaml)
[![License](https://img.shields.io/github/license/zbhavyai/fedora-setup?label=License)](https://github.com/zbhavyai/fedora-setup/blob/main/LICENSE)
[![Ask DeepWiki](https://img.shields.io/badge/-Ask%20DeepWiki-blue.svg?labelColor=grey&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAsVBMVEVHcEwmWMYZy38Akt0gwZoSaFIbYssUmr4gwJkBlN4WbNE4acofwZkBj9k4aMkBk94WgM0bsIM4aMkewJc2ZMM3Z8cbvIwYpHsewJYAftgBkt0fvpgBkt0cv44cv5wzYckAjtsCk90pasUboXsgwJkfwpYfwJg4aMoct44yXswAkd0BkN84Z8cBktwduZIjcO85lM4hwZo5acoBleA6a88iyaABmOQ8b9QhxZ0CnOoizaOW4DOvAAAAMHRSTlMAKCfW/AgWA/7/DfvMc9j7MU/rj3XBcRW/JMbe7kUxjI/lUzzz6tPQkJ+jVmW1oeulmmslAAAByUlEQVQ4y32Tia6jIBSGUVFcqliXtlq73rm3d50ERNC+/4PNQetoptMeE0PgC/9/FhCaBSH9Hz2J+ONgPDl2DolSUWY/PL8oEQRCfPxHpFc3Ah5wHoiI6I05NXgjAOgQF3Jn1Dlo4XMPDDes09UE2d+REvl3lijBg4CrHNmrbcM2u9u5nwsRcAFfFHFY5sZ607Yua3GqpQiKE6G9cZHZThblZ4T2mLnMxde3ATASMUj72o0Pbs1fADDcLHqAjEDugJ3lC+ztMGYTADcoLaFyH+02DP9+WS4ahrXE4laALFKcq8vZfscNY8312mxfr27bLJZjnsYhSDIHmUxLu9h9N/ep+7pazwoZQw+1Nwi33epu7c2p8RooeqCdAHMGoOJIq3CUwIMEniRIaHVe3ZVnO2Vgsh1MstEkQUXVUc+jXfk3zbemxS6+pQmlPtUeALJ8VKj4JHvAelBqFFdSS3h1SPzQKr/+aRa0+0cCIWtJLauG5U/fbgyG01uiNqQhyzA8ddKj1OvK28AsZyN3DKE4X6AEWrU1jJx9N7RFpdPxpHU/tMOQG9SjfTp3Yz8KgRVKpfx88Dqhpseq606h/+zxfh6LJ8eEDKWbxx9XEDwqzP1SVgAAAABJRU5ErkJggg==)](https://deepwiki.com/zbhavyai/fedora-setup)

The goal of this repository is to:

-  keep all dotfiles and configurations in version control
-  ensure system settings are reproducible across machines
-  automate setup to the highest reasonable extent with minimal manual intervention

## What does it cover

The automation is done using multiple Ansible playbooks, which are named according to the tasks they perform.

| Playbook                                      | Description                                                        | Command              |
| --------------------------------------------- | ------------------------------------------------------------------ | -------------------- |
| [cleanup](playbooks/cleanup.yaml)             | Removes unused packages and fonts                                  | `make cleanup`       |
| [customization](playbooks/customization.yaml) | Customizes GNOME Shell, installs dotfiles, and some other settings | `make customization` |
| [tools](playbooks/tools.yaml)                 | Installs essential utilities                                       | `make tools`         |
| [container](playbooks/container.yaml)         | Installs Podman or Docker                                          | `make container`     |
| [dev](playbooks/dev.yaml)                     | Installs JDK, Node.js, Postman, and few IDEs and their settings    | `make dev`           |
| [media](playbooks/media.yaml)                 | Installs media-related applications                                | `make media`         |
| [alternate](playbooks/alternate.yaml)         | Installs Google Chrome, and optionally some other applications     | `make alternate`     |
| [all](playbooks/all.yaml)                     | Runs all above playbooks                                           | `make all`           |
| [server](playbooks/server.yaml)               | Some setup required only for servers                               | `make server`        |

## How to use

> [!NOTE]
> Check all available targets using `make help`.

#### Making changes to your system based on the configurations in this repository:

1. Run the `init` target. This installs a pre-commit hook and creates a python virtual environment with the required dependencies.

   ```shell
   make init
   ```

1. To setup, lets say, **dev tools**, run below. This would install JDK, Maven, Node.js, Postman, and IDEs - VS Code, IntelliJ IDEA, and WebStorm - with their extensions/plugins installed and settings configured.

   ```shell
   make dev
   ```

   To setup everything what this repository offers, run:

   ```shell
   make all
   ```

#### Checking what this repository offers without making any changes:

-  The programmatic way to check changes being done to your system is to run the playbooks with `--check` flag. Example:

   ```shell
   uv run ansible-playbook playbooks/cleanup.yaml --check
   ```

-  Another way is to check the [playbooks](playbooks), [roles](roles), and [group vars](group_vars) manually, which I find more reliable :smile:

#### Saving your current system settings to the configurations in this repository:

1. Run the `sync` target.

   ```shell
   make sync
   ```

1. And then commit the changes, eg:

   ```shell
   git add .
   git commit -m "Sync"
   git push
   ```
