## Prerequisites
To use this repository, ensure that the following tools are installed and configured on your local machine:

Ansible: Set up Ansible on your local machine.
Docker Desktop: Install Docker Desktop to enable container management.
Make: Install make to facilitate build commands.
Additionally, create a folder for storing Ansible-related secrets:

```
mkdir -p $HOME/.ansible_local
```
Inside this folder, create a file named p01_pw containing the password for Ansible variables.

## Initial Setup
Install Dependencies: In the directory where you've cloned the repository, run the following command to install Ansible dependencies specified in the requirements file:

```
make
```
## Execution Steps
Provision Infrastructure: Run the following playbook to set up the necessary infrastructure:

```
ansible-playbook playbooks/infra.yaml
```
Deploy Services in Sequence: Execute each of these playbooks in the specified order:

```
ansible-playbook playbooks/web-server.yaml
ansible-playbook playbooks/postgres.yaml
ansible-playbook playbooks/monitoring.yaml
ansible-playbook playbooks/haproxy.yaml
```
Update Local Hosts File: Add the following entries to your local /etc/hosts file:

```
127.0.0.1 www.tornjanski.uk
127.0.0.1 prometheus.tornjanski.uk
127.0.0.1 alertmgr.tornjanski.uk
127.0.0.1 grafana.tornjanski.uk
127.0.0.1 bb.tornjanski.uk
```
# Access the Environment: Test the environment by navigating to:

```
https://www.tornjanski.uk:5443/
```
### Infrastructure Overview

1. Network
A bridge network is used to allow containers to communicate with each other.
Each container has the necessary ports exposed, including ports for Prometheus exporters.
HAProxy forwards ports 5443:5443 and 8080:8080 for access from the local machine.

2. Infrastructure
Docker containers are set up with additional packages required by Ansible.
Each container runs with the command ```sleep infinity``` to keep them continuously running.

3. Security
The following Ansible Galaxy roles are used:
geerlingguy.security and geerlingguy.firewall to set up firewalls and basic security, including Fail2Ban.
These roles are applied across all containers.

4. Web Server
Two web servers are deployed using an Ubuntu image, with a simple HelloWorld application hosted on each.

5. PostgreSQL
The official Postgres 13 container is deployed.
Storage is configured for backups and data.
The database is initialized, and a test database and user are created.
Port 5432 is forwarded and we can access db using localhost:5432 from psql, pg_dump and other tools.
Basic backup script is created and cronjob runs every night to create backup

6. Monitoring
A full monitoring stack is deployed within a single container, suitable for testing (not recommended for production). Storage is configured for data (one for Grafana and other for everything else). Components include:

- Grafana
- Prometheus
- blackbox_exporter
- Alertmanager

# Grafana Setup: A test password is set for Grafana (stored in a variable but unencrypted as it’s a test environment).

# Prometheus Rules: Scraping and alert rules are configured in prometheus.yaml and prometheus_rules.yml.

# Alertmanager: Basic configuration for email alerts (SMTP password is not set).

# blackbox_exporter: Used for link probing as defined in Prometheus rules.

Service files are created for each monitoring component and can be managed with service start.

7. HAProxy
Uses a Debian-based container, as the official image does not support the additional packages required for Ansible.
HAProxy Version: 2.4 is installed, and acme.sh is used for a Cloudflare DNS challenge to create a wildcard certificate. The API token is encrypted in vars/main.yml.
Access Control: ACLs are used to recognize hostnames (with hdr(host)) for each service, routing requests to port 5443 (forwarded to localhost) for access to the environment.
HAProxy Service: The HAProxy service can be started with service start haproxy.