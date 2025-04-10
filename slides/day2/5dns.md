# We have to talk about DNS

- We managed to connect to our server, but using IPs feels wrong and dirty
- How do we actually register a domain name and use it?

---

# Registering a Domain

- Purchase a domain from a registrar like Namecheap or GoDaddy.
- Domain costs vary: .com and .org domains are generally more expensive, often ranging from $10 to $50 per year.
- Vanity domains like .xyz can be cheaper, sometimes as low as $1 to $10 per year.
- Once registered, you can manage your domain settings through the registrar's dashboard.


---

# Configuring DNS Records

- An A record maps a domain to an IP address, allowing users to access your server using a domain name.
- Point the A record to your server's IP address.
- Other record types include:
  - **CNAME**: Alias one domain to another.
  - **MX**: Direct email to a mail server.
  - **TXT**: Provide text information to sources outside your domain.
  - **SRV**: Specify a port for specific services.

---

# DNS Propagation

- Changes to DNS records can take time to propagate.
- Propagation is the process of updating DNS servers worldwide.
- It can take from a few minutes to 48 hours.
- Good registrars often update DNS records quickly, sometimes in seconds, due to efficient infrastructure and direct connections to DNS servers.

---

# Enabling HTTPS with Certbot

- Now that we have a domain, we can get a certificate for that domain to enable HTTPS.
- Certbot is a free tool to obtain and renew SSL/TLS certificates from Let's Encrypt.
- To use Certbot:
  - Install Certbot on your server.
  - Run Certbot to automatically configure your web server and obtain a certificate.
  - Certbot can also set up automatic renewal for your certificates.
- This process ensures your website is secure and trusted by browsers.

---

# Using Nginx and Caddy with Certbot

- **Nginx**:
  - Install Certbot and the Nginx plugin.
  - Use Certbot to obtain and install certificates for Nginx.
  - Configure Nginx to use the certificates for HTTPS.

- **Caddy**:
  - Caddy automatically manages HTTPS certificates.
  - Use the Caddyfile to configure domain and reverse proxy settings.
  - Caddy handles certificate renewal automatically.

---

### Update `docker-compose.yml` to use Caddy

1. **Edit the `docker-compose.yml` file** to include a Caddy service for automatic certificate management. Here's how you can modify it:

```yaml
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
      - pgdata:/var/lib/postgresql/data
      - ./docker/init.sql:/docker-entrypoint-initdb.d/init.sql:ro

  app:
    image: regretboard:latest
    build: .
    ports:
      - "8080:8080"
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://db:5432/regrets
      SPRING_DATASOURCE_USERNAME: regretadmin
      SPRING_DATASOURCE_PASSWORD: neveragain
    depends_on:
      - db

  caddy:
    image: caddy:latest
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile
    environment:
      - CADDY_EMAIL=your-email@example.com

volumes:
  pgdata:
```

---

2. **Create a `Caddyfile`** in the same directory as `docker-compose.yml` with the following content:

```
yourdomain.com {
  reverse_proxy app:8080
  tls {
    email your-email@example.com
  }
}
```