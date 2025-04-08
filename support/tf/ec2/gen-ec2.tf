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
