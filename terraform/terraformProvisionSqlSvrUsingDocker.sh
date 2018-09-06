#!/usr/bin/env bash

# First, add the GPG key for the official Docker repository to the system:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add the Docker repository to APT sources:
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Next, update the package database with the Docker packages from the newly added repo:
sudo apt-get update

# Finally, install Docker:
sudo apt-get install -y docker-ce

# Starting microsoft/mssql-server-linux:latest in Docker container
sudo docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Strong!Passw0rd' \
   -p 1433:1433 --name sqlsvrtest \
   -d microsoft/mssql-server-linux:latest