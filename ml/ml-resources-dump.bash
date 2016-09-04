#!/bin/bash

DEFAULT_ARGUMENTS=`echo '{}' | \
	./ml-host-connection.bash
`

while read -r LINE; do
	CL_ARGUMENTS=` \
		echo $LINE | \
		jq -r -c '.'
	`
done

ARGUMENTS=` \
	echo $DEFAULT_ARGUMENTS | \
	jq -r -c --argjson CLA $CL_ARGUMENTS '.|.+$CLA' \
`

ML_HOST_CONNECTION=$ARGUMENTS

PARAMETERS=` \
	jq -n -r -c '{"format":"json"}' \
`

DATABASES_COMMAND_DEF=` \
	jq  -n -r -c --arg RT "databases" '{"resource-type":$RT}' | \
	jq  -r -c --argjson MHC $ML_HOST_CONNECTION '.+$MHC' | \
	jq  -r -c --argjson PM $PARAMETERS '.+{"parameters":$PM}' \
`

DATABASES_COMMAND=` \
	echo $DATABASES_COMMAND_DEF | \
	./manage-v2/manage-v2-resources-get-curl-command.bash | \
	jq  -r -c '.["command-64"]' | \
	base64 --decode \
`

DATABASES_RESPONSE=`eval $DATABASES_COMMAND`

RESOURCES_DUMP=` \
	echo $DATABASES_RESPONSE | \
	jq -R -r -c 'tojson' | \
	jq -r -c '{"databases":.}' \
`

echo $RESOURCES_DUMP

