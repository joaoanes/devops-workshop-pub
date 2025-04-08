# Let's go back to our app and our server

- **No More Manual Database Setup:** With Docker Compose, you no longer need to manually set up a database server. The compose file handles everything for you.

We just need 3 things now:
<VClickList>

- Transfer the Docker Image
- Transfer the Compose File
- Transfer the Initialization Script
- Run the application
- ???
- Profit

</VClickList>

---

# Transfer the Docker Image:

<VClickList>

- Save your Docker image to a tar file:
    ```bash
    docker save -o regretboard.tar regretboard:latest
    ```
- Use `scp` to transfer the tar file to the server:
    ```bash
    scp regretboard.tar ubuntu@server:/home/ubuntu/regretboard.tar
    ```
- On the server, load the image:
    ```bash
    ssh user@server
    user@server> docker load -i /home/ubuntu/regretboard.tar
    ```
</VClickList>

---

# Transfer the Compose File
- Copy your `docker-compose.yml` file to the server:
```bash
scp docker-compose.yml user@server:/home/ubuntu
```

---

# Transfer the Initialization Script
- Copy the `init.sql` file to the server:
    ```bash
    scp init.sql user@server:/home/ubuntu
    ```

---

# Run the Application:
  - On the server, navigate to the deployment directory and start the services:
    ```bash
    ssh user@server 
    user@server> docker-compose up -d
    ```

---

# Confirm it works

- Using chrome, go to http://<server ip>/regrets, and check it out!

## Troubleshooting

- **Check Compose Status:**
  - Run `docker-compose ps` to ensure all services are up and running.

- **View Logs:**
  - Use `docker-compose logs -f` to view real-time logs and identify any errors.

- **Inspect Containers:**
  - Use `docker inspect <container_name>` to check container configurations and network settings.

- **Restart Services:**
  - If issues persist, try restarting the services with `docker-compose restart`.

---

# Updating Your Application

- **Manual Update Process:**
  - Build a new docker image of your app locally.
  - Transfer the updated image to the server.
  - Restart the services to pick up the latest version.

- **Challenges:**
  - This process can be repetitive and error-prone.

<v-click>
This gets old **fast**.
</v-click>

---



# CI/CD to the Rescue

## What is CI/CD?

- **Continuous Integration (CI):** The practice of automatically building and testing code changes, ensuring that new code integrates smoothly with the existing codebase.
- **Continuous Deployment (CD):** The process of automatically deploying code changes to production, ensuring that new features and fixes are delivered quickly and reliably.

---

## Benefits of CI/CD

- **Automation:** Reduces manual intervention, minimizing human error and speeding up the development process.
- **Consistency:** Ensures that code is tested and deployed in a consistent manner across all environments.
- **Rapid Feedback:** Provides immediate feedback on code changes, allowing developers to address issues quickly.

---

## Problems Solved by CI/CD

- **Integration Issues:** Automatically tests code changes to catch integration problems early.
- **Deployment Delays:** Automates the deployment process, reducing the time it takes to release new features.
- **Environment Discrepancies:** Ensures that code runs consistently across different environments.

---

## Tools for CI/CD

- **GitHub Actions:** A popular tool for automating workflows directly within GitHub.
- **CircleCI:** A cloud-based CI/CD tool that integrates with GitHub and other version control systems.
- **Jenkins:** An open-source automation server that supports building, deploying, and automating any project.

---

## CI/CD Concepts (continued)

### Pipeline Anatomy
- **Stages:** A pipeline is represented by a file, usually YAML, and is divided into stages, each representing a phase in the CI/CD process, such as build, test, and deploy.
- **Jobs:** Each stage consists of jobs that perform specific tasks, like running tests or deploying code.
- **Triggers:** Pipelines can be triggered by events such as code pushes, pull requests, or scheduled times.

### Environments and Secrets
- **Environments:** Define where your code runs, such as development, staging, or production. Each environment can have different configurations.
- **Secrets Management:** Securely store sensitive information like API keys and passwords. CI/CD tools provide mechanisms to manage and inject secrets into your pipeline without exposing them in your codebase.
---

# Our ideal pipeline

- Git push triggers:

<VClickList>
- Build Docker image
- Upload image to EC2
- Restart Compose
</VClickList>

---

## Introduction to GitHub Actions

- **What is GitHub Actions?**
  - GitHub Actions is a CI/CD tool integrated directly into GitHub, allowing you to automate your workflow by defining
custom workflows in your repository.

- **How it Works:**
  - Workflows are defined in YAML files located in the `.github/workflows` directory of your repository.
  - Each workflow can be triggered by specific events, such as pushes to the repository, pull requests, or on a
schedule.

- **Benefits:**
  - Seamless integration with GitHub repositories.
  - Supports a wide range of actions and integrations with other services.
  - Provides a marketplace for reusable actions created by the community.

---

# Super minimal example

```yaml
on: push
jobs:
  deploy:
    steps:
      - name: Build & Deploy
        run: |
          docker build . -t regretboard
          docker save -o regretboard.tar regretboard
          scp regretboard.tar ubuntu@ec2-server:/app/
          ssh ubuntu@ec2-server 'docker load -i regretboard.tar'
          ssh ubuntu@ec2-server 'docker-compose up -d'
```
---

## Setting Up Secrets in GitHub

- **Why Secrets?**
  - Secrets are used to store sensitive information like passwords, API keys, and SSH keys securely.

- **How to Set Up Secrets:**
  1. Navigate to your GitHub repository.
  2. Go to **Settings** > **Secrets and variables** > **Actions**.
  3. Click on **New repository secret**.
  4. Enter a name for your secret (e.g., `EC2_SSH_KEY`) and paste the secret value.
  5. Click **Add secret**.

- **Using Secrets in Workflows:**
  - Access secrets in your workflow using the `secrets` context, e.g., `${{ secrets.EC2_SSH_KEY }}`.

This setup ensures that sensitive information is not exposed in your codebase.

---

# Understanding deploy.yml

## Workflow Overview

```yaml
name: Deploy RegretBoard

on:
  push:
    branches: [spoilers]
```

- **Name:** The workflow is named "Deploy RegretBoard".
- **Trigger:** It runs on pushes to the `spoilers` branch.

## Build Job

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3
      - name: Build Docker image
        run: docker build -t regretboard:latest .
```

- **Runs On:** The job runs on the latest Ubuntu environment.
- **Steps:** It checks out the code, sets up Docker Buildx, and builds the Docker image.

## Copy Job

```yaml
  copy:
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Download image artifact
        uses: actions/download-artifact@v4
      - name: Copy image to server
        uses: appleboy/scp-action@v0.1.4
```

- **Dependencies:** This job depends on the `build` job.
- **Steps:** It downloads the Docker image artifact and copies it to the server.

## Deploy Job

```yaml
  deploy:
    runs-on: ubuntu-latest
    needs: copy
    steps:
      - name: SSH and deploy
        uses: appleboy/ssh-action@v1.0.0
        with:
          script: |
            docker load < regretboard.tar.gz
            docker-compose down
            docker-compose up -d
```

- **Dependencies:** This job depends on the `copy` job.
- **Steps:** It SSHs into the server, loads the Docker image, and restarts the services using Docker Compose.

## Detailed Analysis of deploy.yml

````md magic-move
```yaml {all}
name: Deploy RegretBoard

on:
  push:
    branches: [spoilers]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3
      - name: Build Docker image
        run: docker build -t regretboard:latest .
  copy:
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Download image artifact
        uses: actions/download-artifact@v4
      - name: Copy image to server
        uses: appleboy/scp-action@v0.1.4
  deploy:
    runs-on: ubuntu-latest
    needs: copy
    steps:
      - name: SSH and deploy
        uses: appleboy/ssh-action@v1.0.0
        with:
          script: |
            docker load < regretboard.tar.gz
            docker-compose down
            docker-compose up -d
```
```yaml {1-3}
# Workflow Name and Trigger
name: Deploy RegretBoard

on:
  push:
    branches: [spoilers]
```
```yaml {5-7}
# Build Job Setup
jobs:
  build:
    runs-on: ubuntu-latest
```
```yaml {8-12}
# Build Job Steps
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3
```
```yaml {13-14}
# Docker Image Build
      - name: Build Docker image
        run: docker build -t regretboard:latest .
```
```yaml {15-17}
# Copy Job Setup
  copy:
    runs-on: ubuntu-latest
    needs: build
```
```yaml {18-21}
# Copy Job Steps
    steps:
      - name: Download image artifact
        uses: actions/download-artifact@v4
```
```yaml {22-23}
# Copy Image to Server
      - name: Copy image to server
        uses: appleboy/scp-action@v0.1.4
```
```yaml {24-26}
# Deploy Job Setup
  deploy:
    runs-on: ubuntu-latest
    needs: copy
```
```yaml {27-31}
# Deploy Job Steps
    steps:
      - name: SSH and deploy
        uses: appleboy/ssh-action@v1.0.0
        with:
          script: |
            docker load < regretboard.tar.gz
            docker-compose down
            docker-compose up -d
```
````
