# Podman

Podman is a container management tool that provides a daemonless alternative to Docker. Developed as part of the Open Container Initiative (OCI) ecosystem, Podman allows users to run containers without requiring a central daemon, making it particularly well-suited for environments where security, simplicity, and compliance are paramount.

## Advantages of Podman over Docker

1. **Rootless Containers**: Podman allows users to run containers as non-root users without requiring a daemon running as root. This enhances security and simplifies multi-tenancy setups, where users can run their containers without requiring administrative privileges.

2. **No Daemon**: Podman does not require a daemon to run in the background, unlike Docker. This simplifies the setup process and reduces resource usage, making it easier to integrate with systemd units and other service management tools.

3. **Integration with Systemd**: Podman integrates well with systemd, allowing users to manage containers as systemd services directly. This makes it easier to manage containers alongside other system services and ensures consistent behavior for containerized applications.

4. **Compatibility**: Podman aims to be fully compatible with the Docker CLI, meaning that Docker commands can often be used interchangeably with Podman. This makes it easy for users familiar with Docker to transition to Podman without needing to learn new commands or workflows.

5. **OCI Compatibility**: Podman uses the Open Container Initiative (OCI) standards for container images and runtimes, ensuring compatibility with other OCI-compliant tools and platforms. This allows users to leverage a wide range of container images and tools within the Podman ecosystem.

6. **Security Features**: Podman includes several security features, such as support for user namespaces, seccomp filtering, and SELinux integration. These features help to isolate containers from the host system and reduce the risk of security vulnerabilities or exploits.

7. **No Centralized Daemon**: Podman does not rely on a centralized daemon architecture, which can be a single point of failure and a potential security risk. Instead, Podman uses a client-server model similar to Git, where each Podman command communicates directly with the container runtime.

8. **Portability**: Podman can be run on a wide range of Linux distributions without requiring specific dependencies or system configurations. This makes it suitable for use in diverse environments, including development, testing, and production.

## Setup

Podman comes pre-installed on Fedora. But some additional setup is required to use it with other tools like Quarkus and VS Code.

### Quarkus with Podman

**Reference**: [https://quarkus.io/guides/podman](https://quarkus.io/guides/podman)

1. Install `podman-docker` or setup `alias docker=podman`. However, tab completion won't work in either case.

2. Enable podman socket. This will create a symlink at `${HOME}/.config/systemd/user/sockets.target.wants/podman.socket` pointing to `/usr/lib/systemd/user/podman.socket`.

   ```shell
   systemctl enable --now --user podman.socket
   ```

3. Setting of `DOCKER_HOST` is already done in [`.bashrc`](../bash/.bashrc) file.

### VS Code with Podman

The Dev Containers extension `ms-vscode-remote.remote-containers` extension works with Podman once the docker path is updated in the settings. These settings make VS Code work with podman without having `podman-docker` installed.

```json
{
  "dev.containers.dockerPath": "podman"
}
```

But the docker extension `ms-azuretools.vscode-docker` has got some issues parsing JSON from `podman`, even though the docker path is update in the settings.

```json
{
  "docker.dockerPath": "podman"
}
```
