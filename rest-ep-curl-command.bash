#!/bin/bash

read INPUT_JSON;

# Collect Variables From Input JSON
PROPERTIES_JSON=` echo $INPUT_JSON | jq -c '.properties' | jq -c '{properties:.}'`

HOSTURL=` echo $INPUT_JSON | jq -r -c '.host'| tr -d \" `
USERPW=` echo $INPUT_JSON | jq -r -c '.userpw'| tr -d \" `
PORT=` echo $INPUT_JSON | jq -r -c '.port' | tr -d \" `
DATA_JSON=`echo $INPUT_JSON | jq -r -c '{"rest-api":{"name":.name,"database":.database_name,"port":.port}}' `

HEADER="Content-Type:application/json"

COMMAND=$(cat <<EOF
	curl -v -X POST \
	--anyauth \
	-u $USERPW \
	--header "$HEADER" \
	-d '${DATA_JSON}' \
	http://$HOSTURL:8002/v1/rest-apis
EOF
)

COMMAND_64=` echo $COMMAND | base64 --wrap=0 `
#echo $COMMAND_64
COMMAND_JSON=` echo "$COMMAND_64" | jq -c -R '{command:.}' `
#echo $COMMAND_JSON
# Assemble JSON Output
COMPONENT_LIST=` echo $PROPERTIES_JSON $COMMAND_JSON `
#echo $COMPONENT_LIST
JSON_COMPONENTS=` echo $COMPONENT_LIST | jq --slurp '.' `
#echo $JSON_COMPONENTS
JSON=` echo $JSON_COMPONENTS | jq -c '.[0] + .[1]' `

#Return Output
echo $JSON
