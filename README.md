# Fedora Setup

_Automated set up of Fedora Workstation and Fedora Server using Ansible_

![Workstation](https://img.shields.io/badge/Supported_Workstation-42-blue)
[![Ansible Lint](https://img.shields.io/github/actions/workflow/status/zbhavyai/fedora-setup/ansible-lint.yaml?label=Ansible%20Lint)](https://github.com/zbhavyai/fedora-setup/actions/workflows/ansible-lint.yaml)
[![Shellcheck Lint](https://img.shields.io/github/actions/workflow/status/zbhavyai/fedora-setup/shell-lint.yaml?label=Shellcheck%20Lint)](https://github.com/zbhavyai/fedora-setup/actions/workflows/shell-lint.yaml)
[![License](https://img.shields.io/github/license/zbhavyai/fedora-setup?label=License)](https://github.com/zbhavyai/fedora-setup/blob/main/LICENSE)

The goal is to automate as much as possible to a reasonable extent. This means that there will be manual intervention involved, such as some application configuration after installation.

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

1. Run the `init` target. This creates a python virtual environment `PY-ANSIBLE` with the required dependencies.

   ```shell
   make init
   ```

1. Activate the virtual environment `PY-ANSIBLE`.

   ```shell
   source .venv/PY-ANSIBLE/bin/activate
   ```

1. To setup, lets say, dev tools, run:

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
   source .venv/PY-ANSIBLE/bin/activate
   ansible-playbook playbooks/cleanup.yaml --check
   ```

-  Another way to check the [playbooks](playbooks), [roles](roles), and [group vars](group_vars) manually, which I find more reliable :smile:

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
