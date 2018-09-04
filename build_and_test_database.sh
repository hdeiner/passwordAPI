#!/usr/bin/env bash

echo Kill the current Docker sqlsvrtest container
./docker/docker_reset_sqlsvrtest_container.sh
echo Create a fresh Docker sqlsvrtest container
./docker/docker_start_sqlsvrtest_container.sh

echo Pause 10 seconds to allow SQL Server to start up
sleep 10

echo Install tSQLt
mkdir -p target/tSQLt
sqlcmd -S localhost,1433 -U SA -P 'Strong!Passw0rd' -Q "ALTER DATABASE master SET TRUSTWORTHY ON;"
sqlcmd -S localhost,1433 -U SA -P 'Strong!Passw0rd' -i "tSQLt/tSQLt.class.sql" -o "target/tSQLt/Sales_Database_tSQLt_Install.txt"

echo Create database
liquibase --changeLogFile=src/test/db/changelog-with-unit-tests.xml update

echo Run the tSQLt unit tests
sqlcmd -S localhost,1433 -U SA -P 'Strong!Passw0rd' -Q "sp_configure @configname=clr_enabled, @configvalue=1"
sqlcmd -S localhost,1433 -U SA -P 'Strong!Passw0rd' -Q "RECONFIGURE"
sqlcmd -S localhost,1433 -U SA -P 'Strong!Passw0rd' -Q "EXEC tSQLt.RunAll"

echo Make sure that the unit tests ran
sqlcmd -S localhost,1433 -U SA -P 'Strong!Passw0rd' -Q "EXEC tSQLt.RunAll"