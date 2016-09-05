#!/bin/bash

while read -r LINE; do
	CL_ARGUMENTS=` \
		echo $LINE | \
		jq -r -c '.'
	`
	CL_ML_HOST_CONNECTION_EXIST=` \
		echo $CL_ARGUMENTS | \
		jq -r -c '.["ml-host-connection"] | length' \
	`
	CL_ML_RESOURCE_TYPE_EXIST=` \
		echo $CL_ARGUMENTS | \
		jq -r -c '.["resource-type"] | length' \
	`
done

if [[ $CL_ML_HOST_CONNECTION_EXIST > 0 ]]; then
	ML_HOST_CONNECTION=` \
		echo $CL_ARGUMENTS | \
		jq -r -c '.["ml-host-connection"]' | \
		jq -r -c '{"ml-host-connection":.}' \
	`
else
	ML_HOST_CONNECTION=` \
		echo {} | \
		./ml-service-host-context.bash
	`
fi

if [[ $CL_ML_RESOURCE_TYPE_EXIST > 0 ]]; then
	RESOURCE_TYPE=` \
		echo $CL_ARGUMENTS | \
		jq -r -c '.["resource-type"]' \
	`
else
	echo "Must pass resource-type to ml-recource-type-get"
	exit
fi

RESULT=` \
	jq  -n -r -c '{}' | \
	jq  -r -c '.+{parameters":{"format":"json"}}' \
	jq  -r -c --argjson MHC $ML_HOST_CONNECTION '.+$MHC' \
	jq  -r -c --arg RT RESOURCE_TYPE '{"resource-type":$RT}' | \
	./manage-v2/manage-v2-resources-get-curl-command.bash | \
	jq  -r -c '.["command-64"]' | \
	base64 --decode \
	eval $SERVERS_COMMAND | \
	jq -R -r -c 'tojson'
`

echo $RESULT
