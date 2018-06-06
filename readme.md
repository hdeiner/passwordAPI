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