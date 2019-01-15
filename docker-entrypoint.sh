#!/bin/bash
set -euo pipefail

echo "Starting PageSeeder ... ($PAGESEEDER_TOMCAT_HOME/bin/startup.sh)"
exec "$PAGESEEDER_TOMCAT_HOME/bin/catalina.sh" "run" "$@"
echo "PageSeeder Started."