# Nvidia Container Toolkit

To make it work with podman, follow the simplified steps below. Credits to their official documentation at [here](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#with-dnf-rhel-centos-fedora-amazon-linux) and [here](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/cdi-support.html).

1. Install the container toolkit.

   ```shell
   curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo | sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo
   ```

   ```shell
   export NVIDIA_CONTAINER_TOOLKIT_VERSION=1.17.8-1
   ```

   ```
   sudo dnf install -y \
      nvidia-container-toolkit-${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
      nvidia-container-toolkit-base-${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
      libnvidia-container-tools-${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
      libnvidia-container1-${NVIDIA_CONTAINER_TOOLKIT_VERSION}
   ```

2. Generate the CDI specification

   ```shell
   sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
   ```

3. Start your container like you normally do, for example, [this configuration](https://github.com/zbhavyai/containers/blob/main/ollama-openwebui/compose.yaml) for running Ollama and OpenWebUI.
