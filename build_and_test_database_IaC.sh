#!/usr/bin/env bash

# create the test infrasctucture
cd terraform
terraform apply -auto-approve
export SQLSVR=$(echo `terraform output sqlsvr_dns`)
echo we are running a terraformed MS SQLSVR instance on $SQLSVR
rm ../liquibase.properties
cat <<EOF >> ../liquibase.properties
classpath=lib/sqljdbc_6.4/enu/mssql-jdbc-6.4.0.jre8.jar
driver=com.microsoft.sqlserver.jdbc.SQLServerDriver
url= jdbc:sqlserver://$SQLSVR:1433
username=sa
password=Strong!Passw0rd
EOF
cd ..

# test on the infrastructure we just put together
echo Install tSQLt
mkdir -p target/tSQLt
sqlcmd -S $SQLSVR,1433 -U SA -P 'Strong!Passw0rd' -Q "ALTER DATABASE master SET TRUSTWORTHY ON;"
sqlcmd -S $SQLSVR,1433 -U SA -P 'Strong!Passw0rd' -i "tSQLt/tSQLt.class.sql" -o "target/tSQLt/Sales_Database_tSQLt_Install.txt"

echo Create database
liquibase --changeLogFile=src/test/db/changelog-with-unit-tests.xml update

echo Run the tSQLt unit tests
sqlcmd -S $SQLSVR,1433 -U SA -P 'Strong!Passw0rd' -Q "sp_configure @configname=clr_enabled, @configvalue=1"
sqlcmd -S $SQLSVR,1433 -U SA -P 'Strong!Passw0rd' -Q "RECONFIGURE"
sqlcmd -S $SQLSVR,1433 -U SA -P 'Strong!Passw0rd' -Q "EXEC tSQLt.RunAll"

echo Make sure that the unit tests ran
sqlcmd -S $SQLSVR,1433 -U SA -P 'Strong!Passw0rd' -Q "EXEC tSQLt.RunAll"

# destroy the test infrastructure
cd terraform
terraform destroy -auto-approve
cd ..
rm liquibase.properties
cat <<EOF >> liquibase.properties
classpath=lib/sqljdbc_6.4/enu/mssql-jdbc-6.4.0.jre8.jar
driver=com.microsoft.sqlserver.jdbc.SQLServerDriver
url= jdbc:sqlserver://localhost:1433
username=sa
password=Strong!Passw0rd
EOF