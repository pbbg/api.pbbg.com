#!/bin/sh
set -e
# This script installs Portainer as a standalone host in a DigitalOcean droplet
# Because it is standalone this creates the manager only (no agent)

GREEN='\033[1;32m'
NC='\033[0m' # No Color

echo "${GREEN}==== install-portainer.sh script ====${NC}"

echo "${GREEN}Using bcrypt runtime docker container to create an encrypted password...${NC}"
# Initial password is bcrypt encrypted password 'admin' using one-time run of httpd:2.4-alpine container
password=docker run --rm httpd:2.4-alpine htpasswd -nbB admin "admin" | cut -d ":" -f 2

echo "${GREEN}Creating docker volume for Portainer data...${NC}"
docker volume create portainer_data

echo "${GREEN}Starting Portainer.io standalone container, listening on port 9000...${NC}"
docker run -d -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce --admin-password=$password
echo "${GREEN}Successfully started Portainer.${NC}"
echo "${GREEN}Portainer UI is available on {static_ip_address}:9000${NC}"
