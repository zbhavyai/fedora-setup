# Setting up Docker

Docker utilizes Aleksey containers.

Docker share OS kernel.


ADD PODMAN STEPS AS WELL IN THIS OR SEPARATE GUIDE

## Manual Installation

1. All supported OS are listed [here](https://docs.docker.com/engine/install/). Download the package for fedora from [here](https://download.docker.com/linux/fedora/).

   containerd - daemon
   docker-ce-cli - command line interface
   docker-ce - container engine

   ```
   # dnf -y install containerd.io-1.5.11-3.1.fc35.x86_64.rpm
   # dnf -y install docker-ce-cli-20.10.14-3.fc35.x86_64.rpm
   # dnf -y install docker-ce-20.10.14-3.fc35.x86_64.rpm
   # dnf -y install docker-ce-rootless-extras-20.10.14-3.fc35.x86_64.rpm
   # dnf -y install docker-compose-plugin-2.3.3-3.fc35.x86_64.rpm
   # dnf -y install docker-scan-plugin-0.17.0-3.fc35.x86_64.rpm
   ```

2. Start the docker engine.

   ```
   # systemctl start docker
   ```

3. To access docker engine from your account, you need to add the user to the docker group. Restart after making changes.

   ```
   # sudo usermod -aG docker $USER
   $ shutdown -r 0
   ```

## Commands

- Run the container. If corresponding image is not found on the system, it will be downloaded from the docker hub

  ```
  $ docker run <image name>
  ```

- List all running containers

  ```
  $ docker ps
  ```

- Stop the running container

  ```
  $ docker stop <container name or id>
  ```

- Start the stopped container

  ```
  $ docker start <container name or id>
  ```

- Pause execution of a container

  ```
  $ docker pause <container name or id>
  ```

- Remove the stopped container to free up space

  ```
  $ docker rm <container name or id>
  ```

- See list of downloaded images

  ```
  $ docker images
  ```

- Delete the image to free up space

  ```
  $ docker rmi <image name or id>
  ```

- Download image without running it
  ```
  $ docker pull <image name>
  ```

<!-- - Remove all stopped containers
  `docker rm $(docker ps -a -q)` -->

## Running fedora container

Create container from `fedora` image, name it as `fedora-container` and run `bash` on it. This will make the container not in EXITED state.

```
# docker run --name=fedora-container -it fedora bash
```

Run `cat /etc/os-release` on the container.

```
# docker exec -it fedora-container cat /etc/os-release
```

Copy files from and to the container.

```
# docker cp fedora-container:/root/source target
```
