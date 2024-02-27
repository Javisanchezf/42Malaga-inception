<h1 align = center>42 Malaga Inception Alpine version</h1>

> School 42 Málaga cursus project.

This repository contains all archives for the project __inception__ in the __School 42 Málaga core cursus__.

<h2 align = center>
	<a href="#about">About</a>
	<span> · </span>
	<a href="#requirements">Requirements</a>
	<span> · </span>
	<a href="#instructions">Instuctions</a>
	<span> · </span>
	<a href="#guide">Guide</a>
	<span> · </span>
	<a href="#license">License</a>
</h2>

## About

Inception is a starter project in Docker. This project aims to broaden your knowledge of system administration by using Docker.
You will virtualize several Docker images, creating them in your new personal virtual
machine. [You can find more information in the subject](https://github.com/Javisanchezf/42Malaga-pdfs/blob/main/inception_subject.pdf).


This is the structure of the program:

<div align = center>
  <img src="srcs_bonus/website/media/inception-resume.webp" width="800"/>
</div>

## Requirements


Before you begin with this project, ensure that you have the following prerequisites installed:

- [Docker](https://docs.docker.com/get-docker/): Make sure you have Docker installed on your system. Docker is a platform for developing, shipping, and running applications in containers.

- [Docker Compose](https://docs.docker.com/compose/install/): If your project uses Docker Compose for multi-container orchestration, make sure to have Docker Compose installed. Docker Compose is a tool for defining and running multi-container Docker applications.

- [Git](https://git-scm.com/): If your project involves cloning a Git repository, ensure that Git is installed on your machine.

- [Make](https://www.gnu.org/software/make/): If your project includes a Makefile for automation, you may want to have Make installed to simplify build and deployment tasks.

[Additional notes]
- Ensure that you have the necessary permissions to run Docker commands without the need for `sudo`. You might need to add your user to the `docker` group.

- Verify that your system meets the hardware and software requirements specified by Docker for your operating system.

- Familiarize yourself with Docker concepts and basic commands, such as building images, running containers, and managing volumes.


## Instructions

### 1. Download the repository

To download the repository, go to the console and run:
```
git clone https://github.com/Javisanchezf/42Malaga-inception.git
cd 42Malaga-inception
```

### 2. Compiling the library

To compile the library, go to its path and run:

```
make
```
Or the bonus version:
```
make bonus
```
### 3. Cleaning all binary (.o) executable files (.a) and the program

To delete all files and containers generated with make, go to the path and run:
```
make clean
```

## Guide

---
### Step 0: Create the virtual machine

For a virtual machine I recommend in this order:
- Alpine with XFCE (or other graphical interface): Since it is a minimal image, just what is necessary for this project. The benefits are learning how to use alpine and having a very lightweight VM that can be useful for underpowered computers.
- Ubuntu: For its ease of installation and use.
- Debian: Another viable option.

Here I will show how to create a minimal Alpine VM.

1. Download the “Virtual” realease for your processor architecture at https://alpinelinux.org/downloads.

2. Spin up a VM in Oracle VirtualBox with enough RAM(4 - 8) and disk space (10 - 20), the mount the downloaded ISO.

3. Log in with the user root and no password, then run setup-alpine to install Alpine Linux to the disk.

4. Choose sda as the disk, sys as the use case and confirm you want the disk to be erased. Accepting everything else on default is fine.

5. After the installation succeeds, poweroff the VM and unmount the ISO.

6. Run this command to setup the graphical environment and install other needed programs:
```
setup-xorg-base xfce4 lightdm-gtk-greeter xfce4-terminal chromium mousepad
```
7. Then run this command, so the graphical interface starts when the system boots up.
```
rc-update add lightdm && rc-update add dbus
```
8. Finally reboot the system and you have the grafical interface. (If you have problems with chromium try apk add firefox-esr and then run firefox-esr).

9. Congratulations! You have a minimal VM.

Tip initial downloads:
```
sed -i 's/#//g' /etc/apk/repositories
apk add --no-cache firefox-esr docker docker-compose git make
```
### Step 1: Understand basic commands

A quick reference for commonly used Docker commands.

| Docker Command                   | Description                                                 |
| ---------------------------------| ----------------------------------------------------------- |
| `docker pull <image>`             | Pulls an image from Docker Hub or a registry.                |
| `docker build -t <tag> .`         | Builds a Docker image from the current directory.           |
| `docker push <image>`             | Pushes a Docker image to a registry.                        |
| `docker images`                   | Lists locally available Docker images.                      |
| `docker rmi <image>`              | Removes a Docker image.                                     |
| `docker ps`                       | Lists running containers.                                   |
| `docker ps -a`                    | Lists all containers, including stopped ones.               |
| `docker run <options> <image>`    | Creates and starts a container based on an image.            |
| `docker exec -it <container>`     | Opens an interactive shell inside a running container.      |
| `docker start <container>`        | Starts a stopped container.                                  |
| `docker stop <container>`         | Stops a running container.                                   |
| `docker restart <container>`      | Stops and then starts a container.                           |
| `docker pause <container>`        | Pauses a running container.                                  |
| `docker unpause <container>`      | Unpauses a paused container.                                |
| `docker kill <container>`         | Sends a signal to stop a container.                         |
| `docker rm <container>`           | Removes a stopped container.                                 |
| `docker rm -f <container>`        | Forcefully removes a running container.                     |
| `docker logs <container>`         | Displays the logs of a container.                            |
| `docker inspect <container>`      | Displays detailed information about a container.             |
| `docker network ls`               | Lists Docker networks.                                      |
| `docker volume ls`                | Lists Docker volumes.                                       |
| `docker-compose up`               | Starts services defined in a `docker-compose.yml`.          |
| `docker-compose down`             | Stops and removes services defined in `docker-compose.yml`. |

Feel free to explore these Docker commands to manage images, containers, networks, volumes, and more effectively. Adjust the `<options>`, `<container>`, and `<image>` placeholders based on your specific use case.

You can start with the command:
```
docker run hello-world
```

### Step 3

Comming soon...

## License

This work is licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-nc-sa/4.0/).

You are free to:
* Share: copy and redistribute the material in any medium or format.
* Adapt: remix, transform, and build upon the material.

Under the following terms:
* Attribution: You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
* NonCommercial: You may not use the material for commercial purposes.
* ShareAlike: If you remix, transform, or build upon the material, you must distribute your contributions under the same license as the original.

<h3 align = right>Thanks for the support!</h3>