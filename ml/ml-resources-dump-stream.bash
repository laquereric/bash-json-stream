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
DUMPS=()
PARAMETERS=` \
	jq -n -r -c '{"format":"json"}' \
`

#####################

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
DUMPS+=(` \
	eval $SERVERS_COMMAND | \
	jq -R -r -c 'tojson'
`)

##############

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

DUMPS+=(` \
	eval $DATABASES_COMMAND | \
	jq -R -r -c 'tojson'
`)

##############

FORESTS_COMMAND_DEF=` \
	jq  -n -r -c --arg RT "forests" '{"resource-type":$RT}' | \
	jq  -r -c --argjson MHC $ML_HOST_CONNECTION '.+$MHC' | \
	jq  -r -c --argjson PM $PARAMETERS '.+{"parameters":$PM}' \
`

FORESTS_COMMAND=` \
	echo $FORESTS_COMMAND_DEF | \
	./manage-v2/manage-v2-resources-get-curl-command.bash | \
	jq  -r -c '.["command-64"]' | \
	base64 --decode \
`

DUMPS+=(` \
	eval $FORESTS_COMMAND | \
	jq -R -r -c 'tojson'
`)

printf '%s ' "${DUMPS[@]}"

