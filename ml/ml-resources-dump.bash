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

DATABASES_RESPONSE=` \
	eval $DATABASES_COMMAND | \
	jq -R -r -c 'tojson'
`

##############

SERVERS_COMMAND_DEF=` \
	jq  -n -r -c --arg RT "servers" '{"resource-type":$RT}' | \
	jq  -r -c --argjson MHC $ML_HOST_CONNECTION '.+$MHC' | \
	jq  -r -c --argjson PM $PARAMETERS '.+{"parameters":$PM}' \
`

SERVERS_COMMAND=` \
	echo $SERVERS_COMMAND_DEF | \
	./manage-v2/manage-v2-resources-get-curl-command.bash | \
	jq  -r -c '.["command-64"]' | \
	base64 --decode \
`

SERVERS_RESPONSE=` \
	eval $SERVERS_COMMAND | \
	jq -R -r -c 'tojson'
`

##############
#
RESOURCES_DUMP=` \
	echo $SERVERS_RESPONSE \
`
#echo $DATABASES_RESPONSE \
#jq -r -c --argjson SR $SERVERS_RESPONSE '.+$SR' \

echo $RESOURCES_DUMP

