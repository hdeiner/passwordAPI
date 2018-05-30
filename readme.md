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