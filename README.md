## Setup network

~~~~
$ docker network create psnet
~~~~

## Install database
~~~~
$ docker run --network=psnet -p 3306:3306 --name psdb -e MYSQL_ROOT_PASSWORD=password -d mysql/mysql-server:5.7
~~~~
WARNING ! override with GRANT OPTION
Login to MYSQL command line
~~~~
$ docker exec -it psdb mysql -u root -p
~~~~ 
Grant privilege 
~~~~
mysql> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION; 
~~~~

## Install Pageseeder

## build Pageseeder image
~~~~
$ docker build -f Dockerfile https://github.com/pageseeder/docker.git -t ps
~~~~

## Run the container
~~~~
$ docker run -p 8080:8080 -v [/path/to/data]/config:/opt/pageseeder/webapp/WEB-INF/config--network=psnet --name=ps -it ps /bin/bash
~~~~

Note: PageSeeder Setup
in the database houst URL, use the name of the database container e.g. `psdb`