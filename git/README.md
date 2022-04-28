# Setting up Git

The official website for Git is [https://git-scm.com/](https://git-scm.com/).

GitHub has three configuration levels, and each of these three levels overwrites values in the previous level. Local is the default if no flag is specified.

| S No | Level  | Config file Location | Description                                     | Flag       |
| ---- | ------ | -------------------- | ----------------------------------------------- | ---------- |
| 1    | System | `/etc/gitconfig`     | System specific, applied to every user and repo | `--system` |
| 2    | Global | `~/.gitconfig`       | User specific, applied to every repo            | `--global` |
| 3    | Local  | `<repo>/.git/config` | Repo specific                                   | `--local`  |

## Installing Git

1. Check the installed version. Make sure its version is greater than or equal to 2.32.0.

   ```shell
   $ git --version
   ```

2. If you plan not to configure the `git`, then use HTTPS to clone the repos. Cloning a public repository would not require for any authentication for read-only access. If you try to clone the repo using SSH, you will get `Permission denied` error, because using the SSH makes git check for SSH keys, and since they are not setup, `Permission Denied` is thrown.

   ```shell
   $ git clone <HTTPS url>
   ```

## Configuring Git

Use [this](gitconfig) file to configure the basic settings, and place it in the `~/.gitconfig` file.

## Setting up SSH access

1. Generate SSH Keypairs in your system. Save the keys in `~/.ssh` directory. Give it a descriptive name, like **githubLogin**, and empty passphrase.

   ```shell
   $ ssh-keygen -t ed25519 -a 100 -C "someone@example.com"         # EdDSA algorithm

   $ ssh-keygen -t rsa -b 4096 -C "someone@example.com"            # RSA algorithm
   ```

2. This would generate a pair of files in the `~/.ssh` directory, `githubLogin` (private key) and `githubLogin.pub` (public key).

3. Manually copy the contents of the public key to [https://github.com/settings/keys](https://github.com/settings/keys).

4. Now while connecting to GitHub, how GitHub will know which key to use? Supply this information via the `~/.ssh/config` file, rather than using the SSH agent. Create the below file.

   ```shell
   $ touch ~/.ssh/config
   $ chmod 600 ~/.ssh/config
   ```

5. Add the below contents to the above file. A sample file is [here](ssh_config).

   ```
   Host github.com
     HostName github.com
     IdentityFile ~/.ssh/githubLogin
     User git
   ```

6. Test your GitHub connection. This will be successful only if keypair authentication is successful.

   ```shell
   $ ssh -T git@github.com
   ```
