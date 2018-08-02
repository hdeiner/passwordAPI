#!/usr/bin/env bash

echo Running apt-get update -y...
sudo apt-get update -y

echo Installing Tomcat...
sudo apt-get install -y tomcat8

echo Pave the way for our war file to be installed
sudo touch /var/lib/tomcat8/webapps/passwordAPI.war
sudo chmod 777 /var/lib/tomcat8/webapps/passwordAPI.war