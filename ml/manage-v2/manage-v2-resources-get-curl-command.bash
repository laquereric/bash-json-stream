#!/bin/bash +x

# see : https://docs.marklogic.com/REST/POST/manage/v2/[RESOURCE TYPE]

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

PARAMETER_OBJECT_EXISTS=` \
	echo $INPUT_JSON | \
	jq -r -c '.["parameters"]|length' \
`

PARAMETERS_OBJECT=` \
	echo $INPUT_JSON | \
	jq -r -c '.["parameters"]' \
`

if [[ $PARAMETER_OBJECT_EXISTS > 0 ]]; then
	PS=` echo $PARAMETERS_OBJECT | \
		jq -j -r -c 'to_entries | .[] | "\(.key)=\(.value)&" ' \
	`
	PARAMETERS_STRING=` echo "?${PS%?}" `
fi

PROPERTIES=` \
	echo $INPUT_JSON | \
	jq -r -c '.properties' \
`

HEADER="Content-Type:application/json"

COMMAND=$(cat <<EOF
	curl -s \
	--anyauth
	-u $USERPW \
	-H "$HEADER" \
	'http://${HOSTURL}:8002/manage/v2/${RESOURCE_TYPE}/${PARAMETERS_STRING}'
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
