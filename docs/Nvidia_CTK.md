# Nvidia Container Toolkit

To make it work with podman, follow the simplified steps below. Credits to their official documentation at [here](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#with-dnf-rhel-centos-fedora-amazon-linux) and [here](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/cdi-support.html).

1. Install the container toolkit.

   ```shell
   curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo | sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo
   ```

   ```shell
   sudo dnf install --assumeyes \
      nvidia-container-toolkit \
      nvidia-container-toolkit-base \
      libnvidia-container-tools \
      libnvidia-container1
   ```

2. Generate the CDI specification

   ```shell
   sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
   ```

3. Test using this command

   ```shell
   podman container run --rm --security-opt=label=disable --device=nvidia.com/gpu=all ubuntu nvidia-smi
   ```

4. Start your container like you normally do, for example, [this configuration](https://github.com/zbhavyai/containers/blob/main/ollama-openwebui/compose.yaml) for running Ollama and OpenWebUI.
