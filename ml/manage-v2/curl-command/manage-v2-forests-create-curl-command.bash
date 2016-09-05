#!/bin/bash

# see https://docs.marklogic.com/REST/POST/manage/v2/forests

read JSON_IN;

BOOSTRAP_HOST_ID=` echo $JSON_IN | jq -r -c '.["bootstrap-host"] | .idref' `

# Collect Variables From Input JSON
PROPERTIES_JSON=` echo $JSON_IN | jq -c '.properties' | jq -c '{properties:.}'`

HOSTURL=` echo $JSON_IN | jq -r -c '.host'| tr -d \" `
USERPW=` echo $JSON_IN | jq -r -c '.userpw'| tr -d \" `

TARGET_HOST=` echo $JSON_IN | jq -r -c '.["target-host"]'| tr -d \" `

DATABASE_NAME=` echo $JSON_IN | jq -r -c '.["database-name"]' `
DATA_JSON=`echo $JSON_IN | jq -r -c '. | del(.properties) | del(.host) | del(.["target-host"]) | del(.["database-name"]) | del(.userpw)' | jq -r -c --arg DN $DATABASE_NAME '.+{"database":$DN}' | jq -r -c --arg HST $TARGET_HOST '.+{"host":$HST}'`
# | .+{root:'\'
 
HEADER="Content-Type:application/json"

COMMAND=$(cat <<EOF
	curl \
	--anyauth
	-u $USERPW \
	-H "$HEADER" \
	-d '${DATA_JSON}' \
	'http://${HOSTURL}:8002/manage/v2/forests'
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
