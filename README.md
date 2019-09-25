![PageSeeder](https://www.pageseeder.com/thumbnail/images/pagseeder_web.jpg)

PageSeeder is a document collaboration platform, for general information see pageseeder.com . If you are interested in what was added in version 5.96, check out the release notes. One of the main new features is publications which enable the display of a full table of contents, heading/paragraph numbering and versioning for a set of documents. This version also has a new cross-reference user interface, including XRef configuration across a whole project to make it easy for users to create XRefs consistently for different purposes.

Learn more about PageSeeder: <https://www.pageseeder.com/>
# Overview
This Docker container allows a easy way to start up a instance of PageSeeder. 

# Quick Start

Start PageSeeder Server

    $ docker run -p 8080:8080 alletterchan/pageseeder 
    
PageSeeder is now available on [http://localhost:8080]

All default Environment Variable are supported, here are some of the common variables:

* `CATALINA_OPTS`   

    (Optional) Java runtime options used when the "start", "run" or "debug" command is executed. Include here and not in JAVA_OPTS all options, that should only be used by Tomcat itself, not by the stop process, the version command etc. Examples are heap size, GC logging, JMX ports etc.    
   
* `JAVA_OPTS`
       
    (Optional) Java runtime options used when any command is executed. Include here and not in CATALINA_OPTS all options, that should be used by Tomcat and also by the stop process, the version command etc. Most options should go into CATALINA_OPTS.

#Docker Compose
If you prefer setup the whole PageSeeder application with Database, you can use this docker-compose.yml

    $ docker-compose up
    
Available Environment Variables:

* `MYSQL_ROOT_PASSWORD` (default: password)

   The MySQL Root Password.

* `MYSQL_DATABASE` (default: pageseeder)

   The Database name.
       
* `MYSQL_USER` (default: pageseeder)
   
   The Database Username.    

* `MYSQL_PASSWORD` (default: pageseederDB123)
      
   The Database Password.    

Note: PageSeeder Setup
in the database host URL, use the name of the database container e.g. `psdb`
