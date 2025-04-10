
# Day 1 dependencies

- Let's look at the things we installed yesterday:

- AWS command line tool
  ```bash {monaco}
    brew install awscli
  ```

- Running the AWS configuration and plugging in our id&secret
  ```bash {monaco}
    aws configure
  ```

- Installing terraform
  ```bash {monaco}
    brew install terraform
  ```

- Ensuring you've got a ssh key already:
  ```bash {monaco}
    cat ~/.ssh/id_ed25519
  ```

---

# Day 1 dependencies

- Having the this file in a folder of your choosing (copy it by using the button on the top right that shows when you hover!):

<div class="max-h-60 overflow-auto border rounded p-4">
```bash

  terraform {
    backend "local" {
      path = "terraform.tfstate"
    }
  }

  provider "aws" {
    profile = "default"
  }

  variable "student_public_key" {
    description = "Public key material (looks like ssh-ed25519 AAAAC3N...)"
    type        = string
  }

  resource "random_pet" "student_id" {
    length = 2
  }

  # Create the key pair
  resource "aws_key_pair" "student_key" {
    key_name   = "student-${random_pet.student_id.id}"
    public_key = var.student_public_key
  }

  # Create a security group allowing SSH, HTTP, and HTTPS
  resource "aws_security_group" "student_sg" {
    name        = "student-sg-${random_pet.student_id.id}"
    description = "Allow SSH, HTTP, and HTTPS access"

    ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Lookup the latest AMI with the name "devops-workshop"
  data "aws_ami" "devops_workshop" {
    most_recent = true

    filter {
      name   = "name"
      values = ["devops-workshop"]
    }

    owners = ["self"]
  }

  # Create the EC2 instance
  resource "aws_instance" "student_instance" {
    ami                         = data.aws_ami.devops_workshop.id
    instance_type               = "t3.micro"
    key_name                    = aws_key_pair.student_key.key_name
    vpc_security_group_ids      = [aws_security_group.student_sg.id]
    associate_public_ip_address = true

    tags = {
      Name    = "student-${random_pet.student_id.id}"
      Purpose = "DevOpsWorkshop"
    }
  }

  output "instance_public_ip" {
    value = aws_instance.student_instance.public_ip
  }

  output "student_instance_id" {
    value = random_pet.student_id.id
  }

```
</div>

- This file does a lot! It creates an ec2 instance with your SSH key in it!
- <a href="/67 ">A step-by-step explanation of the file is here</a>

---

- Running this in a terminal in the folder above:
  ```bash
  echo "student_public_key = \"$(< ~/.ssh/id_ed25519.pub)\"" > terraform.tfvars
  ```

- Then finally, run this and make sure the output looks similar:

````md magic-move
```bash
terraform apply
```

```bash
terraform apply

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
````
---

# Automating Post-Deployment Setup with Terraform

<VClickList>

- If you copy your jar to the server, it still won't work. When we previously did, we cheated: java and postgres were already installed.
- Installing dependencies/apps/libraries on servers is called **provisioning**.
- Tools like **Chef** and **Ansible** are popular for managing complex configurations across multiple servers.

</VClickList>

---

# Understanding Terraform Provisioners
<VClickList>

- **Provisioners**: Scripts that run on your instances to configure them post-deployment.
- They automate tasks like software installation and configuration.
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

# Provisioning Pitfalls 
<VClickList>

- **Provisioning Challenges**:
  - Manual setup can be error-prone and time-consuming.
  - Scripts may fail due to dependencies or network issues.
  - Difficult to maintain consistency across environments.
  - Debugging is hard
  - Ensuring your dev environment matches the server is a hard and manual job (different database versions, different java versions, etc)

</VClickList>

---

# There is another way  

<VClickList>

- Instead, (some of) the industry adopted a different approach
- Putting your software in "boxes"...
- ...then plugging those "boxes" in servers! 

</VClickList>
---