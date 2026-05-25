#!/bin/bash
set -a

source .env

set +a

echo "Environment Variables are set:
 - DBHOST=$DBHOST
 - DBPORT=$DBPORT
 - DBUSER=$DBUSER
 - DATABASE=$DATABASE
 - DBPW=$DBPW
 - APP_COLOR=$APP_COLOR
 - MYSQL_PASSWORD=$MYSQL_ROOT_PASSWORD
"
