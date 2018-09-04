#!/usr/bin/env bash

echo Starting microsoft/mssql-server-linux:latest in Docker container
sudo -S <<< "password" sudo docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Strong!Passw0rd' \
   -p 1433:1433 --name sqlsvrtest \
   -d microsoft/mssql-server-linux:latest
