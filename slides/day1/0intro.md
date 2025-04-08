
# What is DevOps?

<VClickList>

- Dev + Ops = Delivery + Infrastructure
- Managing **nodes** and deploying **artifacts**
- Automation, monitoring, scaling
- DevOps is not a tool—it’s a **process**
- Collaboration between developers and operators
- CI/CD pipelines
- Infrastructure as Code

</VClickList>

---
layout: center
---

# Keeping the application online

---

# The Application
<VClickList>

- We’re deploying **RegretBoard**, a Spring Boot app
- Simplest real-life example I could think of
- Has a database, because of course it does

</VClickList>

---

## Application Tour 
<VClickList>

- Controller
- Repository
- Entity structure

</VClickList>

---

## Controller
```java
@RestController
@RequestMapping("/regrets")
public class RegretController {

    private final RegretRepository regretRepository;

    public RegretController(RegretRepository regretRepository) {
        this.regretRepository = regretRepository;
    }

    @PostMapping
    public Regret create(@RequestBody Regret regret) {
        return regretRepository.save(regret);
    }

    @GetMapping
    public List<Regret> all() {
        return regretRepository.findAll();
    }

// ...
}
```
---
---

## Repository

```java
@Repository
public interface RegretRepository extends JpaRepository<Regret, Long> {
    List<Regret> findBySeverity(String severity);
}
```
---

## Entity
```java
@Entity
public class Regret {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;
    private String severity;
    private String responsibleParty;
    private LocalDateTime timestamp = LocalDateTime.now();

    // Getters and setters...
}
```

---

# Building the Application
<VClickList>

- Use Maven to build the Spring Boot application.
- The build process compiles the code and packages it into a JAR file.

</VClickList>

```bash
mvn clean package
```

---

# The Artifact
<VClickList>

- The resulting JAR file is the artifact needed to run the application on a host.
- This JAR file contains all the compiled classes and dependencies.

</VClickList>

```bash
java -jar target/app.jar
```

---
layout: center
---

## Live Demo
- Let's see how it works
- https://github.com/joaoanes/regretboard/
