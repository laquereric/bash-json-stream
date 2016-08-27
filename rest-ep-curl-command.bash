#!/bin/bash

read INPUT_JSON;

# Collect Variables From Input JSON
PROPERTIES_JSON=` echo $INPUT_JSON | jq '.properties' | jq -c '{properties:.}'`

HOSTURL=` echo $INPUT_JSON | jq '.host'| tr -d \" `
USERPW=` echo $INPUT_JSON | jq '.userpw'| tr -d \" `
PORT=` echo $INPUT_JSON | jq '.port' | tr -d \" `
DATA_JSON=`echo $INPUT_JSON | jq '{"rest-api":{"name":.name,"database_name":.database_name,"port":.port}}' `

COMMAND=$(cat <<EOF
	curl -v -X POST \
	--anyauth \
	-u $USERPW \
	--header "Content-Type:application/json" \
	-d '${DATA_JSON}' \
	http://$HOSTURL:8002/v1/rest-apis
EOF
)

COMMAND_JSON=` echo $COMMAND | jq -R -c '{command:.}' `

# Assemble JSON Output
COMPONENT_LIST=` echo $PROPERTIES_JSON $COMMAND_JSON`
JSON_COMPONENTS=` echo $COMPONENT_LIST | jq --slurp '.' `
JSON=` echo $JSON_COMPONENTS | jq -c '.[0] + .[1]' `

#Return Output
echo $JSON


