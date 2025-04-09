# Can we move the image to our server?

<VClickList>

- We've got a docker image of our app, we don't need to install java to run the jar anymore.

- But we still have the same issue of having to setup the database...

- If only there was a way to write a file that says "so we need to deploy our app, and a database server, and configure the app to use the database server"...

</VClickList>

---

# Docker Compose: The Solution

- **Problem Solved:** Docker Compose allows you to define and run multi-container Docker applications. It simplifies the process of setting up and managing containers for your app and its dependencies, like databases, in a single file.

---


## The building block of docker-compose: services

- **What is a Service?**
  - A service in Docker Compose is a definition of a containerized application that you want to run. Each service runs one image and can define the ports, environment variables, and dependencies it needs.
  - **Example:** A web application service might use the `nginx` image and expose port 80.

- **Service Configuration:**
  - Services are defined in the `docker-compose.yml` file under the `services` section. Each service can specify its own configuration, such as the image to use, ports to expose, and environment variables.
  - **Example:**
    ```yaml
    services:
      web:
        image: nginx:latest
        ports:
          - "80:80"
    ```

---

## The building block of docker-compose: services

- **Inter-Service Communication:**
  - Docker Compose sets up a network for all services defined in the file, allowing them to communicate with each other using their service names as hostnames. This simplifies the process of linking services together.
  - **Example:** The `web` service can connect to a `db` service using the hostname `db`.

- **Scaling Services:**
  - You can scale services to run multiple instances of a container using the `docker-compose up --scale` command, which is useful for load balancing and high availability.
  - **Example:** To scale the `web` service to 3 instances, use:
    ```bash
    docker-compose up --scale web=3
    ```

---

- **Sample Configuration and Analysis:**

````md magic-move
```yaml {all}
services:
  app:
    image: myapp:latest
    ports:
      - "8080:8080"
    depends_on:
      - db
  db:
    image: postgres:latest
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
      POSTGRES_DB: mydatabase
```
```yaml {1,3}
# Defines the services to be run. Here, `app` and `db` are two services.

services:
  app:
    image: myapp:latest
    ports:
      - "8080:8080"
    depends_on:
      - db
  db:
    image: postgres:latest
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
      POSTGRES_DB: mydatabase
```
```yaml {1,2,5}
# Uses the `myapp` image and maps port 8080. It depends on the `db` service
# and maps the 8080 port on the container to port 80 on the host.

services:
  app:
    image: myapp:latest
    ports:
      - "80:8080"
    depends_on:
      - db
  db:
    image: postgres:latest
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
      POSTGRES_DB: mydatabase
```
```yaml {1,10-15}
# Uses the `postgres` image and sets environment variables for database configuration.

services:
  app:
    image: myapp:latest
    ports:
      - "8080:8080"
    depends_on:
      - db
  db:
    image: postgres:latest
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
      POSTGRES_DB: mydatabase
```
````

---

# Why of compose

- **Comprehensive Configuration:** In one simple file, Docker Compose allows you to describe your entire service architecture, including all necessary components and their configurations.
- **Cross-Platform Consistency:** This configuration can be used both on your local machine and on servers, ensuring consistency across development and production environments.
- **Problem Solving:** Docker Compose addresses several challenges:
  - **Dependency Management:** Automatically handles the startup order of services, ensuring that dependencies like databases are ready before the application starts.
  - **Network Configuration:** Simplifies networking by creating a default network for services to communicate with each other, reducing manual configuration.
  - **Service Orchestration:** Allows you to define and manage multiple services in a single file, making it easy to scale and maintain complex applications.

---

# Running Your Docker Compose File

## Useful Docker Compose Commands

- **Start Services:** Use `docker-compose up` to start all services defined in the `docker-compose.yml` file. Add `-d` to run in detached mode.
  ```bash
  docker-compose up -d
  ```

- **Stop Services:** Use `docker-compose down` to stop and remove all running containers defined in the file.
  ```bash
  docker-compose down
  ```

- **View Logs:** Use `docker-compose logs` to view the logs of all services. Add `-f` to follow the logs in real-time.
  ```bash
  docker-compose logs -f
  ```

- **Check Status:** Use `docker-compose ps` to list the status of all services.
  ```bash
  docker-compose ps
  ```

---
layout: center
---
# Let's create a docker-compose.yml file for our app!

---
transition: view-transition
mdc: true
---


## Step 1: Define the App Service {.inline-block.view-transition-fin}

- Use the `regretboard:latest` image.
- Map port 8080 in the container to port 80 on the host.

```yaml
services:
  app:
    image: regretboard:latest
    ports:
      - "80:8080"
```

---
transition: view-transition
mdc: true
---


## Step 2: Define the Database Service {.inline-block.view-transition-fin}


- Use the `postgres:latest` image.
- Set environment variables for `POSTGRES_USER`, `POSTGRES_PASSWORD`, and `POSTGRES_DB`.
- We can check in the code that the app has default username/passwords it expects. Let's set them in the database container
````md magic-move
```yaml
  db:
    image: postgres:latest
    environment:
      POSTGRES_USER: regretadmin
      POSTGRES_PASSWORD: neveragain
      POSTGRES_DB: regrets
    volumes:
      - pgdata:/var/lib/regretsboard/data
```

```yaml {1-3,10-11}
  # We're setting a custom volume here: pgdata
  # This way the container will actually save all data
  # in a custom "disk" docker-compose will manage for us
  db:
    image: postgres:latest
    environment:
      POSTGRES_USER: regretadmin
      POSTGRES_PASSWORD: neveragain
      POSTGRES_DB: regrets
    volumes:
      - pgdata:/var/lib/regretsboard/data
```
````

---
transition: view-transition
mdc: true
---


## Step 3: Write the Database Initialization Script {.inline-block.view-transition-fin}

- Create an `init.sql` script to set up the database schema and initial data.

```sql
CREATE TABLE regret (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  severity TEXT NOT NULL,
  responsible_party TEXT,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO regret (title, severity, responsible_party)
VALUES
    ('Trusted a Stack Overflow snippet', 'severe', 'student-7'),
    ('Ran terraform apply without reading it', 'moderate', 'student-3');
```

---
transition: view-transition
mdc: true
---


## Step 4: Add the Initialization Script to Volumes {.inline-block.view-transition-fin}



- Ensure the script is mounted at `/docker-entrypoint-initdb.d/`.

```yaml {7-8}
  db:
    image: postgres:latest
    environment:
      POSTGRES_USER: regretadmin
      POSTGRES_PASSWORD: neveragain
      POSTGRES_DB: regrets
    volumes:
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
      - pgdata:/var/lib/regretsboard/data
```

- This moves the file ./init.sql into the directory postgres checks and executes before starting.

---
transition: view-transition
mdc: true
---


## Step 5: Set environmental variables to hook everything together {.inline-block.view-transition-fin}

````md magic-move
```yaml {all}
services:
  app:
    image: regretboard:latest
    ports:
      - "80:8080"
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://db:5432/regrets
      SPRING_DATASOURCE_USERNAME: regretadmin
      SPRING_DATASOURCE_PASSWORD: neveragain
    depends_on:
      - db
  db:
    image: postgres:latest
    environment:
      POSTGRES_USER: regretadmin
      POSTGRES_PASSWORD: neveragain
      POSTGRES_DB: regrets
    volumes:
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
      - pgdata:/var/lib/regretsboard/data
```
```yaml {1-2,10-12,18-20}
# Spring allows configuration via environment variables, which is standard and encouraged.
# This approach makes applications more flexible and easier to configure across different environments.

services:
  app:
    image: regretboard:latest
    ports:
      - "80:8080"
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://db:5432/regrets
      SPRING_DATASOURCE_USERNAME: regretadmin
      SPRING_DATASOURCE_PASSWORD: neveragain
    depends_on:
      - db
  db:
    image: postgres:latest
    environment:
      POSTGRES_USER: regretadmin
      POSTGRES_PASSWORD: neveragain
      POSTGRES_DB: regrets
    volumes:
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
      - pgdata:/var/lib/regretsboard/data
```
```yaml {1-2,10}
# The SPRING_DATASOURCE_URL uses 'db:5432' as a valid URL because Docker Compose sets up a network
# where services can communicate using their service names as hostnames.

services:
  app:
    image: regretboard:latest
    ports:
      - "80:8080"
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://db:5432/regrets
      SPRING_DATASOURCE_USERNAME: regretadmin
      SPRING_DATASOURCE_PASSWORD: neveragain
    depends_on:
      - db
  db:
    image: postgres:latest
    environment:
      POSTGRES_USER: regretadmin
      POSTGRES_PASSWORD: neveragain
      POSTGRES_DB: regrets
    volumes:
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
      - pgdata:/var/lib/regretsboard/data
```
````

---

# Here's how it should look like put together

<div class="max-h-80 overflow-auto border rounded p-4">

```yaml {monaco}
  services:
  db:
    image: postgres:15
    environment:
      POSTGRES_DB: regrets
      POSTGRES_USER: regretadmin
      POSTGRES_PASSWORD: neveragain
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/regretsboard/data
      - ./docker/init.sql:/docker-entrypoint-initdb.d/init.sql:ro

  app:
    image: regretboard:latest
    build: .
    ports:
      - "80:8080"
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://db:5432/regrets
      SPRING_DATASOURCE_USERNAME: regretadmin
      SPRING_DATASOURCE_PASSWORD: neveragain
    depends_on:
      - db

volumes:
  pgdata:
```

</div>


---

# Exercise: Run Your Docker Compose File

## Objective

- Start the services defined in your `docker-compose.yml` file and verify that the application is running correctly.

---
transition: view-transition
mdc: true
---



## Instructions

1. **Start the Services:** {.inline-block.view-transition-fin}
   - Run the following command to start all services (in detached mode):
````md magic-move
```bash
docker-compose up -d
```

```bash
docker-compose up -d
[+] Running 2/0
 ✔ Container regret-board-db-1   Started
 ✔ Container regret-board-app-1  Started

```
````

---
transition: view-transition
mdc: true
---


2. **Check it's working** {.inline-block.view-transition-fin}

   - Open a web browser and navigate to `http://localhost:80/regrets`.
   - You should see the application interface, confirming that the app is running and connected to the database.

---
transition: view-transition
mdc: true
---


3. **Check Logs:** {.inline-block.view-transition-fin}
   - Use the following command to view the logs and ensure there are no errors (or check if there are any):
     ```bash
     docker-compose logs -f
     ```

---
transition: view-transition
mdc: true
---


4. **Check stats:** {.inline-block.view-transition-fin}
   - Let's have a look at the container statistics:

````md magic-move
```bash
docker-compose stats
```

```bash
docker-compose stats

CONTAINER ID   NAME                CPU %     MEM USAGE / LIMIT     MEM %     NET I/O           BLOCK I/O       PIDS
ffbc446bedf4   egret-board-db-1    13.05%    16.12MiB / 1.902GiB   0.83%     18.3kB / 15.3kB   324kB / 253kB   16
982d4873ae45   egret-board-app-1   102.26%   181.8MiB / 1.902GiB   9.33%     16.6kB / 17.1kB   8MB / 41kB      43
```
````

---
transition: view-transition
mdc: true
---


5. **Stop the Services:** {.inline-block.view-transition-fin}
   - Once verified, stop the services:

````md magic-move
```bash
docker-compose down
```

```bash
docker-compose down
[+] Running 3/2
 ✔ Container regret-board-app-1  Removed
 ✔ Container regret-board-db-1   Removed
 ✔ Network regret-board_default  Removed

```
````
- This frees up resources. Since our database is saved on your disk, it'll persist data - otherwise it'd be removed, and you'd start from scratch.

---

