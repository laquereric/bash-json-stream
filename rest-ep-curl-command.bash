#!/bin/bash

function quit {
exit
}

INPUT_JSON=$1

# Collect Variables From Input JSON
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

#Return Output
echo $COMMAND


