# Live demo: Let's try out the app!
<VClickList>

- Copy JAR to EC2
  ```bash
  scp target/app.jar ubuntu@your-ec2-ip:~/
  ```

- Check if we have a database
- Run app manually 

</VClickList>


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

# Structure of a Terraform File
<VClickList>

- **Provider Block**: Specifies the provider and configuration details.
  ```hcl
  provider "aws" {
    region = "us-west-2"
  }
  ```

- **Resource Block**: Defines the resources to be created.
  ```hcl
  resource "aws_instance" "example" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
  }
  ```

</VClickList>

---

# Additional Components in Terraform
<VClickList>

- **Variable Block**: Defines input variables for dynamic configuration.
  ```hcl
  variable "instance_type" {
    default = "t2.micro"
  }
  ```

- **Output Block**: Outputs useful information after deployment.
  ```hcl
  output "instance_ip" {
    value = aws_instance.example.public_ip
  }
  ```

- **Data Block**: Retrieves information from existing resources.
  ```hcl
  data "aws_ami" "latest" {
    most_recent = true
    owners      = ["self"]

    filter {
      name   = "name"
      values = ["my-ami-*"]
    }
  }
  ```

</VClickList>
---

# Terraform Support Across Cloud Providers
<VClickList>

- **AWS**: Full support for managing resources like EC2, S3, RDS, and more.
- **Azure**: Manage VMs, storage accounts, databases, and other Azure services.
- **Google Cloud Platform (GCP)**: Provision compute instances, storage, and networking.
- **Others**: Supports many other providers like DigitalOcean, Alibaba Cloud, and more.

- Terraform's provider ecosystem allows it to manage infrastructure across multiple cloud platforms seamlessly.

</VClickList>

---

# Terraform Workflow

<VClickList>

- `terraform init` → setup working directory
- `terraform plan` → show proposed changes
- `terraform apply` → apply the changes
- `terraform destroy` → destroy managed infrastructure

</VClickList>


---
transition: slide-up
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
transition: slide-up
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
transition: slide-up
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

Thankfully we already ran aws configure, so we can check `~/.aws/credentials` that our credentials are there.

---

# Providers
<VClickList>

- Terraform needs a provider block to know what to manage:
  ```hcl {monaco}
  provider "aws" {
    region  = "eu-west-1"
  }
  ```
- This can be reused across modules and configurations
- If you provide no credentials, it'll try reading them from multiple places, starting with your AWS configuration.

</VClickList>

---

# Variables and Outputs
<VClickList>

- Define variables to reuse and parameterize configs:
  ```hcl {monaco}
  variable "instance_type" {
    default = "t2.micro"
  }
  ```

- Output useful information after apply:
  ```hcl {monaco}
  output "public_ip" {
    value = aws_instance.web.public_ip
  }
  ```
</VClickList>
---

# Writing Your First Terraform File

- We want to bring up an ec2. How?

---

# Step 1: Configure the Backend
<VClickList>

- **Backend Block**: Configures where Terraform stores its state files.
  ```hcl
  terraform {
    backend "local" {
      path = "terraform.tfstate"
    }
  }
  ```
- This ensures that Terraform can track the state of your infrastructure.

</VClickList>

---

# Step 2: Set Up the Provider
<VClickList>

- **Provider Block**: Specifies the provider (e.g., AWS) and configuration details.
  ```hcl
  provider "aws" {
    profile = "default"
  }
  ```
- The provider block is essential for Terraform to know which cloud services to interact with.

</VClickList>

---

# Step 3: Define Variables
<VClickList>

- **Variable Block**: Defines input variables for the configuration.
  ```hcl
  variable "student_public_key" {
    description = "Public key material (looks like ssh-ed25519 AAAAC3N...)"
    type        = string
  }
  ```
- Variables allow for dynamic configuration and reusability.

</VClickList>

---

# Step 4: Generate Unique Identifiers
<VClickList>

- **Random Pet Resource**: Generates a random pet name for unique identifiers.
  ```hcl
  resource "random_pet" "student_id" {
    length = 2
  }
  ```
- This helps in creating unique resource names.

</VClickList>

---

# Step 5: Create the Key Pair
<VClickList>

- **Key Pair Resource**: Creates an AWS key pair for SSH access.
  ```hcl
  resource "aws_key_pair" "student_key" {
    key_name   = "student-${random_pet.student_id.id}"
    public_key = var.student_public_key
  }
  ```
- Key pairs are necessary for secure SSH access to instances.

</VClickList>

---

# Step 6: Set Up Security Groups
<VClickList>

- **Security Group Resource**: Manages security groups for EC2 instances.

- Security groups control inbound and outbound traffic to your instances.

</VClickList>

<v-click>

<div class="max-h-80 overflow-auto border rounded p-4">
```hcl
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
```
</div>


</v-click>


---

# Step 7: Retrieve the AMI
<VClickList>

- **AMI Data Source**: Retrieves the latest AMI for the instance.
  ```hcl
  data "aws_ami" "devops_workshop" {
    most_recent = true

    filter {
      name   = "name"
      values = ["devops-workshop"]
    }

    owners = ["self"]
  }
  ```
- AMIs are used to define the operating system and software configuration for instances.

</VClickList>

---

# Step 8: Launch the EC2 Instance
<VClickList>

- **EC2 Instance Resource**: Defines the EC2 instance configuration.
  ```hcl
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
  ```
- This is the main resource that creates the virtual machine in AWS.

</VClickList>

---

# Step 9: Define Outputs
<VClickList>

- **Output Blocks**: Provide useful information after deployment.
  ```hcl
  output "instance_public_ip" {
    value = aws_instance.student_instance.public_ip
  }

  output "student_instance_id" {
    value = random_pet.student_id.id
  }
  ```
- Outputs help you retrieve important information about your resources.

</VClickList>

---

# Here's how it should look put together


<div class="max-h-100 overflow-auto border rounded p-4">
```hcl {monaco}
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

resource "aws_key_pair" "student_key" {
  key_name   = "student-${random_pet.student_id.id}"
  public_key = var.student_public_key
}

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

data "aws_ami" "devops_workshop" {
  most_recent = true

  filter {
    name   = "name"
    values = ["devops-workshop"]
  }

  owners = ["self"]
}

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

---

# Again, a primer on terraform:

<VClickList>

- ✅ `terraform init`  
- 🔍 `terraform plan`  
- 🚀 `terraform apply`  
- 💥 `terraform destroy`

</VClickList>

---

# Accessing Your EC2 Instance
<VClickList>

- After running `terraform apply`, retrieve the public IP from the outputs:
  ```bash
  terraform output instance_public_ip
  ```

- Use SSH to connect to your EC2 instance:
  ```bash
  ssh -i ~/.ssh/id_ed25519 ubuntu@<public-ip>
  ```

</VClickList>
