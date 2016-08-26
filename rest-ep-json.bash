#!/bin/bash

function quit {
exit
}

INPUT_JSON=$1

# Collect Variables From Input JSON
NAME=` echo $INPUT_JSON | jq '.name' | tr -d \" `
HOSTURL_JSON=` echo $INPUT_JSON | jq '.host'| tr -d \" | jq -R -c '{host:.}' `
USERPW_JSON=` echo $INPUT_JSON | jq '.userpw'| tr -d \" | jq -R -c '{userpw:.}' `
PORT_JSON=` echo $INPUT_JSON | jq '.port' | tr -d \" | jq -R -c '{port:.}' `

# Create JSON Items
SERVER="Server"
SERVER_NAME="$NAME-$SERVER"
SERVER_NAME_JSON=` echo $SERVER_NAME | jq -R -c '{name:.}' `

DATABASE="Database"
DATABASE_NAME="$NAME-$DATABASE"
DATABASE_NAME_JSON=` echo $DATABASE_NAME | jq -R -c '{database_name:.}' `

# Assemble JSON Output
COMPONENT_LIST=` echo $SERVER_NAME_JSON $DATABASE_NAME_JSON $PORT_JSON $HOSTURL_JSON $USERPW_JSON`
JSON_COMPONENTS=` echo $COMPONENT_LIST | jq --slurp '.' `
JSON=` echo $JSON_COMPONENTS | jq -c '.[0] + .[1] + .[2] + .[3] + .[4] + .[5]' `

#Return Output
echo $JSON
