# SSH

SSH, or Secure Shell, is a cryptographic network protocol used for secure data communication, remote command-line login, remote command execution, and other secure network services between two networked computers. It connects, via a secure channel, a client and a server running SSH server services.

Some usage of SSH includes Remote System Administration, Secure File Transfer, Tunneling & Port Forwarding, SSHFS, and X11 Forwarding.

## Generating SSH Keypairs

Use the EdDSA algorithm for generating SSH Keypairs. It is more secure than the RSA algorithm.

```shell
ssh-keygen -t ed25519 -a 100 -C "zbhavyai@gmail.com"     # EdDSA algorithm
```

If the above algorithm is not supported, then use the RSA algorithm.

```shell
ssh-keygen -t rsa -b 4096 -C "zbhavyai@gmail.com"        # RSA algorithm
```

## Permissions

SSH is very strict about file permissions. They should be set as follows:

| File / Directory | Permission |
| ---------------- | ---------- |
| `~/.ssh`         | `700`      |
| `~/.ssh/config`  | `600`      |
| `~/.ssh/*`       | `600`      |
| `~/.ssh/*.pub`   | `644`      |
