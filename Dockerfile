FROM openjdk:8-jdk-alpine

MAINTAINER "Allette Systems"

# Environment variables for PageSeeder
# TODO: Update PageSeeder Download URL
ENV PAGESEEDER_HOME="/opt/pageseeder" \
    PAGESEEDER_DOWNLOAD_URL="http://download.pageseeder.com/pub/binary/pageseeder.tar.gz"

EXPOSE 8080 8282

WORKDIR $PAGESEEDER_HOME

RUN set -x \
    && apk add --update bash tar curl \
    && rm -rf /var/cache/apk/* \

# Retrieve PageSeeder and MySQL JDBC driver
RUN curl -Ls "${PAGESEEDER_DOWNLOAD_URL}" | tar -xz --directory /opt --strip-components=1 --no-same-owner \
RUN curl -Ls "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.45.tar.gz" | tar -xz --directory "${PAGESEEDER_HOME}/webapp/WEB-INF/lib" --strip-components=1 --no-same-owner "mysql-connector-java-5.1.45/mysql-connector-java-5.1.45-bin.jar"

CMD ["/opt/pageseeder/tomcat/bin/catalina.sh", "run", "-fg"]