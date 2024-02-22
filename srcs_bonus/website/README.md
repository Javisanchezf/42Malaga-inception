<div id="header" align = center>
  <img src="https://github.com/Javisanchezf/media/blob/main/pc-gif.webp" width="200"/>
</div>

<h1 align = center>42 Malaga Inception</h1>

> School 42 Málaga cursus project.

This repository contains all archives for the project __inception__ in the __School 42 Málaga core cursus__.

<h2 align = center>
	<a href="#about">About</a>
	<span> · </span>
	<a href="#requirements">Requirements</a>
	<span> · </span>
	<a href="#instructions">Instuctions</a>
	<span> · </span>
	<a href="#testing">Testing</a>
	<span> · </span>
	<a href="#references">References</a>
	<span> · </span>
	<a href="#tips">Guide</a>
	<span> · </span>
	<a href="#license">License</a>
</h2>

## About

Inception is a starter project in Docker. This project aims to broaden your knowledge of system administration by using Docker.
You will virtualize several Docker images, creating them in your new personal virtual
machine. [You can find more information in the subject](https://github.com/Javisanchezf/42Malaga-pdfs/blob/main/inception_subject.pdf).


This is the result of the program:

<div align = center>
  <img src="https://github.com/Javisanchezf/42Malaga-inception/blob/main/images/juliainception.webp" width="800"/>
</div>
<div align = center>
  <img src="https://github.com/Javisanchezf/42Malaga-inception/blob/main/images/t2inception.webp" width="800"/>
</div>
<div align = center>
  <img src="https://github.com/Javisanchezf/42Malaga-inception/blob/main/images/earth1inception.webp" width="800"/>
</div>
<div align = center>
  <img src="https://github.com/Javisanchezf/42Malaga-inception/blob/main/images/earth2inception.webp" width="800"/>
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
git clone --recursive https://github.com/Javisanchezf/42Malaga-inception.git
cd 42Malaga-inception
```

### 2. Compiling the library

To compile the library, go to its path and run:

```
make
```

### 3. Cleaning all binary (.o) executable files (.a) and the program

To delete all files generated with make, go to the path and run:
```
make fclean
```
### 4. Using it


You can test the inception with different maps, you have several maps to test in the maps folder, try the following:
```
?????????????
```

## Testing

## References

## Guide

<h3>Understand basic concepts</h3>

---
Step 1: Install Docker

For 42 users in general you can run the following:
```
cd /sgoinfre/shared/42toolbox/
sh init_docker.sh
```

For other users [follow this steeps](https://docs.docker.com/get-docker/).

---
Step 2: Understand basic commands

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

## License
This work is licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-nc-sa/4.0/).

You are free to:
* Share: copy and redistribute the material in any medium or format.
* Adapt: remix, transform, and build upon the material.

Under the following terms:
* Attribution: You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
* NonCommercial: You may not use the material for commercial purposes.
* ShareAlike: If you remix, transform, or build upon the material, you must distribute your contributions under the same license as the original.

<h3 align = right>Share the content!</h3>

[<img src="https://github.com/Javisanchezf/media/blob/main/whatsapp-icon.png" width="50" height="50" align = right></img>](https://api.whatsapp.com/send?text=Hey!%20Check%20out%20this%20cool%20repository%20I%20found%20on%20Github.%20%0ahttps://github.com/Javisanchezf/42Malaga-inception)
[<img src="https://github.com/Javisanchezf/media/blob/main/telegram-icon.webp" width="50" height="50" align = right></img>](https://t.me/share/url?url=https://github.com/javisanchezf/42Malaga-inception&text=Hey!%20Check%20out%20this%20cool%20repository%20I%20found%20on%20Github.)
[<img src="https://github.com/Javisanchezf/media/blob/main/twitter-icon.png" width="50" height="50" align = right></img>](https://twitter.com/intent/tweet?url=https://github.com/Javisanchezf/42Malaga-inception&text=Hey!%20Check%20out%20this%20cool%20repository%20I%20found%20on%20Github)
[<img src="https://github.com/Javisanchezf/media/blob/main/linkedin-icon.png" width="50" height="50" align = right></img>](https://www.linkedin.com/sharing/share-offsite/?url=https://github.com/javisanchezf/42Malaga-inception)
