#!/bin/bash

# see https://docs.marklogic.com/REST/GET/manage/v2/hosts

read INPUT_JSON;

# Collect Variables From Input JSON
PROPERTIES_JSON=` echo $INPUT_JSON | jq -c '.properties' | jq -c '{properties:.}'`

HOSTURL=` echo $INPUT_JSON | jq -r -c '.host'| tr -d \" `
USERPW=` echo $INPUT_JSON | jq -r -c '.userpw'| tr -d \" `
PORT=` echo $INPUT_JSON | jq -r -c '.port' | tr -d \" `

HEADER="Content-Type:application/json"

COMMAND=$(cat <<EOF
	curl -s \
	--anyauth
	-u $USERPW \
	'http://${HOSTURL}:8002/manage/v2/hosts?format=json'
EOF
)

COMMAND_64=` echo $COMMAND | base64 --wrap=0 `
echo $COMMAND_64
#COMMAND_JSON=`  | jq -c -R '{command:.}' `

# Assemble JSON Output
#COMPONENT_LIST=` echo $COMMAND_JSON `
#JSON_COMPONENTS=` echo $COMPONENT_LIST | jq --slurp '.' `

#JSON=` echo $JSON_COMPONENTS | jq -c '.[0]' ` 
# + .[1]' `

#Return Output
#echo $JSON
