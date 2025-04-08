# Docker Exercise: Create a Dockerfile for Regretboard

<VClickList>

- **Objective**: Create a Dockerfile to containerize the Regretboard application.
- **Steps**:
  1. Start with a base image suitable for your application (e.g., `openjdk:17` for a Java app).
  2. Copy your application JAR file into the image.
  3. Define the command to run your application using `CMD`.

</VClickList>

---

- **Example Dockerfile**:
````md magic-move
```dockerfile {1,3}
# Uses a slim version of OpenJDK 17 as the base image for building the application.

FROM openjdk:17-jdk-slim AS build
WORKDIR /app
COPY . .
RUN ./mvnw package -DskipTests

FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
```
```dockerfile {1,4}
# Sets the working directory inside the container to `/app`

FROM openjdk:17-jdk-slim AS build
WORKDIR /app
COPY . .
RUN ./mvnw package -DskipTests

FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
```
```dockerfile {1,5}
# Copies all files from the current directory to the container's `/app` directory

FROM openjdk:17-jdk-slim AS build
WORKDIR /app
COPY . .
RUN ./mvnw package -DskipTests

FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
```
```dockerfile {1,6}
# Runs the Maven wrapper to package the application, skipping tests for faster build times.

FROM openjdk:17-jdk-slim AS build
WORKDIR /app
COPY . .
RUN ./mvnw package -DskipTests

FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
```
```dockerfile {1,8}
# Uses a slim version of OpenJDK 17 as the base image for running the application.

FROM openjdk:17-jdk-slim AS build
WORKDIR /app
COPY . .
RUN ./mvnw package -DskipTests

FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
```
```dockerfile {1,9}
# Sets the working directory inside the container to `/app`.

FROM openjdk:17-jdk-slim AS build
WORKDIR /app
COPY . .
RUN ./mvnw package -DskipTests

FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
```
```dockerfile {1,10}
# Copies the JAR file from the build stage to the current stage.

FROM openjdk:17-jdk-slim AS build
WORKDIR /app
COPY . .
RUN ./mvnw package -DskipTests

FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
```
```dockerfile {1,11}
# Sets the command to run the application when the container starts.

FROM openjdk:17-jdk-slim AS build
WORKDIR /app
COPY . .
RUN ./mvnw package -DskipTests

FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
```
````

---

# Testing Your Dockerfile
<VClickList>

- **Save the dockerfile in the root directory**

- **Build the Docker Image**:
  ```bash
  docker build -t regretboard .
  ```

- **Run the Docker Container**:
  ```bash
  docker run --publish 8080:8080 regretboard
  ```
  - Use `--publish` to map the container's port to your local machine's port, allowing access to the application.

- **Verify**: Access the application at `http://localhost:8080` to ensure it's running correctly.

</VClickList>

---

# Managing Docker Images
<VClickList>

- **Push and Pull Images**:
  - Push your image to a registry:
    ```bash
    docker push your-repo/regretboard
    ```
  - Pull an image from a registry:
    ```bash
    docker pull your-repo/regretboard
    ```

- **Save and Load Images**:
  - Save an image to a tar file:
    ```bash
    docker save -o regretboard.tar regretboard
    ```
  - Load an image from a tar file:
    ```bash
    docker load -i regretboard.tar
    ```

- These commands allow you to share images and move them between environments easily.

</VClickList>
