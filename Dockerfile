# to run the container
#  docker run --name ps -p 8080 -p 8282 --rm -dit fc4f131d88ba  /bin/bash
# TODO: switch to coreos for smaller footprint
FROM centos:7

MAINTAINER "Ringo Chan" <rchan@allette.com.au>

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
RUN yum install -y \
	rpm-build \
	rpm-sign \
	which \
	tini \
	net-tools \
	xinetd \
	mysql \
	wget

# Install Java
RUN yum -y install java-1.8.0-openjdk

# Install YUM repo
#RUN rpm -Uvh http://download.pageseeder.com/pub/rpm/pageseeder-repository-1.0-1.noarch.rpm

# Install PageSeeder
#RUN yum -y install pageseeder && yum clean all

ARG PAGESEEDER_VERSION=5.9700~beta6
RUN rpm -Uvh http://download.pageseeder.com/pub/rpm/beta/pageseeder-${PAGESEEDER_VERSION}-1.noarch.rpm

# Install MYSQL JDBC connector
RUN wget -O /tmp/mysql-connector-java-5.1.45.tar.gz https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.45.tar.gz
RUN tar xzf /tmp/mysql-connector-java-5.1.45.tar.gz -C /tmp
RUN mkdir $PAGESEEDER_HOME/webapp/WEB-INF/drivers
RUN cp /tmp/mysql-connector-java-5.1.45/mysql-connector-java-5.1.45-bin.jar $PAGESEEDER_HOME/webapp/WEB-INF/lib/
RUN chown pageseeder.pageseeder $PAGESEEDER_HOME/webapp/WEB-INF/lib/ -R
RUN chmod a+x $PAGESEEDER_HOME/tomcat/bin/*.sh -R

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

CMD ["/docker-entrypoint.sh", "-fg"]
#ENTRYPOINT ["/sbin/tini", "--"]

# make this executable
#ENTRYPOINT ["/docker-entrypoint.sh"]