#!/bin/bash

# see : https://docs.marklogic.com/REST/POST/manage/v2/databases

read INPUT_JSON;

# Collect Variables From Input JSON
NAME=` echo $INPUT_JSON | jq -r -c '.name'`

ML_HOST_CONNECTION=` \
	echo $INPUT_JSON | \
	jq -r -c '.["ml-host-connection"]' \
`

HOSTURL=` \
	echo $ML_HOST_CONNECTION | \
	jq -r -c '.host'| \
	tr -d \"
`

USERPW=` \
	echo $ML_HOST_CONNECTION | \
	jq -r -c '.userpw' | \
	tr -d \" \
`
RESOURCE_TYPE=` \
	echo $INPUT_JSON | \
	jq -r -c '.["resource-type"]' \
`
PARAMETERS=` \
	echo $INPUT_JSON | \
	jq -r -c '.["parameters"]' \
`

PROPERTIES=` \
	echo $INPUT_JSON | \
	jq -r -c '.properties' \
`

DATA=` \
	echo $INPUT_JSON | \
	jq -r -c '.data'
`

HEADER="Content-Type:application/json"

COMMAND=$(cat <<EOF
	curl -X PUT -s \
	--anyauth
	-u $USERPW \
	-H "$HEADER" \
	-d '${DATA}' \
	'http://${HOSTURL}:8002/manage/v2/${RESOURCE_TYPE}/${NAME}/properties'
EOF
)

JSON_OUTPUT=` \
	echo $COMMAND | \
	base64 --wrap=0 | \
	jq -c -R '{"command-64":.}' | \
	jq -r -c --argjson PR $PROPERTIES '{"properties":$PR}+.' \
`

#Return Output
echo $JSON_OUTPUT