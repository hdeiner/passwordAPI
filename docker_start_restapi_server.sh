#!/usr/bin/env bash

sudo docker run -it -p 8080:8080 -v $(pwd)/target/passwordAPI.war:/usr/local/tomcat/webapps/passwordAPI.war --name passwordAPI -d tomcat:9.0.8-jre8