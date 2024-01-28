# Git

Git is a distributed version control system designed for tracking changes in source code during software development. Developed by Linus Torvalds in 2005, Git has become the industry standard for version control due to its speed, flexibility, and powerful branching and merging capabilities. The official documentation for Git is [https://git-scm.com/](https://git-scm.com/).

GitHub has three configuration levels, and each of these three levels overwrites values in the previous level. Local is the default if no flag is specified.

| S No | Level  | Config file Location | Description                                     | Flag       |
| ---- | ------ | -------------------- | ----------------------------------------------- | ---------- |
| 1    | System | `/etc/gitconfig`     | System specific, applied to every user and repo | `--system` |
| 2    | Global | `~/.gitconfig`       | User specific, applied to every repo            | `--global` |
| 3    | Local  | `<repo>/.git/config` | Repo specific                                   | `--local`  |

## Installation

1. Git comes pre-installed. Check the installed version.

   ```shell
   git --version
   ```

2. If you plan not to configure the `git`, then use HTTPS to clone the repos and it shouldn't require for any authentication for read-only access. Closing using SSH would throw `Permission denied` error.

   ```shell
   git clone <HTTPS url>
   ```

## Setting up SSH access

1. Generate SSH Keypairs. It will create a public-private keypair.

   ```shell
   ssh-keygen -t ed25519 -a 100 -C "zbhavyai@gmail.com" -f $HOME/.ssh/githubLogin
   ```

2. Copy the contents of the public key to [https://github.com/settings/keys](https://github.com/settings/keys).

3. Tell SSH to use `$HOME/.ssh/githubLogin` while connecting to Github. This step is automatically performed during [ssh setup](../ssh/setup.sh).

   ```shell
   touch ~/.ssh/config
   chmod 600 ~/.ssh/config
   echo -e "Host github.com\n  HostName github.com\n  IdentityFile ~/.ssh/githubLogin\n  User git" >> ~/.ssh/config
   ```

4. Test your GitHub connection. This will be successful only if keypair authentication is successful.

   ```shell
   ssh -T git@github.com
   ```
