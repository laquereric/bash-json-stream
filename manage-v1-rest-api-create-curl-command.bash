#!/bin/bash

# see https://docs.marklogic.com/REST/POST/v1/rest-apis

read INPUT_JSON;

# Collect Variables From Input JSON
PROPERTIES_JSON=` echo $INPUT_JSON | jq -c '.properties' | jq -c '{properties:.}'`

HOSTURL=` echo $INPUT_JSON | jq -r -c '.host'| tr -d \" `
USERPW=` echo $INPUT_JSON | jq -r -c '.userpw'| tr -d \" `
CONTENT_DATABASE=` echo $INPUT_JSON | jq -r -c '.["content-database"]'| tr -d \" `
SERVER_NAME=` echo $INPUT_JSON | jq -r -c '.["server-name"]' | tr -d \" `

REST_API_JSON=`echo $INPUT_JSON | jq  -r -c --arg DB $CONTENT_DATABASE  '.+{"database":$DB} | .+{"name":.["server-name"]} | del(.properties) | del(.host) | del(.userpw) | del(.["content-database"]) | del(.["server-name"])' | jq  -r -c --arg SN $SERVER_NAME '.+{"name":$SN}' `

DATA_JSON=`jq -n -r -c --argjson RJ $REST_API_JSON '{"rest-api":$RJ}' `

HEADER="Content-Type:application/json"

COMMAND=$(cat <<EOF
	curl -v -X POST \
	--anyauth
	-u $USERPW \
	-H "$HEADER" \
	-d '${DATA_JSON}' \
	'http://localhost:8002/manage/v1/rest-api'
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
