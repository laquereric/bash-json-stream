#!/bin/bash +x

# see https://docs.marklogic.com/REST/POST/v1/rest-apis

# Collect Variables From Input JSON

read INPUT_JSON

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

PROPERTIES=` \
	echo $INPUT_JSON | \
	jq -r -c '.properties' \
`

REST_API=` \
	echo $INPUT_JSON | \
	jq -r -c '.["rest-api"]' | \
	jq -r -c '{"rest-api":.}' \
`

HEADER="Content-Type:application/json"

COMMAND=$(cat <<EOF
	curl -s \
	--anyauth
	-u $USERPW \
	-H "$HEADER" \
	-d '${REST_API}' \
	'http://${HOSTURL}:8002/v1/rest-apis'
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
