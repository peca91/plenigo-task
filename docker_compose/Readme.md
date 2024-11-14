# Infrastructure Setup with Docker Compose

This setup creates essential infrastructure components and serves as a replacement for the "infra" role. After provisioning, you can further configure the environment using existing Ansible scripts. 

## Key Features

### Environment Variables
To ensure sensitive information is protected, replace `${POSTGRES_PASSWORD}` with your actual PostgreSQL password or define it in a `.env` file. This approach prevents hardcoding sensitive data within the configuration.

### Custom Network
While Docker Compose automatically creates a network, we define a custom network here (`custom_bridge_network`) to align with the `netbridge` network specified in your Ansible playbooks. This consistency helps maintain smooth network integration across containers.

### Service Commands
Each container includes an installation command that configures necessary packages and keeps the container active with `sleep infinity`. This setup is ideal for scenarios where continuous uptime is needed for each service.

### Ports and Privileged Mode
Specific ports are exposed to allow access to services, and `privileged: true` is used to mirror the settings in Ansible configurations where elevated privileges are required.

---

## Example: Setting Up Grafana with Docker Compose

Below is an example Docker Compose configuration to run Grafana, showcasing how configuration files and environment variables can be managed:

```yaml
services:
  grafana:
    image: grafana/grafana:latest
    volumes:
      - ./configs/grafana.ini:/etc/grafana/grafana.ini
    ports:
      - "3000:3000"  # Expose Grafana on port 3000
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=secret_password  # Set admin password
    networks:
      - custom_bridge_network
```  
In this example:

The Grafana configuration (grafana.ini) is loaded from ./configs/grafana.ini and mounted at /etc/grafana/grafana.ini within the container.
The Grafana service is accessible on port 3000.
An environment variable (GF_SECURITY_ADMIN_PASSWORD) is set directly, though for secure deployments, consider managing secrets through .env files or secret management tools.
By following these configurations, you can quickly deploy and provision your infrastructure using Docker Compose and Ansible.
