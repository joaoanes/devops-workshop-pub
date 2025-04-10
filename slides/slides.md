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
src: ./day1/0intro.md 
---

---
src: ./day1/1internet.md
---

---
src: ./day1/2hosting.md
---

---
src: ./day1/3ssh.md
---

---
src: ./day1/4exercisessh.md
---

---
src: ./day1/5terraform.md
---

---
layout: center
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
layout: center
---

# Next: Bring Infra and App Together
<VClickList>

- Use Terraform to provision
- Use Docker to deploy
- Tie into CI/CD for automation

</VClickList>

---
src: ./day2/0intro.md
---

---
src: ./day2/1containers.md
---

---
src: ./day2/2exercisecontainer.md
---

---
src: ./day2/3compose.md
---

---
src: ./day2/4ci.md
---

---
src: ./day2/5dns.md
---

---
transition: view-transition
mdc: true
---

# Final thoughts {.inline-block.view-transition-fin}

### What you’ve learned:
<VClickList>

- Cloud ☁️
- Terraform 🛠️
- Docker 🐳
- CI/CD 🔁
- Networking 🌐
- More knowledge than most of the people I interview!

</VClickList>

---
transition: view-transition
mdc: true
---

# Final thoughts {.inline-block.view-transition-fin}
<VClickList>

- **DevOps is leverage.** Full stack developers who understand it can ship, run, and maintain their work without waiting on someone else.

- **Config via env vars** means ops can tweak behavior without touching code. Clean separation. Zero surprises.

- **Infra as code, containers, CI/CD**—these aren’t buzzwords. They’re how you keep things fast, portable, and resilient.

- **Shared tools = shared language.** Knowing the stack end-to-end makes collaboration smoother and less error-prone.

- **It’s where things are headed.** Devs who ignore this stuff get left behind.

</VClickList>

---
layout: center
transition: view-transition
mdc: true
---

# Topics Not Covered {.inline-block.view-transition-title}

Here are some topics to further explore on your DevOps journey:
<VClickList>

- **Physical separation of concerns**:
  *Your app server should NOT live on the same host as your database server.*

- **Databases, in general**
  *Your data is your life. Backups, scaling horizontally AND vertically, caching, replication, query monitoring/logging.*
  
- **Advanced container orchestration**:
  *Kubernetes, Docker Swarm, and other orchestration platforms.*

- **Infrastructure Monitoring & Observability**:
  *Solutions such as Prometheus, Grafana, ELK/EFK stacks, and tracing tools like Jaeger.*

</VClickList>

---
layout: center
transition: view-transition
mdc: true
---

# Topics Not Covered {.inline-block.view-transition-title}
<VClickList>

- **Configuration management**: 
  *Automation tools such as Ansible, Chef, or Puppet for post-deployment system configuration.*

- **Advanced CI/CD patterns**:
  *Blue-green deployments, canary releases, automated testing, security scanning, and rollback strategies.*

- **DevSecOps**:
  *Integrating security practices throughout the CI/CD pipeline and container image hardening.*

</VClickList>

---
layout: center
transition: view-transition
mdc: true
---

# Topics Not Covered {.inline-block.view-transition-title}
<VClickList>

- **GitOps and infrastructure testing**:
  *Using Git as the source of truth for your infrastructure and automated testing for IaC.*

- **Cloud cost optimization and scaling**:
  *Techniques for monitoring and optimizing cloud spending and automating scaling operations.*

</VClickList>

---
transition: slide-up
---

# Topics Not Covered {.inline-block.view-transition-title}
<VClickList>

- **Serverless and hybrid architectures**:
  *Exploring serverless computing (e.g., AWS Lambda, Azure Functions) and hybrid cloud models.*

- **Advanced networking and security**:
  *Deep dives into container networking, network policies, and other advanced security configurations.*

</VClickList>

---
layout: center
transition: slide-up
class: text-center
---

# Thank you!
### Q&A?

--
#### joaoanes@mindera.com
#### hi@joaoanes.website