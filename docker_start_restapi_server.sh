#!/usr/bin/env bash

sudo -S <<< "password"sudo docker build --tag=restapi .
sudo -S <<< "password"sudo docker run -p 8080:8080 -it restapi:latest --name PasswordAPI