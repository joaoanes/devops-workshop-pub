
# Understanding Containers
<VClickList>

- **Containers**: Lightweight, portable, and self-sufficient units that run software.
    - Containers encapsulate an application and its dependencies, ensuring consistency across environments.

- **Docker/OSI Images**: Like snapshots of a pre-configured system, they include everything needed to run an application, such as the code, runtime, libraries, and environment settings.

- **Dockerfiles**: Descriptive scripts that define how to build a Docker image.
    - Dockerfiles specify the base image, application code, dependencies, and commands to run.

</VClickList>

---

# What is Docker?
<VClickList>

- **Docker**: A platform for developing, shipping, and running applications in containers.
- It allows developers to package applications with all necessary components, ensuring they run on any system.

- **Installing Docker on macOS**:
  - Download Docker Desktop from the [Docker website](https://www.docker.com/products/docker-desktop).
  - Open the downloaded file and drag Docker to the Applications folder.
  - Launch Docker from Applications and follow the setup instructions.

</VClickList>

---

# Common Docker Commands

- **List Running Docker Containers**:
````md magic-move
```bash
docker ps
```
```bash
docker ps

CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS         PORTS                    NAMES
a1b2c3d4e5f6   nginx         "nginx -g 'daemon of…"   5 minutes ago   Up 5 minutes   0.0.0.0:80->80/tcp       webserver
b2c3d4e5f6g7   postgres      "docker-entrypoint.s…"   10 minutes ago  Up 10 minutes  0.0.0.0:5432->5432/tcp   database
```
````
---

# Common Docker Commands

- **Run a Container**:
````md magic-move
```bash
docker run hello-world
```
```bash
docker run hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.
```
````

---

# Common Docker Commands

- **Stop a Running Container**:
````md magic-move
```bash
docker stop <container_id>
```
```bash
docker stop <container_id>

<container_id>
```
````

---

# Common Docker Commands

- **Run commands inside a running container**:
````md magic-move
```bash
docker exec -it <container_id> ls /
```
```bash
docker exec -it <container_id> ls /

bin   boot  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
```
````

---

# Creating Docker Images
<VClickList>

- **Docker Images**: Built from Dockerfiles, which contain instructions for assembling an image.
- **Dockerfile**: A text document with all the commands to assemble an image.
- **Build Process**: Use `docker build` to create an image from a Dockerfile.
  - Example: `docker build -t my-image .`
- **Layers**: Each instruction in a Dockerfile creates a layer in the image, making it efficient and reusable.

</VClickList>

---

# What is a dockerfile?
```dockerfile
# Use the latest Ubuntu image
FROM ubuntu:latest

# Add a public key to the authorized_keys file
RUN mkdir -p /root/.ssh && \
    echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB3NzaC1yc2EAAAADAQABAAABAQC7" > /root/.ssh/authorized_keys

# Set permissions
RUN chmod 700 /root/.ssh && \
    chmod 600 /root/.ssh/authorized_keys
```

---

# Dockerfile Commands
<VClickList>

- **FROM**: Sets the base image for subsequent instructions.
  - Example: `FROM ubuntu:latest`

- **RUN**: Executes commands in a new layer on top of the current image and commits the results.
  - Example: `RUN apt-get update && apt-get install -y curl`

- **CMD**: Provides defaults for an executing container.
  - Example: `CMD ["nginx", "-g", "daemon off;"]`

- **EXPOSE**: Informs Docker that the container listens on the specified network ports at runtime.
  - Example: `EXPOSE 80`

- **COPY**: Copies new files or directories from the source path and adds them to the filesystem of the container.
  - Example: `COPY . /app`

- **ENTRYPOINT**: Configures a container to run as an executable.
  - Example: `ENTRYPOINT ["/usr/sbin/nginx"]`

- **ENV**: Sets environment variables.
  - Example: `ENV NODE_ENV=production`

</VClickList>

---

# Here's what you can do with docker
<VClickList>

- **Convert a Video with FFmpeg**:
  ```bash
  docker run -v $(pwd):/videos jrottenberg/ffmpeg -i /videos/input.mp4 /videos/output.avi
  ```
  - This command uses the FFmpeg Docker image to convert a video file format.

- **Run a Temporary Database**:
  ```bash
  docker run --name my-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres
  ```
  - Quickly spin up a PostgreSQL database for testing or development.

- **Start a Python REPL**:
  ```bash
  docker run -it python:3.9
  ```
  - Launch an interactive Python shell using the latest Python image, without having to install anything!

</VClickList>

---

# Docker Image Entrypoint
<VClickList>

- **Entrypoint**: The default command that runs when a container starts.
- You can override the entrypoint to run different commands.
- Example: Run a bash shell in the Postgres image:
  ```bash
  docker run -it --entrypoint bash postgres
  ```
  - This command starts a bash shell instead of the default Postgres server.

</VClickList>

---

# Dockerfile with Cowsay Entrypoint
```dockerfile
# Use the latest Ubuntu image
FROM ubuntu:latest

# Install cowsay
RUN apt-get update && apt-get install -y cowsay

# Set the entrypoint to cowsay
ENTRYPOINT ["/usr/games/cowsay"]
```

- We've just turned an operating system image into something that just does one thing.
- We can do the same with our app!

---

# Images vs. Containers
<VClickList>

- **Images**: Immutable files that contain the source code, libraries, dependencies, and tools needed for an application to run.
- **Containers**: Running instances of images. They are created using the `docker run` command.
- Use `docker exec` to run commands inside an already running container.

</VClickList>
