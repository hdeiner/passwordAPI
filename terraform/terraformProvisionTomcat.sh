#!/usr/bin/env bash

echo Running apt-get update -y...
sudo apt-get update -y

echo Installing Tomcat...
sudo apt-get install -y tomcat8

echo Prepare for deployment of the passwordAPI Rest Webservice
sudo touch /var/lib/tomcat8/webapps/passwordAPI.war
sudo chmod 777 /var/lib/tomcat8/webapps/passwordAPI.war