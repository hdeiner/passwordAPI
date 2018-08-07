#!/usr/bin/env bash

# build and test locally
mvn clean verify

# create the test infrasctucture
# note: as part of the provisioning of the tomcat server, we deploy the war file
terraform apply -auto-approve

# test on the infrastructure we just put together
echo hosturl=http://`terraform output tomcat_dns`:8080 > rest_webservice.properties
mvn verify

# destroy the test infrastructure
terraform destroy -auto-approve
echo hosturl=http://localhost:8080 > rest_webservice.properties