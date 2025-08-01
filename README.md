# Fedora Setup

_Automated set up of Fedora Workstation and Fedora Server using Ansible_

[![CI workflow status](https://github.com/zbhavyai/fedora-setup/actions/workflows/ci.yaml/badge.svg)](https://github.com/zbhavyai/fedora-setup/actions/workflows/ci.yaml)

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

1. Create a python virtual environment, activate it, and install the dependencies.

   ```shell
   make init
   source .venv/PY-ANSIBLE/bin/activate
   ```

1. Run one of the playbooks, check available targets using `make help`, or conveniently just run everything:

   ```shell
   make all
   ```

1. To synchronize your current system settings with the configurations in this repository, run:

   ```shell
   make sync
   ```
