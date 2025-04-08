---
title: DevOps Workshop
theme: seriph
background: https://cover.sli.dev
class: text-center
transition: slide-left
mdc: true
---

# Welcome to RegretBoard
## A Practical DevOps Workshop

---

# What is DevOps?

<VClickList>

- Dev + Ops = Delivery + Infrastructure
- Managing **nodes** and deploying **artifacts**
- Automation, monitoring, scaling
- DevOps is not a tool—it’s a **process**

</VClickList>

---

## DevOps Concepts (continued)
<VClickList>

- Collaboration between developers and operators
- CI/CD pipelines
- Infrastructure as Code

</VClickList>

---

# The Application
<VClickList>

- We’re deploying **RegretBoard**, a Spring Boot app
- View the codebase together
- Demonstrate it running locally

</VClickList>

---

## Application Tour (continued)
<VClickList>

- Controller
- Repository
- Entity structure

</VClickList>

---

# What Does "Online" Mean?
<VClickList>

- HTTP, TCP, HTTPS, ports
- Web servers and protocols
- DNS (skipped for now, but it exists)

</VClickList>

<img src="https://upload.wikimedia.org/wikipedia/commons/e/e3/Client-server-model.svg" class="w-80 mx-auto mt-6" />

---

# Hosting: Where Do We Deploy?
<VClickList>

- VPS vs Cloud Platforms
- AWS, Azure, GCP
- Why AWS: widespread adoption, market share

</VClickList>

---

## Choosing AWS (continued)
<VClickList>

- Long-term relevance
- Tools and integrations
- IAM model and permissions

</VClickList>

---

# Creating an EC2 Instance
<VClickList>

- AWS Console walkthrough
- Create and connect via SSH
- Understand: **It’s just a Linux box**

</VClickList>

---

## EC2 Details (continued)
<VClickList>

- Public IP, security groups
- Instance types
- AMIs

</VClickList>

---

# SSH: Public/Private Key Auth
<VClickList>

- Key pair concept
- Generate your own key
- Practice connecting to your EC2

</VClickList>

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
ssh -i ~/.ssh/id_ed25519 ubuntu@your-ec2-ip
```

---

## SSH Deep Dive (continued)
<VClickList>

- Why keys are safer than passwords
- Public key distribution
- Managing access in teams

</VClickList>

---

# Manual Deployment
<VClickList>

- Copy JAR to EC2
- Run app manually → fails (no DB)

</VClickList>

```bash
scp target/app.jar ubuntu@your-ec2-ip:~/
java -jar app.jar
```

---
---
title: Terraform & IaC Deep Dive
theme: seriph
transition: slide-left
mdc: true
---

# Infrastructure as Code (IaC)
<VClickList>

- Manage infrastructure using code files
- Replace clicking in web UIs with declarative configuration
- Benefits:
  - **Repeatability** – same result every time
  - **Version Control** – track, review, and revert infra changes
  - **Automation** – easily tear up or down environments

</VClickList>

---

# Introducing Terraform
<VClickList>

- Tool by HashiCorp for managing infrastructure
- Written in **HCL (HashiCorp Configuration Language)**
- Works with many providers: AWS, Azure, GCP, Docker, etc.
- Open-source and popular in production setups

</VClickList>

---

## Installing Terraform

- On macOS:
```bash {monaco}
brew install terraform
```

- On Linux:
```bash {monaco}
sudo apt install terraform
```

- Or download directly from terraform.io

---

# Terraform Workflow

<v-click>
<VClickList>

- `terraform init` → setup working directory
- `terraform plan` → show proposed changes
- `terraform apply` → apply the changes
- `terraform destroy` → destroy managed infrastructure

</VClickList>

</v-click>

---

# terraform init
<VClickList>

- Prepares your directory for use with Terraform
- Downloads provider plugins and sets up backend

</VClickList>

```bash {monaco}
$ terraform init
```

---

## terraform init (output)

```hcl {monaco}
Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/aws versions matching ">= 3.0.0"...
- Installing hashicorp/aws v5.6.2...
- Installed hashicorp/aws v5.6.2 (signed by HashiCorp)

Terraform has been successfully initialized!
```

---

# terraform plan
<VClickList>

- Shows what actions Terraform will take
- Lets you review before making changes

</VClickList>

```bash {monaco}
$ terraform plan
```

---

## terraform plan (output)

```hcl {monaco}
Terraform will perform the following actions:

  # aws_instance.web will be created
  + resource "aws_instance" "web" {
      + ami           = "ami-0c55b159cbfafe1f0"
      + instance_type = "t2.micro"
      + tags = {
          + "Name" = "RegretBoard"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

---

# terraform apply
<VClickList>

- Applies changes and creates resources
- Prompts for approval unless `-auto-approve` is used

</VClickList>

```bash {monaco}
$ terraform apply
```

---

## terraform apply (output)

````md magic-move
```hcl
Terraform will perform the following actions:

  # aws_instance.web will be created
  + resource "aws_instance" "web" { ... }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value:
```
```hcl
Terraform will perform the following actions:

  # aws_instance.web will be created
  + resource "aws_instance" "web" { ... }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_instance.web: Creating...
aws_instance.web: Creation complete after 15s [id=i-0abcd1234efgh5678]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```
````

---
transition: slide-up
---

# terraform destroy
<VClickList>

- Destroys all resources managed by Terraform
- Asks for confirmation before proceeding

</VClickList>

```bash {monaco}
$ terraform destroy
```

--- 

## terraform destroy (output)

````md magic-move
```hcl
Terraform will destroy the following resources:

  # aws_instance.web will be destroyed
  - resource "aws_instance" "web" { ... }

Plan: 0 to add, 0 to change, 1 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value:
```
```hcl
Terraform will destroy the following resources:

  # aws_instance.web will be destroyed
  - resource "aws_instance" "web" { ... }

Plan: 0 to add, 0 to change, 1 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

aws_instance.web: Destroying...
aws_instance.web: Destruction complete after 10s

Destroy complete! Resources: 1 destroyed.
```
````

---

# AWS Credentials

Terraform needs credentials to access AWS:

```bash
export AWS_ACCESS_KEY_ID="your_key"
export AWS_SECRET_ACCESS_KEY="your_secret"
```

Alternative: use `~/.aws/credentials` and configure provider with a named profile.

---

# Providers
<VClickList>

- Terraform needs a provider block to know what to manage:

</VClickList>

```hcl {monaco}
provider "aws" {
  region  = "eu-west-1"
  profile = "default"
}
```
<VClickList>

- This can be reused across modules and configurations

</VClickList>

---

# Variables and Outputs
<VClickList>

- Define variables to reuse and parameterize configs:

</VClickList>
```hcl {monaco}
variable "instance_type" {
  default = "t2.micro"
}
```
<VClickList>

- Output useful information after apply:

</VClickList>
```hcl {monaco}
output "public_ip" {
  value = aws_instance.web.public_ip
}
```

---

# Example: EC2 Instance - Provider

```hcl {monaco}
provider "aws" {
  region = "eu-west-1"
}
```
<VClickList>

- This block sets up the AWS provider and specifies the region.

</VClickList>

---

# Example: EC2 Instance - Resource

```hcl {monaco}
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}
```
<VClickList>

- This block defines the EC2 instance, specifying the AMI and instance type.

</VClickList>

---

# Example: EC2 Instance - Output

```hcl {monaco}
output "public_ip" {
  value = aws_instance.web.public_ip
}
```
<VClickList>

- This block outputs the public IP of the created instance.

</VClickList>
```
---

# How to use

- ✅ `terraform init`  
- 🔍 `terraform plan`  
- 🚀 `terraform apply`  
- 💥 `terraform destroy`

---

# Next: Bring Infra and App Together
<VClickList>

- Use Terraform to provision
- Use Docker to deploy
- Tie into CI/CD for automation

</VClickList>

---

# Day 1 Recap

:::info
You now:
:::
<VClickList>

- Understand DevOps
- Created and accessed an EC2
- Launched infra using code

</VClickList>

---

# Containers & Docker
<VClickList>

- What is a container?
- Dockerfile → Image → Container
- Build RegretBoard as a container

</VClickList>

```dockerfile
FROM openjdk:17
COPY target/app.jar app.jar
CMD ["java", "-jar", "app.jar"]
```

---

## Docker Concepts (continued)
<VClickList>

- Layers and caching
- Tagging and pushing
- Image vs container

</VClickList>

---

# Transition: From Docker to CI/CD
<VClickList>

- We've containerized our application with Docker.
- Next, we'll automate deployment with CI/CD.
- This ensures consistent and reliable application delivery.

</VClickList>

---

# Run on EC2 (Oops… No DB)
<VClickList>

- Try to run Docker container
- App fails → needs database

</VClickList>

<img src="https://docker-curriculum.com/images/docker-containerized-app.png" class="w-70 mx-auto mt-6" />

---

# Enter Docker Compose
<VClickList>

- Solution for multi-container apps
- Define app + Postgres
- Compose up → still fails (missing schema)

</VClickList>

```yaml
services:
  db:
    image: postgres
  app:
    build: .
    depends_on:
      - db
```

---

## Compose Insights (continued)
<VClickList>

- Environment variables
- Volumes and persistent storage
- Networking between services

</VClickList>

---

# Database Init Scripts
<VClickList>

- Look into app requirements
- Create SQL schema manually
- Mount as init script in Compose

</VClickList>

```sql
CREATE TABLE regret (
  id SERIAL PRIMARY KEY,
  title TEXT,
  severity TEXT
);
```

---

# Now It Works
<VClickList>

- Docker Compose starts everything
- App is alive 🎉

</VClickList>

---

# The Pain of Manual Deployment
<VClickList>

- Rebuild locally
- SCP to server
- Restart Compose

</VClickList>

<v-click>
This gets old **fast**.
</v-click>

---

# CI/CD to the Rescue
<VClickList>

- What is CI/CD?
- Automation with GitHub Actions
- Other tools: CircleCI, Jenkins, etc.

</VClickList>

---

## CI/CD Concepts (continued)
<VClickList>

- Continuous Integration vs Deployment
- Pipeline anatomy
- Environments and secrets

</VClickList>

---

# Our Pipeline
<VClickList>

- Git push triggers:
  - Build Docker image
  - Upload image to EC2
  - Restart Compose

</VClickList>

```yaml
on: push
jobs:
  deploy:
    steps:
      - name: Build & Deploy
        run: |
          docker build .
          scp image.tar.gz user@ec2:/app/
          ssh user@ec2 'docker-compose up -d'
```

---

# Live Deployment
<VClickList>

- Make a code change
- Push to GitHub
- Watch it deploy in real time 🚀

</VClickList>

---

# Wrap-Up & Questions
<VClickList>

- What you’ve learned:
  - Cloud ☁️
  - Terraform 🛠️
  - Docker 🐳
  - CI/CD 🔁

</VClickList>

- Where to go from here?

<carbon:logo-github class="text-4xl" />

