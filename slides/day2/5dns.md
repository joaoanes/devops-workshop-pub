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

- HTTPS encrypts data between the server and clients, enhancing security.
- Certbot is a free tool to obtain and renew SSL/TLS certificates from Let's Encrypt.
- To use Certbot:
  - Install Certbot on your server.
  - Run Certbot to automatically configure your web server and obtain a certificate.
  - Certbot can also set up automatic renewal for your certificates.
- This process ensures your website is secure and trusted by browsers.
