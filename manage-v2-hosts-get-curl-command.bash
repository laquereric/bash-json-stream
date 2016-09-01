#!/bin/bash

# see https://docs.marklogic.com/REST/GET/manage/v2/hosts

read INPUT_JSON;

# Collect Variables From Input JSON
ML_HOST_CONNECTION=` echo $INPUT_JSON | jq -c '.["ml-host-connection"]' `

HOST=` echo $ML_HOST_CONNECTION | jq -r -c '.host' | tr -d \" `
USERPW=` echo $ML_HOST_CONNECTION | jq -r -c '.userpw' `

HEADER="Content-Type:application/json"

COMMAND=$(cat <<EOF
	curl -s \
	--anyauth \
	-H $HEADER \
	-u $USERPW \
	'http://${HOST}:8002/manage/v2/hosts?format=json'
EOF
)

COMMAND_64=` echo $COMMAND | base64 --wrap=0 `
echo $COMMAND_64
