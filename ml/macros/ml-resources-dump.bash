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

BASE=` \
	jq  -n -r -c '{}' | \
	jq  -r -c '.+{parameters":{"format":"json"}}' \
	jq  -r -c --argjson MHC $ML_HOST_CONNECTION '.+$MHC' \
`

SERVERS=` \
	jq  -n -r -c '{}' | \
	jq  -r -c --argjson BS $BASE '.+$BS' | \
	jq  -r -c --arg RT "servers" '{"resource-type":$RT}' | \
	./manage-v2/manage-v2-resources-get-curl-command.bash | \
	jq  -r -c '.["command-64"]' | \
	base64 --decode \
	eval $SERVERS_COMMAND | \
	jq -R -r -c 'tojson'
`

DATABASES=` \
	jq  -n -r -c '{}' | \
	jq  -r -c --argjson BS $BASE '.+$BS' | \
	jq  -r -c --arg RT "databases" '{"resource-type":$RT}' | \
	./manage-v2/manage-v2-resources-get-curl-command.bash | \
	jq  -r -c '.["command-64"]' | \
	base64 --decode | \
	xargs -i -t sh -c "{}" | \
	jq -R -r -c 'tojson'
`

FORESTS=` \
	jq  -n -r -c '{}' | \
	jq  -r -c --argjson BS $BASE '.+$BS' | \
	jq  -r -c --arg RT "forests" '{"resource-type":$RT}' | \
	./manage-v2/manage-v2-resources-get-curl-command.bash | \
	jq  -r -c '.["command-64"]' | \
	base64 --decode | \
	xargs -i -t sh -c "{}" | \
	jq -R -r -c 'tojson'
`

DUMP=` \
	jq  -n -r -c '{}' | \
	jq  -r -c --argjson SV $SERVERS '.+$SV' | \
	jq  -r -c --argjson DB $DATABASES '.+$DB' | \
	jq  -r -c --argjson FS $FORESTS '.+$FS' \
`

echo $DUMP
