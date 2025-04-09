---
layout: center
---

# Exercise: Create Your Own EC2 Instance

---

# Requirements for Creating an EC2 Instance

<VClickList>

- **Access Keys**: Ensure you have a key pair for SSH access.
- **Operating System (AMI)**: Choose an Amazon Machine Image (AMI) for the OS.
- **Security Groups**: Set up security groups to control access, allowing SSH on port 22.

</VClickList>

---

## Step 1: Finding the AMI

- First, find the latest Ubuntu AMI using AWS CLI:
````md magic-move
```bash
aws ec2 describe-images \
--owners 099720109477 \
--filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*" \
--query 'Images[*].[ImageId,CreationDate]' \
--output text | sort -k2 -r | head -n1
```
```bash
aws ec2 describe-images \
--owners 099720109477 \
--filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*" \
--query 'Images[*].[ImageId,CreationDate]' \
--output text | sort -k2 -r | head -n1

ami-0520e200eb4f308f2   2025-04-03T06:01:59.000Z
```
````

---

## Security Groups and SSH Access
<VClickList>

- Security groups act as a virtual firewall for your EC2 instances to control inbound and outbound traffic.
- To allow SSH access, create a security group with a rule to permit inbound traffic on port 22.

</VClickList>

---
layout: center
---

## Step 2: Create a security group

<v-click>
````md magic-move

```bash
aws ec2 create-security-group --group-name MySecurityGroup --description "Security group for SSH access"
```

```bash{all|4}
aws ec2 create-security-group --group-name MySecurityGroup --description "Security group for SSH access"

{
    "GroupId": "sg-0e006d0aecc9aece8",
    "SecurityGroupArn": "arn:aws:ec2:eu-west-1:305518020756:security-group/sg-0e006d0aecc9aece8"
}
```
````
</v-click>

---
layout: center
---

## Then allow port 22 to be listened to

<v-click>

````md magic-move
```bash
aws ec2 authorize-security-group-ingress --group-name MySecurityGroup --protocol tcp --port 22 --cidr 0.0.0.0/0
```

```bash
aws ec2 authorize-security-group-ingress --group-name MySecurityGroup --protocol tcp --port 22 --cidr 0.0.0.0/0

{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-03574b87b51844f25",
            "GroupId": "sg-0e006d0aecc9aece8",
            "GroupOwnerId": "305518020756",
            "IsEgress": false,
            "IpProtocol": "tcp",
            "FromPort": 22,
            "ToPort": 22,
            "CidrIpv4": "0.0.0.0/0",
            "SecurityGroupRuleArn": "arn:aws:ec2:eu-west-1:305518020756:security-group-rule/sgr-03574b87b51844f25"
        }
    ]
}
```
````

</v-click>

---
layout: center
---

## Step 3: Create the EC2 Instance

- Use the security group to launch an EC2 instance:  
````md magic-move
```bash {all|2|2,5|2,5,6}
aws ec2 run-instances \
--image-id ami-0520e200eb4f308f2 \ 
--count 1 \
--instance-type t2.micro \
--key-name MyKeyPair \
--security-group-ids sg-0e006d0aecc9aece8 
```

```bash
aws ec2 run-instances \
--image-id ami-0520e200eb4f308f2 \ 
--count 1 \
--instance-type t2.micro \
--key-name MyKeyPair \
--security-group-ids sg-0e006d0aecc9aece8 
```


```bash {15}
aws ec2 run-instances \
--image-id ami-0520e200eb4f308f2 \ 
--count 1 \
--instance-type t2.micro \
--key-name MyKeyPair \
--security-group-ids sg-0e006d0aecc9aece8 

{
    "ReservationId": "r-08db7b09142f58607",
    "OwnerId": "305518020756",
    "Groups": [],
    "Instances": [
        {
            "NetworkInterfaces": [],
            "InstanceId": "i-00990752c68df49dc",
            "ImageId": "ami-0520e200eb4f308f2",
            "State": {
                "Code": 0,
                "Name": "pending"
            },
            "PrivateDnsName": "ip-172-31-39-137.eu-west-1.compute.internal",
            "PublicDnsName": "",
            "StateTransitionReason": "",
            "KeyName": "MyKeyPair",
            "AmiLaunchIndex": 0,
            "ProductCodes": [],
            "InstanceType": "t2.micro"
        }
    ]
}
```

````

---
layout: center
---

## Step 4: Find the Public IP
- Use the instance ID to find the public IP of your EC2 instance:
````md magic-move
```bash
aws ec2 describe-instances \
    --instance-ids i-00990752c68df49dc \
    --query 'Reservations[*].Instances[*].PublicIpAddress' \ 
    --output text
```

```bash{6}
aws ec2 describe-instances \
    --instance-ids i-00990752c68df49dc \
    --query 'Reservations[*].Instances[*].PublicIpAddress' \ 
    --output text

54.72.150.114
```
````

---

## Step 5: Connect via SSH
<VClickList>

- Use SSH to connect to your EC2 instance.

-  
  ```bash
  ssh -i ~/.ssh/id_ed25519 ubuntu@54.72.150.114
  ```

- This distro uses "ubuntu" as the user, this can change.

</VClickList>

---

## Step 6: Verify SSH Key


- Check the `authorized_keys` file on the instance.
````md magic-move
```bash
cat ~/.ssh/authorized_keys
```
```bash{3}
cat ~/.ssh/authorized_keys

ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINsEXMz4OkpiHYAodGyLO//PT62rHjLm95tpX/8iGaFS MyKeyPair
```
````

