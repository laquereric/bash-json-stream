#!/bin/bash

# see : https://docs.marklogic.com/REST/POST/manage/v2/servers

read INPUT_JSON;

# Collect Variables From Input JSON
PROPERTIES_JSON=` echo $INPUT_JSON | jq -c '.properties' | jq -c '{properties:.}'`

HOSTURL=` echo $INPUT_JSON | jq -r -c '.host'| tr -d \" `
USERPW=` echo $INPUT_JSON | jq -r -c '.userpw'| tr -d \" `
PORT=` echo $INPUT_JSON | jq -r -c '.port' | tr -d \" `
DATA_JSON=`echo $INPUT_JSON | jq -r -c '. | del(.properties)| del(.host) | del(.userpw) | .+{"group-id":"Default"} | .+{"server-type":"http"} | .+{"format":"json"}' `
# | .+{root:'\' 
HEADER="Content-Type:application/json"

COMMAND=$(cat <<EOF
	curl -X POST \
	--anyauth
	-u $USERPW \
	-d '${DATA_JSON}' \
	'http://${HOSTURL}:8002/manage/v2/servers'
EOF
)

# Parameters not passed
# ?group-id=Default&server-type=http'

COMMAND_64=` echo $COMMAND | base64 --wrap=0 `
COMMAND_JSON=` echo "$COMMAND_64" | jq -c -R '{command:.}' `

# Assemble JSON Output
COMPONENT_LIST=` echo $PROPERTIES_JSON $COMMAND_JSON `
JSON_COMPONENTS=` echo $COMPONENT_LIST | jq --slurp '.' `

JSON=` echo $JSON_COMPONENTS | jq -c '.[0] + .[1]' `

#Return Output
echo $JSON
