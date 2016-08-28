#!/bin/bash

read INPUT_JSON;

# Collect Variables From Input JSON
PROPERTIES_JSON=` echo $INPUT_JSON | jq -r -c '.properties' | jq -r -c '{properties:.}'`

HOSTURL=` echo $INPUT_JSON | jq -r -c '.host'| tr -d \" `
USERPW=` echo $INPUT_JSON | jq -r -c '.userpw'| tr -d \" `
PORT=` echo $INPUT_JSON | jq -r -c '.port' | tr -d \" `
DATA_JSON=`echo $INPUT_JSON | jq -r -c '{"rest-api":{"name":.name,"database_name":.database_name,"port":.port}}' `

COMMAND=$(cat <<EOF
	curl -v -X POST \
	--anyauth \
	-u $USERPW \
	--header "Content-Type:application/json" \
	-d '${DATA_JSON}' \
	http://$HOSTURL:8002/v1/rest-apis
EOF
)

COMMAND_JSON=` echo $COMMAND | jq -r -R -c '{command:.}' `

# Assemble JSON Output
COMPONENT_LIST=` echo $PROPERTIES_JSON $COMMAND_JSON`
JSON_COMPONENTS=` echo $COMPONENT_LIST | jq -r -c --slurp '.' `
JSON=` echo $JSON_COMPONENTS | jq -r -c '.[0] + .[1]' `

#Return Output
echo $JSON


