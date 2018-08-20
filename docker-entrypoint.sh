#!/bin/bash
set -e
echo "start ps"
#service pageseeder start
su -s /bin/bash pageseeder -c /opt/pageseeder/tomcat/bin/startup.sh

#Extra line added in the script to run all command line arguments
exec "$@"