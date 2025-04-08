# Hosting: Where Do We Deploy?
<VClickList>

- Deploy online by buying or renting servers.
- A server is a computer designed to process requests and deliver data to other computers over a network.
- A VPS (Virtual Private Server) is a virtualized server that acts like a dedicated server within a larger physical server, offering a balance of cost-effectiveness and performance.
- Choose VPS for cost-effectiveness or bare metal for performance.

</VClickList>

---

# Where to buy servers?
<VClickList>

- Use AWS, Azure, or GCP for scalable, managed services.
- Benefits: adoption, market share, tools, and integrations.
- For a more bare metal approach, consider providers like Scaleway or Hetzner, which offer dedicated servers with high performance and control.

</VClickList>

---

# Why AWS?
<VClickList>

- Popular for IAM model and permissions.
- IAM (Identity and Access Management) allows you to manage access to AWS services and resources securely.
- It provides fine-grained control over who can access what, ensuring security and compliance.
- Offers extensive services and integrations.

</VClickList>

---

<img src="https://miro.medium.com/v2/resize:fit:4800/format:webp/1*LuVjQAyRnYLrbWHVMjjRPg.jpeg"/>

---

# How can I get a server from AWS?
<VClickList>

- Use Amazon EC2 (Elastic Compute Cloud) to rent virtual servers.
- EC2 provides scalable computing capacity in the AWS cloud.
- Choose from a variety of instance types optimized for different use cases.
- Pay only for the compute time you use, with options for reserved or spot instances.
- Easily scale up or down based on demand.

</VClickList>

---

# Installing AWS CLI
<VClickList>

- AWS CLI is a unified tool to manage AWS services.
- Install on Linux:
  ```bash
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
  ```
- Verify installation:
  ```bash
  aws --version
  ```

</VClickList>

---

# Creating an EC2 Instance with AWS CLI
<VClickList>

- Configure AWS CLI with your credentials:
  ```bash
  aws configure
  ```
- Launch an EC2 instance:
  ```bash
  aws ec2 run-instances --image-id ami-0abcdef1234567890 --count 1 --instance-type t2.micro --key-name MyKeyPair
  ```

</VClickList>

---
layout: center
---

# Keys?

---
