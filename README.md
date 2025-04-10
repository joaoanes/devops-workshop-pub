# 💻 Regretboard DevOps Workshop

🚀 **Live Deployment:**  
[**mindera-school-devops-workshop.netlify.app**](https://mindera-school-devops-workshop.netlify.app/)

---

## 📁 Project Structure

```
.
├── regretboard/
│   └── Git submodule containing the Regretboard repo
│
├── slides/
│   └── Sli.dev slide deck  
│       Builds to ./slides/dist with `npm run build`
│
└── support/
    ├── keys/
    │   └── `devops-workshop` AMI deployer key
    │
    └── tf/ (Terraform)
        ├── ec2/
        │   └── Script to create an EC2 instance
        │
        ├── iam-gen/
        │   └── Script to create up to 15 EC2-locked IAMs
        │
        └── trail/
            └── Script to toggle a CloudTrail trail
```

---

## 🔐 Git-Crypt

We like to live dangerously, so we push secrets to GitHub.  
`git-crypt` is set up and configured for the following key:

**João Anes** (Master offline ecc)  
Fingerprint: `B6F7 CCC6 D36E 5B73 C95A 2AF4 85C3 9DCC 32C7 D0E0`  
📧 `hi@joaoanes.website`
