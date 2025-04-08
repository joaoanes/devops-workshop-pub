# SSH: Public/Private Key Auth

## What is SSH?
- SSH (Secure Shell) is a protocol for securely accessing remote servers.
- Its keys function like a password but uses cryptography for authentication.

## Public/Private Key Encryption
- SSH uses a pair of keys: a public key and a private key.
- The public key is shared with the server, while the private key remains secure on your device.
- This method is more secure than traditional passwords.

---

## Example Keys
<VClickList>

- **Public Key Example**:
  ```
  ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB3NzaC1yc2EAAAADAQABAAABAQC4...
  ```

- **Private Key Example**:
  ```
  -----BEGIN OPENSSH PRIVATE KEY-----
  b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtz
  c2gtZWQyNTUxOQAAACIBNzaC1yc2EAAAADAQABAAABAQC4...
  -----END OPENSSH PRIVATE KEY-----
  ```

</VClickList>

---

# Creating Your Key Pair
<VClickList>

- Generate a key pair using `ssh-keygen`.
- The private key is stored securely on your machine.
- The public key is added to the server for authentication.
- Do it like this:
    ```bash
    ssh-keygen -t ed25519 -C "your_email@example.com"
    ```
</VClickList>

---

# SSH Key Authentication
<VClickList>

- To access a system via SSH, your public key must be in the `~/.ssh/authorized_keys` file on the server.
- This file authorizes your private key to establish a secure connection.

</VClickList>

---

# AWS and Key Management
<VClickList>

- AWS manages key pairs by storing your public key in the `authorized_keys` file of your EC2 instance.
- When you create an EC2 instance, AWS needs your public key to set up access.

</VClickList>

# Using AWS CLI to Import a Key Pair
<VClickList>

- Use AWS CLI to import the public key to create a key pair for EC2 instances.
- This key pair is used to securely connect to your instances.

</VClickList>

```bash
aws ec2 import-key-pair --key-name MyKeyPair --public-key-material fileb://~/.ssh/id_ed25519.pub
```

