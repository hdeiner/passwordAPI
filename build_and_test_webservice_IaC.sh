#!/usr/bin/env bash

# build and test locally
mvn clean verify

# create the test infrasctucture
# note: as part of the provisioning of the tomcat server, we deploy the war file
cd terraform
terraform apply -auto-approve
cd ..

# test on the infrastructure we just put together
cd terraform
echo hosturl=http://`terraform output tomcat_dns`:8080 > rest_webservice.properties
mv rest_webservice.properties ../.
cd ..
mvn verify

# destroy the test infrastructure
cd terraform
terraform destroy -auto-approve
cd ..
echo hosturl=http://localhost:8080 > rest_webservice.properties