# to run the container
#  docker run --name ps -p 8080 -p 8282 --rm -dit fc4f131d88ba  /bin/bash
# TODO: switch to coreos for smaller footprint
FROM openjdk:8-jdk-alpine

MAINTAINER "Allette Systems"

#RUN useradd pageseeder
RUN addgroup -S pageseeder && adduser -S pageseeder -G pageseeder
# set run user and group
ENV RUN_USER            pageseeder
ENV RUN_GROUP           pageseeder

# set env for path
ENV PAGESEEDER_HOME          /opt/pageseeder
ENV PAGESEEDER_TOMCAT_HOME   $PAGESEEDER_HOME/tomcat

EXPOSE 8080
EXPOSE 8282

#WORKDIR $PAGESEEDER_HOME

# install depedency
# TODO switch to apk instead for smaller footprint
RUN apk add --update \
    bash \
    tar \
    curl \
    && rm -rf /var/cache/apk/*

# Install YUM repo
#RUN rpm -Uvh http://download.pageseeder.com/pub/rpm/pageseeder-repository-1.0-1.noarch.rpm

# Install PageSeeder
#RUN yum -y install pageseeder && yum clean all

ARG PAGESEEDER_VERSION=5.9700~beta6
#RUN rpm -Uvh http://download.pageseeder.com/pub/rpm/beta/pageseeder-${PAGESEEDER_VERSION}-1.noarch.rpm
RUN mkdir /opt
RUN curl -L -o /opt/pageseeder.tar.gz http://download.pageseeder.com/pub/binary/pageseeder.tar.gz
RUN tar -xvxf /opt/pageseeder.tar.gz
# Install MYSQL JDBC connector
RUN curl -L -o /tmp/mysql-connector-java-5.1.45.tar.gz --silent https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.45.tar.gz
RUN tar -xzf /tmp/mysql-connector-java-5.1.45.tar.gz -C /tmp
RUN mkdir -p $PAGESEEDER_HOME/webapp/WEB-INF/drivers
RUN cp /tmp/mysql-connector-java-5.1.45/mysql-connector-java-5.1.45-bin.jar $PAGESEEDER_HOME/webapp/WEB-INF/lib/
RUN chown pageseeder.pageseeder $PAGESEEDER_HOME/webapp/WEB-INF/lib/ -R
RUN chmod a+x $PAGESEEDER_HOME/tomcat/bin/*.sh -R

USER pageseeder
# add file with change ownership
ADD --chown=pageseeder:pageseeder docker/tomcat/bin/startup.sh $PAGESEEDER_TOMCAT_HOME/bin/
ADD --chown=pageseeder:pageseeder docker/tomcat/conf/server.xml $PAGESEEDER_TOMCAT_HOME/conf/

COPY --chown=pageseeder:pageseeder docker-entrypoint.sh /docker-entrypoint.sh

# change mode for startup.sh
#RUN chmod -R 700 $PAGESEEDER_TOMCAT_HOME/bin/startup.sh
#RUN chmod -R 700 $PAGESEEDER_TOMCAT_HOME/bin/catalina.sh
#RUN chmod -R 700 /docker-entrypoint.sh

# start PageSeeder
# su -s /bin/bash pageseeder -c /opt/pageseeder/tomcat/bin/startup.sh

# export default pageseeder and API port
USER root
CMD ["/docker-entrypoint.sh", "-fg"]
#ENTRYPOINT ["/sbin/tini", "--"]


# make this executable
#ENTRYPOINT ["/docker-entrypoint.sh"]