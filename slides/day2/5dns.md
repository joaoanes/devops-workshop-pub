# We have to talk about DNS

<VClickList>

- We managed to connect to our server, but using IPs feels wrong and dirty
- How do we actually register a domain name and use it?

</VClickList>

---

# Registering a Domain

<VClickList>

- Purchase a domain from a registrar like Namecheap or GoDaddy.
- Domain costs vary: .com and .org domains are generally more expensive, often ranging from $10 to $50 per year.
- Vanity domains like .xyz can be cheaper, sometimes as low as $1 to $10 per year.
- Once registered, you can manage your domain settings through the registrar's dashboard.

</VClickList>

---

# Configuring DNS Records

<VClickList>

- An A record maps a domain to an IP address, allowing users to access your server using a domain name.
- Point the A record to your server's IP address.
- Other record types include:
  - **CNAME**: Alias one domain to another.
  - **MX**: Direct email to a mail server.
  - **TXT**: Provide text information to sources outside your domain.
  - **SRV**: Specify a port for specific services.

</VClickList>

---
layout: center
---

# Live demo! Let's configure a domain

---

# DNS Propagation

<VClickList>

- Changes to DNS records can take time to propagate.
- Propagation is the process of updating DNS servers worldwide.
- It can take from a few minutes to 48 hours.
- Good registrars often update DNS records quickly, sometimes in seconds, due to efficient infrastructure and direct connections to DNS servers.

</VClickList>

---

# Enabling HTTPS with Certbot

<VClickList>

- Now that we have a domain, we can get a certificate for that domain to enable HTTPS.
- Certbot is a free tool to obtain and renew SSL/TLS certificates from Let's Encrypt.
- To use Certbot:
  - Install Certbot on your server.
  - Run Certbot to automatically configure your web server and obtain a certificate.
  - Certbot can also set up automatic renewal for your certificates.
- This process ensures your website is secure and trusted by browsers.

</VClickList>


---

# Using Nginx and Caddy with Certbot

<VClickList>

- **Nginx**:
  - Install Certbot and the Nginx plugin.
  - Use Certbot to obtain and install certificates for Nginx.
  - Configure Nginx to use the certificates for HTTPS.

- **Caddy**:
  - Caddy automatically manages HTTPS certificates.
  - Use the Caddyfile to configure domain and reverse proxy settings.
  - Caddy handles certificate renewal automatically.
</VClickList>

---

# Exercise: set `docker-compose.yml` to use Caddy

<VClickList>

- We need to add a bunch of things
  - The caddy webserver service, that will take the requests for us
    - It also handles HTTPS traffic
  - Two docker networks to separate caddy and our app/database
  - 2 new volumes for caddy to store stuff in
  - A file to configure Caddy
  
</VClickList>

---

<div class="max-h-120 overflow-auto border rounded p-4">

````md magic-move
```yaml {1,13-14,25-43,47-55}
# This is A LOT. Let's go one by one

services:
  db:
    image: postgres:15
    environment:
      POSTGRES_DB: regrets
      POSTGRES_USER: regretadmin
      POSTGRES_PASSWORD: neveragain
    volumes:
      - pgdata:/var/lib/postgresql/data
      - ./docker/init.sql:/docker-entrypoint-initdb.d/init.sql:ro
    networks:
      - app_network

  app:
    image: regretboard:latest
    build: .
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://db:5432/regrets
      SPRING_DATASOURCE_USERNAME: regretadmin
      SPRING_DATASOURCE_PASSWORD: neveragain
    depends_on:
      - db
    networks:
      - app_network
      - caddy_network

  caddy:
    image: caddy:latest
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./docker/Caddyfile:/etc/caddy/Caddyfile
      - caddy_data:/data
      - caddy_config:/config
    environment:
      - CADDY_EMAIL=joao.anes@gmail.com
    depends_on:
      - app
    networks:
      - caddy_network

volumes:
  pgdata:
  caddy_data:
  caddy_config:

networks:
  app_network:
    driver: bridge
  caddy_network:
    driver: bridge
```

```yaml {1,13-14,25-26}
# We add a new network that links together db and app

services:
  db:
    image: postgres:15
    environment:
      POSTGRES_DB: regrets
      POSTGRES_USER: regretadmin
      POSTGRES_PASSWORD: neveragain
    volumes:
      - pgdata:/var/lib/postgresql/data
      - ./docker/init.sql:/docker-entrypoint-initdb.d/init.sql:ro
    networks:
      - app_network

  app:
    image: regretboard:latest
    build: .
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://db:5432/regrets
      SPRING_DATASOURCE_USERNAME: regretadmin
      SPRING_DATASOURCE_PASSWORD: neveragain
    depends_on:
      - db
    networks:
      - app_network
      - caddy_network

  caddy:
    
volumes:
  
networks:
  
```

```yaml {1,17,33}
# We also add a network that links the app and caddy (the webserver) together

services:
  db:

  app:
    image: regretboard:latest
    build: .
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://db:5432/regrets
      SPRING_DATASOURCE_USERNAME: regretadmin
      SPRING_DATASOURCE_PASSWORD: neveragain
    depends_on:
      - db
    networks:
      - app_network
      - caddy_network

  caddy:
    image: caddy:latest
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./docker/Caddyfile:/etc/caddy/Caddyfile
      - caddy_data:/data
      - caddy_config:/config
    environment:
      - CADDY_EMAIL=joao.anes@gmail.com
    depends_on:
      - app
    networks:
      - caddy_network

volumes:
  
networks:
  
```
```yaml {1,9-13}
# We also add them here

services:
  db:
  app:
  caddy:
volumes:
  
networks:
  app_network:
    driver: bridge
  caddy_network:
    driver: bridge
```
```yaml {1,15-16,26-27}
# We also add docker volumes to caddy and declare them

services:
  db:

  app:

  caddy:
    image: caddy:latest
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./docker/Caddyfile:/etc/caddy/Caddyfile
      - caddy_data:/data
      - caddy_config:/config
    environment:
      - CADDY_EMAIL=joao.anes@gmail.com
    depends_on:
      - app
    networks:
      - caddy_network

volumes:
  pgdata:
  caddy_data:
  caddy_config:

networks:
  
```
```yaml {1,14}
# We also copy the "caddyfile" from ./docker to the caddy service

services:
  db:

  app:

  caddy:
    image: caddy:latest
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./docker/Caddyfile:/etc/caddy/Caddyfile
      - caddy_data:/data
      - caddy_config:/config
    environment:
      - CADDY_EMAIL=joao.anes@gmail.com
    depends_on:
      - app
    networks:
      - caddy_network

volumes:
  
networks:
  
```
````

</div>

---

# Caddyfile?

- The caddyfile just looks like this:

```
yourdomain.com {
  reverse_proxy app:8080
}
```
<VClickList>

- It's telling caddy "look, when requests come for that domain, send them to app on port 8080". Very simple and effective.
- As a good side effect, caddy will automatically register a certificate for this domain, and enable https!

</VClickList>

---
layout: center
---

# Live demo: Let's give it a try!
```bash 
  docker-compose -f docker-compose.caddy.yml up
```

#### Psst: your server has a hidden .spoilers directory 🤫