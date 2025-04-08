# Automating Post-Deployment Setup with Terraform

<VClickList>

- If you copy your jar to the server, it still won't work. When we previously did, we cheated: java and postgres were already installed.
- This is called **provisioning**.

</VClickList>

# Understanding Provisioners
<VClickList>

- **Provisioners**: Scripts that run on your instances to configure them post-deployment.
- They automate tasks like software installation and configuration.
- Tools like **Chef** and **Ansible** are popular for managing complex configurations across multiple servers.
- Our needs are simple, so we just use a remote-exec provisioner in terraform.
- It just runs commands in sequence.
</VClickList>
---

# Here's what it could be like

```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y openjdk-11-jdk postgresql",
      "sudo systemctl start postgresql",
      "sudo -u postgres psql -c \"CREATE DATABASE regretdb;\""
      "sudo -u postgres psql -c \"CREATE USER regretdb WITH PASSWORD 'neveragain';\"",
      "sudo -u postgres psql -c \"GRANT ALL PRIVILEGES ON DATABASE regretdb TO regretdb;\"",
      "sudo -u postgres psql -d regretdb -c \"CREATE TABLE regrets (id SERIAL PRIMARY KEY, title TEXT, severity TEXT);\""
    ]
  }
}
```
---

# Provisioning Pitfalls and Docker
<VClickList>

- **Provisioning Challenges**:
  - Manual setup can be error-prone and time-consuming.
  - Scripts may fail due to dependencies or network issues.
  - Difficult to maintain consistency across environments.
  - Debugging is hard
  - Hard to ensure your conditions match the server (different database versions, different java versions, etc)

</VClickList>

---
# Containers & Docker
<VClickList>

- What is a container?
- Dockerfile → Image → Container
- Build RegretBoard as a container

</VClickList>

---

# Understanding Containers
<VClickList>

- **Containers**: Lightweight, portable, and self-sufficient units that run software.
- Containers encapsulate an application and its dependencies, ensuring consistency across environments.
- **Docker Images**: Like ISOs for games, they contain everything needed to run an application.
- **Dockerfiles**: Descriptive scripts that define how to build a Docker image.
- Dockerfiles specify the base image, application code, dependencies, and commands to run.

</VClickList>
