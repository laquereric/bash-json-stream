#!/bin/bash

PROMPT_64=` echo $1 | tr -d \" `
PROMPT_64_JSON=` echo $PROMPT_64 | jq -R '{prompt:.}' `

NAME=` echo $2 | tr -d \" `
PORT_JSON=` echo $3 | tr -d \" | jq -R -c '{port:.}' `

# Read ML Host from pipeline

read INPUT_JSON;

# Collect Variables From Input JSON `
HOSTURL_JSON=` echo $INPUT_JSON | jq '.host'| tr -d \" | jq -R -c '{host:.}' `
USERPW_JSON=` echo $INPUT_JSON | jq '.userpw'| tr -d \" | jq -R -c '{userpw:.}' `

# Create JSON Items
PROPERTIES_JSON=` echo $PROMPT_64_JSON | jq -c '{properties:.}'`
SERVER_NAME="$NAME-Server"
SERVER_NAME_JSON=` echo $SERVER_NAME | jq -R -c '{"server-name":.}' `

DATABASE="Database"
DATABASE_NAME="$NAME-$DATABASE"
DATABASE_NAME_JSON=` echo $DATABASE_NAME | jq -R -c '{"content-database":.}' `

# Assemble JSON Output
COMPONENT_LIST=` echo $PROPERTIES_JSON $SERVER_NAME_JSON $DATABASE_NAME_JSON $PORT_JSON $HOSTURL_JSON $USERPW_JSON`
JSON_COMPONENTS=` echo $COMPONENT_LIST | jq --slurp '.' `
JSON=` echo $JSON_COMPONENTS | jq -c '.[0] + .[1] + .[2] + .[3] + .[4] + .[5]' `

#Return Output
echo $JSON
