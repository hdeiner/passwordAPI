#!/usr/bin/env bash

echo Starting oracle/glassfish:latest in Docker container
#docker pull oracle/glassfish
#sudo -S <<< "password" docker run docker run -ti -p 4848:4848 -p 8080:8080 oracle/glassfish:latest
sudo -S <<< "password" docker run -p 14848:4848 -p 18080:8080 --name glassfish -d oracle/glassfish:latest