This project builds upon the foundation established in https://github.com/hdeiner/mssqlsvr_automation_sample

Things I've learned:
* Docker for Windows sucks.
* You must use Windows containers for Docker for Windows, unless you are willing to run the experimental flag on the daemon.  
* The Windows containers for MSSQL Server are over 10 times larger than the Linux containers.  
* Here's where the Docker Windows MSSQL Servers are located:  https://hub.docker.com/r/microsoft/mssql-server-windows-developer/

A sample docker command to start the Windows Container for MSSQL Server from PowerShell.  It is over 15GB in size.  Makes you wonder what the hell Microsoft has stuffed inside it!!
docker run -d -p 1433:1433 -e sa_password=Strong!Password -e ACCEPT_EULA=Y microsoft/mssql-server-windows-developer:latest  

Had to install the entire SQL Server 2017 Development Suite, and then the entire set of SQL Server Management Tools simply to get a workable sqlcmd to work from the windows command line (PowerShell).  Micrsoft.  Really?

Using tSQLt_V1.0.5873.27393 from https://tsqlt.org/

But the point of this project is to demonstrate how one should never get blocked when developing.  So, first, some explanation of WHY you're looking at the HOWs of what this project does.

Assume we are developing some REST APIs that will be called to answer two questions:
* Does the password a user wants to use pass all of our "password rules"?
* Is the password a user wants to use "complex" enough?

Naturally, we want to "move testing left".  That's what's shown here.  We don't want to get blocked by the fact that we don't have a REST API developed yet to stop us from testing it!  So, we start with the definition of some executable requirements, also known as Behavior Driven Development, Specification By Example, Acceptance Test Driven Development, or other sexy words.  Really, they represent the requirements that are going to be developed, except the computer can determine if the requirements have been met by running them as tests.  See the feature files located at src/test/features to see what I'm talking about.  Both business people and developers can understand the Gherkin in those feature files.  And developers and QA types can write the tests needed to make them come to life!

Now, as to writing that code.  We need UNIT TESTS for that code (which is a TODO right now) to help us answer the following questions:
* "How's my code doing?"
* Does it catch exceptions (etc) correctly?
* Did I exercise all the code I've written?
* Is my code highly cohesive?  Loosely coupled?  Have low cyclomatic complexity?  Etc.  "Did I write GOOD code?"
* "Can others understand my code?" 

As to testing of the code that hasn't been written.  We have some issues.  There's probably a database which isn't ready yet.  There's that pesky code that hasn't been written.  But we can't let that stop us!
* So we use "Wiremock" to FAKE a REST WebService.  See src/test/resources for files that WireMock uses to answer requests that will get made from the real server when it's ready.
* But even now, we can decide what the JSON packages look like.  What answers will be given for which questions.
* See src/test/java/test/CucumberClientInterface and CucumberClientFake for fake implementations used by Cucumber for talking to our fake server.
* When the real code is ready, we can implement CucumberClientInterface with a concrete implementation against the real server to test.

And also view the results, located at target/cucumber-html-reports/overview-features.html for an example of what business people "Product Owners" should be concerned with.  We need to start thinking in terms of "Running Tested Features" and less in terms of "Velocity" to know that we're "getting there!"

Remember, this integration/component testing is helping us answer the following:
* "How's the functionality?"
* "Are we there yet?"
* "Is the code fit for purpose?"
* "Am I providing business value?"
* "Can others understand what I have to offer?"

Work was done to run both unit, cucumber "unit type", and cucumber against fake WireMock server.  Now, I'd like to run against a full Glassfish Docker'ized web service with my code welded in place there.

We will use Glassfish to run our web services inside Docker containers.  oracle/glassfish:latest  This implies development of the service in Java with javax.ws.rs

Glassfish should allow deployment as in
```bash
asadmin start-domain
asadmin deploy  target/passwordAPI.war
``` 
However, that results in  
```bash
remote failure: Error occurred during deployment: Exception while loading the app : CDI deployment failure:Error instantiating :org.hibernate.validator.cdi.internal.ValidationExtension. Please see server.log for more details.
Command deploy failed.
```
OK.  How about foregoing the CDI Validation?
```bash
asadmin deploy --property implicitCdiEnabled=false target/passwordAPI.war
``` 
That results in 
```bash
remote failure: Error occurred during deployment: Exception while loading the app : java.lang.IllegalStateException: ContainerBase.addChild: start: org.apache.catalina.LifecycleException: org.apache.catalina.LifecycleException: java.lang.ClassNotFoundException: org.joda.time.ReadableInstant. Please see server.log for more details.
Command deploy failed.
```
We'll stay simple and just use Tomcat for an application server.
#By the way...
## Once a server is running, you can run an easy test from the command line with something like
```bash
curl http://localhost:8080/passwordAPI/passwordRules/easyPassword
```

## And you should get a response like
```bash
{"password": "easyPassword","passwordRules":"password must have at least 1 digit in it"}``
```

#SO WHAT SORTS OF TESTING DOES THIS PROJECT DEMONSTRATE, ANYWAY?

Take a look at the directories at src/test/java/test

## rest_webservice_fake  
* This is acually where I started.  
* It lays out the functionality of the REST API WebService as executable requirements as defined in the src/test/features Cucumber feature files.
* CucumberClientFake uses WireMock at implement a fake server.
* CucumberClientFake also uses Resty as an easy to implement RESTWS client
* We are testing here that we implemented the interface correctly in terms of the JSON passed between client and server.
* In src/test/resources/mappings, we find things like passwordStrength-11.json to see what a request that matches a Gherkin outline sample looks like
* In src/test/resources/__files, we find things like passwordStrength-11.json to see what the corresponding response looks like
* These tests run fairly quickly (3 s 24 ms)

## unit  
* This is where you will find traditional junit tests located
* I built this code as I implemented the functionality in src/main/java/main/PasswordRules.java and PasswordStrength.java
* I am testing that the code was built right, not that it actually answers all of the functionality concerns
* These tests run extremely quickly (67 ms)

## unit_cucumber  
* Here, I have wired the execution of the same feature files to execute without going through the REST API level
* I am testing that the right code was built, and that the functionality concerns are met
* These tests run very quickly (464 ms)

## rest_webservice_local  
* This set of tests runs the exact same set of Cucumber feature files through a locally hosted Tomcat based application server  
* One invokes this using mvn verify
* We can have a lot of confidence that not only will the tests run well, but that they are likely to deploy without issue
* These tests run pretty quick (558 ms).  The functionality offerred by dependency breaking in WireMock had it's price.

# Of special note:
Take a look at build_and_test_webservice.sh.  This bash script builds and tests a deployable war artifact.  Then it creates a fresh Docker container to deploy the artifact to.  It then runs tests against the deployed artifact INSIDE the Docker container.  When we are done, we have a completely deployable DOCKER CONTAINER that runs our tested microservice.

# Terraform Stuff:

Right now, there is enough Terraform stuff to build a SQL Server instance and a Tomcat Server.  The Tomcat server is also provisioned with the passwordAPI.war that we built.

# Use
1. Make sure that you can use AWS CLI without issue.  In particular,
you need valid ~/.aws config and credentials files.
2. Make sure that you have SSH keys generated in your ~/.ssh.  This can be done by: 
```
ssh-keygen -t rsa
```
3. Make sure that Terraform is installed.
4. Ensure that terraformProvider.tf has appropriate settings for your use.  For example,
the AWS region may have to change, and that will require a change in the 
AMI used.
5. On the command line, create the infrastructure with
 ```
 terraform init
 terraform apply -auto-approve
 ```
6. When you're ready to get rid of the infrastructure that we built, do that as
 ```
 terraform destroy -auto-approve
 ```
7. But for some real fun, take a look at build_and_test_webservice_IaC.  Here, we 
* build and test locally,
* create the test environment on demand with terraform, 
* test remotely, 
* destroy the test infrastructure 

Demystifying the console output... 
* Initial mvn build and test (local) - familiar things, like
 ```
/build_and_test_webservice_IaC.sh 
[INFO] Scanning for projects...
[INFO]                                                                         
[INFO] ------------------------------------------------------------------------
[INFO] Building passwordAPI 1.0-SNAPSHOT
[INFO] ------------------------------------------------------------------------
[INFO] 
[INFO] --- maven-clean-plugin:2.5:clean (default-clean) @ passwordAPI ---
[INFO] Deleting /home/howarddeiner/IdeaProjects/passwordAPI/target
 ...
 ```
 * terraform apply - less familiar things, like
 ```
aws_key_pair.passwordAPI_key_pair: Creating...
  fingerprint: "" => "<computed>"
  key_name:    "" => "passwordAPI_key_pair"
  public_key:  "" => "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMQUSBu7bbQucVe1yfR58w4gvzMHDfYlUFLJL95FbyYOZK8sFk5FOBbXEIWkkkhVilYviH7T/h0aP1M+pNoI183afzMpl41wljApYbr9ud78MbOD04vBMyOFrlur4LOJEuAi1cCswOFA0JoCpFDzRQFajOPKVjnVlWvBxeG+uJbEj/tG5t2bQg65bcrZpEtkVzJ3hsWDy0p3UgIoJmDhyl3hBtFzc+28RiD9Fvo1HDWgM2fc8ISJ2kQ/5YeVop46iBmQFRDIkvotFMjn0qdFq+/roIHIJxP+AuzusSlke+LQJ15kUJgxzLX9yZhduQ0a4n77IWa7AgFNwNMSX/p1DJ howarddeiner@ubuntu"
aws_security_group.passwordAPI_sqlsvr: Creating...
  arn:                                   "" => "<computed>"
  description:                           "" => "PasswordAPI - SSH and SQL Server Access"
  egress.#:                              "" => "1"
  egress.482069346.cidr_blocks.#:        "" => "1"
 ...
aws_instance.ec2_passwordAPI_tomcat: Provisioning with 'file'...
aws_instance.ec2_passwordAPI_sqlsvr: Still creating... (1m10s elapsed)
aws_instance.ec2_passwordAPI_tomcat: Still creating... (1m10s elapsed)
aws_instance.ec2_passwordAPI_sqlsvr: Still creating... (1m20s elapsed)
aws_instance.ec2_passwordAPI_tomcat: Still creating... (1m20s elapsed)
aws_instance.ec2_passwordAPI_tomcat: Provisioning with 'remote-exec'...
aws_instance.ec2_passwordAPI_tomcat (remote-exec): Connecting to remote host via SSH...
aws_instance.ec2_passwordAPI_tomcat (remote-exec):   Host: 184.72.192.9
aws_instance.ec2_passwordAPI_tomcat (remote-exec):   User: ubuntu
aws_instance.ec2_passwordAPI_tomcat (remote-exec):   Password: false
aws_instance.ec2_passwordAPI_tomcat (remote-exec):   Private key: true
aws_instance.ec2_passwordAPI_tomcat (remote-exec):   SSH Agent: true
aws_instance.ec2_passwordAPI_tomcat (remote-exec):   Checking Host Key: false
aws_instance.ec2_passwordAPI_tomcat (remote-exec): Connected!
aws_instance.ec2_passwordAPI_tomcat: Creation complete after 1m28s (ID: i-0d3f717dcd40436c2)
aws_instance.ec2_passwordAPI_sqlsvr (remote-exec): Processing triggers for libc-bin (2.23-0ubuntu10) ...
aws_instance.ec2_passwordAPI_sqlsvr (remote-exec): Processing triggers for man-db (2.7.5-1) ...
aws_instance.ec2_passwordAPI_sqlsvr (remote-exec): Setting up libpython2.7-stdlib:amd64 (2.7.12-1ubuntu0~16.04.3) ...
aws_instance.ec2_passwordAPI_sqlsvr (remote-exec): Setting up python2.7 (2.7.12-1ubuntu0~16.04.3) ...
 ...
 Apply complete! Resources: 5 added, 0 changed, 0 destroyed.
 
 Outputs:
 
 aws_key_pair_name = [
     passwordAPI_key_pair
 ]
 aws_key_public_key = [
     ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMQUSBu7bbQucVe1yfR58w4gvzMHDfYlUFLJL95FbyYOZK8sFk5FOBbXEIWkkkhVilYviH7T/h0aP1M+pNoI183afzMpl41wljApYbr9ud78MbOD04vBMyOFrlur4LOJEuAi1cCswOFA0JoCpFDzRQFajOPKVjnVlWvBxeG+uJbEj/tG5t2bQg65bcrZpEtkVzJ3hsWDy0p3UgIoJmDhyl3hBtFzc+28RiD9Fvo1HDWgM2fc8ISJ2kQ/5YeVop46iBmQFRDIkvotFMjn0qdFq+/roIHIJxP+AuzusSlke+LQJ15kUJgxzLX9yZhduQ0a4n77IWa7AgFNwNMSX/p1DJ howarddeiner@ubuntu
 ]
 sqlsvr_dns = [
     ec2-35-174-138-216.compute-1.amazonaws.com
 ]
 sqlsvr_ip = [
     35.174.138.216
 ]
 tomcat_dns = [
     ec2-184-72-192-9.compute-1.amazonaws.com
 ]
 tomcat_ip = [
     184.72.192.9
 ]
 ...
 ```
* test on created infrastructure - familiar things (JUST LIKE THE LOCAL TESTS), like
 ```
 ...
Feature: UM Portal API - Password Strength
  As a security officer,
  I want to ensure that users choose passwords that are hard to reproduce,
  So that passwords aren't easily compromised.

  Password strength is calculated by the following formula
  1. Take the length of the password and subtract 8
  2. Add in all special special characters used in the password
  3. Subtract all consecutive upper or lower or special character or digit sequences in the password

  Scenario Outline: Password strength metric # src/test/features/passwordStrength.feature:12
    Given I want to change my password with the UM Portal on a fake server
    When I try to set my new password to "<password>"
    Then I then I should be told that it has a strength of "<passwordStrength>"

    Examples: 

  Scenario Outline: Password strength metric                               # src/test/features/passwordStrength.feature:19
    Given I want to change my password with the UM Portal on a fake server # CucumberStepDefsWebservice.i_want_to_change_my_password_with_the_UM_Portal_fake_server()
    When I try to set my new password to "passWord1!"                      # CucumberStepDefsWebservice.i_try_to_set_my_new_password_to(String)
    Then I then I should be told that it has a strength of "-1"            # CucumberStepDefsWebservice.i_then_I_should_be_told_that_it_has_a_strength_of(String)

  Scenario Outline: Password strength metric                               # src/test/features/passwordStrength.feature:20
    Given I want to change my password with the UM Portal on a fake server # CucumberStepDefsWebservice.i_want_to_change_my_password_with_the_UM_Portal_fake_server()
    When I try to set my new password to "bFihJv!srBChibW4ay*eXEksdh"      # CucumberStepDefsWebservice.i_try_to_set_my_new_password_to(String)
    Then I then I should be told that it has a strength of "11"            # CucumberStepDefsWebservice.i_then_I_should_be_told_that_it_has_a_strength_of(String)

10 Scenarios (10 passed)
30 Steps (30 passed)
0m1.719s
 ...
[INFO] All coverage checks have been met.
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 19.054 s
[INFO] Finished at: 2018-08-08T08:33:27-04:00
[INFO] Final Memory: 32M/342M
[INFO] ------------------------------------------------------------------------
[INFO] Shutdown hook executing
[INFO] Shutdown hook complete
 ```
 * terraform destroy - less familiar things, like
 ```
aws_key_pair.passwordAPI_key_pair: Refreshing state... (ID: passwordAPI_key_pair)
aws_security_group.passwordAPI_sqlsvr: Refreshing state... (ID: sg-0dbaf3fe0aa3b7e7d)
aws_security_group.passwordAPI_tomcat: Refreshing state... (ID: sg-048d3e3a58f512509)
aws_instance.ec2_passwordAPI_tomcat: Refreshing state... (ID: i-0ce6e34febc6b56eb)
aws_instance.ec2_passwordAPI_sqlsvr: Refreshing state... (ID: i-0f66a30453a2d3643)
aws_instance.ec2_passwordAPI_sqlsvr: Destroying... (ID: i-0f66a30453a2d3643)
aws_instance.ec2_passwordAPI_tomcat: Destroying... (ID: i-0ce6e34febc6b56eb)
aws_instance.ec2_passwordAPI_sqlsvr: Still destroying... (ID: i-0f66a30453a2d3643, 10s elapsed)
aws_instance.ec2_passwordAPI_tomcat: Still destroying... (ID: i-0ce6e34febc6b56eb, 10s elapsed)
aws_instance.ec2_passwordAPI_tomcat: Still destroying... (ID: i-0ce6e34febc6b56eb, 20s elapsed)
aws_instance.ec2_passwordAPI_sqlsvr: Still destroying... (ID: i-0f66a30453a2d3643, 20s elapsed)
aws_instance.ec2_passwordAPI_tomcat: Still destroying... (ID: i-0ce6e34febc6b56eb, 30s elapsed)
aws_instance.ec2_passwordAPI_sqlsvr: Still destroying... (ID: i-0f66a30453a2d3643, 30s elapsed)
aws_instance.ec2_passwordAPI_sqlsvr: Still destroying... (ID: i-0f66a30453a2d3643, 40s elapsed)
aws_instance.ec2_passwordAPI_tomcat: Still destroying... (ID: i-0ce6e34febc6b56eb, 40s elapsed)
aws_instance.ec2_passwordAPI_tomcat: Still destroying... (ID: i-0ce6e34febc6b56eb, 50s elapsed)
aws_instance.ec2_passwordAPI_sqlsvr: Still destroying... (ID: i-0f66a30453a2d3643, 50s elapsed)
aws_instance.ec2_passwordAPI_sqlsvr: Still destroying... (ID: i-0f66a30453a2d3643, 1m0s elapsed)
aws_instance.ec2_passwordAPI_tomcat: Still destroying... (ID: i-0ce6e34febc6b56eb, 1m0s elapsed)
aws_instance.ec2_passwordAPI_tomcat: Destruction complete after 1m2s
aws_security_group.passwordAPI_tomcat: Destroying... (ID: sg-048d3e3a58f512509)
aws_security_group.passwordAPI_tomcat: Destruction complete after 1s
aws_instance.ec2_passwordAPI_sqlsvr: Still destroying... (ID: i-0f66a30453a2d3643, 1m10s elapsed)
aws_instance.ec2_passwordAPI_sqlsvr: Destruction complete after 1m13s
aws_security_group.passwordAPI_sqlsvr: Destroying... (ID: sg-0dbaf3fe0aa3b7e7d)
aws_key_pair.passwordAPI_key_pair: Destroying... (ID: passwordAPI_key_pair)
aws_key_pair.passwordAPI_key_pair: Destruction complete after 0s
aws_security_group.passwordAPI_sqlsvr: Destruction complete after 1s

Destroy complete! Resources: 5 destroyed.
 ```
