#!/usr/bin/env bash

echo Create and test the passwordAPI deployable war artifact
mvn clean test package

echo Kill the current Docker passwordAPI container
./docker/docker_reset_restapi_server.sh
echo Create a fresh Docker passwordAPI container
./docker/docker_start_restapi_server.sh

echo Pause 2 seconds to allow Tomcat to start up
sleep 2

echo Run the integration tests
mvn test -Dtest=CucumberTest_Rest_WebService