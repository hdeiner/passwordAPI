This project builds upon the foundation established in https://github.com/hdeiner/mssqlsvr_automation_sample

Things I've learned:
* Docker for Windows sucks.
* You must use Windows containers for Docker for Windows, unless you are willing to run the experimental flag on the daemon.  
* The Windows containers for MSSQL Server are over 10 times larger than the Linux containers.  
* Here's where the Docker Windows MSSQL Servers are located:  https://hub.docker.com/r/microsoft/mssql-server-windows-developer/

A sample docker command to start the Windows Container for MSSQL Server from PowerShell.  It is over 15GB in size.  Makes you wonder what the hell Microsoft has stuffed inside it!!
docker run -d -p 1433:1433 -e sa_password=Strong!Password -e ACCEPT_EULA=Y microsoft/mssql-server-windows-developer:latest  

TODOs:
* docker_start_sqlsvrtest_container.sh to build and test a tiny userid/password table
* docker_start_sqlsvrprod_container.sh
* Cucumber for Java testing of passwords.feature through wiremock
* SpecFlow testing of passwords.feature on PasswordRules and PasswordStrength using same passwords.feature 
* xUnit tests for PasswordRules and PasswordStrength