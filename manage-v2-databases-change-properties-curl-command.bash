#!/bin/bash

# see : https://docs.marklogic.com/REST/POST/manage/v2/databases

read INPUT_JSON;

# Collect Variables From Input JSON
PROPERTIES_JSON=` echo $INPUT_JSON | jq -c '.properties' | jq -c '{properties:.}'`

HOSTURL=` echo $INPUT_JSON | jq -r -c '.host'| tr -d \" `
USERPW=` echo $INPUT_JSON | jq -r -c '.userpw'| tr -d \" `

DATABASE_NAME=` echo $INPUT_JSON | jq -r -c '.["database-name"]' | tr -d \" `
DATA_JSON=`jq -n -r -c '{"collection-lexicon":true}' `

HEADER="Content-Type:application/json"

COMMAND=$(cat <<EOF
	curl -X PUT -s \
	--anyauth
	-u $USERPW \
	-H "$HEADER" \
	-d '${DATA_JSON}' \
	'http://${HOSTURL}:8002/manage/v2/databases/$DATABASE_NAME/properties'
EOF
)

COMMAND_64=` echo $COMMAND | base64 --wrap=0 `
COMMAND_JSON=` echo "$COMMAND_64" | jq -c -R '{command:.}' `

# Assemble JSON Output
COMPONENT_LIST=` echo $PROPERTIES_JSON $COMMAND_JSON `
JSON_COMPONENTS=` echo $COMPONENT_LIST | jq --slurp '.' `

JSON=` echo $JSON_COMPONENTS | jq -c '.[0] + .[1]' `

#Return Output
echo $JSON
