FROM openjdk:8-jdk-alpine

MAINTAINER "Allette Systems"

# Environment variables for PageSeeder
# TODO: Update PageSeeder Download URL
ENV PAGESEEDER_HOME=/opt/pageseeder \
    PAGESEEDER_VERSION=latest \
    MYSQL_JDBC_VERSION=5.1.45

EXPOSE 8080 8282

WORKDIR $PAGESEEDER_HOME

# Add library packages
RUN set -x \
    && apk add --update bash tar curl \
    && rm -rf /var/cache/apk/*

# Retrieve PageSeeder and MySQL JDBC driver
RUN curl -Ls "http://download.pageseeder.com/pub/binary/pageseeder-${PAGESEEDER_VERSION}.tar.gz" \
    | tar -xz --directory /opt --strip-components=1 --no-same-owner
RUN curl -Ls "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_JDBC_VERSION}.tar.gz" \
    | tar -xz --directory "${PAGESEEDER_HOME}/webapp/WEB-INF/lib" --strip-components=1 --no-same-owner \
      "mysql-connector-java-${MYSQL_JDBC_VERSION}/mysql-connector-java-${MYSQL_JDBC_VERSION}-bin.jar"

# Start Tomcat in foreground
CMD ["/opt/pageseeder/tomcat/bin/catalina.sh", "run", "-fg"]