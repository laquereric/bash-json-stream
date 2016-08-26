#!/bin/bash

SHOW_COMMAND='true'
RUN_COMMAND='true'

function quit {
exit
}

INPUT_JSON=$1

# Collect Variables From Input JSON
HOSTURL=`echo $INPUT_JSON | jq '.host'| tr -d \"`
USERPW=`echo $INPUT_JSON | jq '.userpw'| tr -d \"`
NAME=`echo $INPUT_JSON | jq '.name' | tr -d \" `
PORT=`echo $INPUT_JSON | jq '.port' | tr -d \"`

# Create JSON Items
SERVER="Server"
SERVER_NAME="$NAME$SERVER"
SERVER_NAME_JSON=`echo $SERVER_NAME | jq -R -c '{name:.}'`

DATABASE="Database"
DATABASE_NAME="$NAME$DATABASE"
DATABASE_NAME_JSON=`echo $DATABASE_NAME | jq -R -c '{database_name:.}'`

PORT_JSON=`echo $PORT | jq -R '{port:.}'`

# ASSEMBLE JSON PAYLOAD
INNER_JSON_COMPONENTS=`echo $SERVER_NAME_JSON $DATABASE_NAME_JSON $PORT_JSON | jq --slurp '.' `
INNER_JSON=`echo $INNER_JSON_COMPONENTS | jq -c '.[0] + .[1] + .[2]' `

JSON_DATA=`echo $INNER_JSON | jq -c '{"rest-api":.}'`
echo $JSON_DATA
quit
#'{"rest-api":{"name":"$SERVER_NAME"}}' | jq -n -c  -j '.'`

#echo $DATA_JSON
quit

COMMAND=$(cat <<EOF
	curl -v -X POST \
	--anyauth \
	-u $USERPW \
	--header "Content-Type:application/json" \
	-d '${DATA_JSON}' \
	http://$HOSTURL:8002/v1/rest-apis
EOF
)

if [ $SHOW_COMMAND = 'true' ]; then
   echo $COMMAND
fi

if [ $RUN_COMMAND = 'true' ]; then
	eval $COMMAND
fi
