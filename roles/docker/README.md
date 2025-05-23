# Docker

Docker is a powerful platform for developing, shipping, and running applications in containers. Containers are lightweight, portable, and self-sufficient environments that encapsulate application code, runtime, system tools, libraries, and settings.

Alternatively, try [podman](../podman/README.md) which has benefits over docker like daemonless, rootless containers, integration with systemd, OCI compliant, etc.

## Installation

1. Set up the repository

   ```shell
   sudo dnf -y install dnf-plugins-core
   sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
   ```

2. Install docker engine. It will also create a `docker` group, but no users are added to it.

   ```shell
   sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
   ```

3. Enable and start the docker engine

   ```shell
   sudo systemctl enable --now docker
   ```

4. Verify the installation

   ```shell
   docker --version
   ```

5. Test the installation

   ```shell
   sudo docker run hello-world
   ```

6. To access docker engine from current user account without `sudo`, the user needs to the docker group. Restart after making changes.

   ```shell
   sudo usermod -aG docker $USER
   shutdown -r 0
   ```
