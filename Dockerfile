# fetch basic image  (see https://github.com/dekses/jersey-docker-demo/blob/master/Dockerfile)
FROM maven:3.5.2-jdk-8

# application placed into /opt/app
RUN mkdir -p /opt/app
WORKDIR /opt/app

# copy source to target
COPY pom.xml /opt/app/
COPY src/ /opt/app/src
RUN mvn install
RUN mvn package

# application port
EXPOSE 8080

# execute cleanse, build, test, install, and execute
CMD ["mvn", "exec:java"]