#!/bin/bash

NAME=$1
BASEPORT=$2

# Read ML Host from pipeline
read JSON_IN;

ML_HOST_CONNECTION=` \
	echo $JSON_IN | \
	jq -r -c '.["ml-host-connection"]' \
`

BOOSTRAP_HOST_ID=` \
	echo $JSON_IN | \
	jq -r -c '.["bootstrap-host-id"]' \
`

TARGET_HOST_ID=BOOSTRAP_HOST_ID

CMDS=()

DUMP_PROMPT_64=` \
	echo "echo Getting database data" | \
	base64 --wrap=0 | \
	jq -R -r -c '{"prompt-64":.}' \
`

DUMP_DATA=` \
	jq -n -r -c '{}' \
`

DATABASE_RESOURCE="databases"

DATABASES_DEF_64=` \
	jq  -n -r -c --arg RT $DATABASE_RESOURCE '.+{"resource-type":$RT}' | \
	jq  -r -c --argjson MHC $ML_HOST_CONNECTION '.+{"ml-host-connection":$MHC}' | \
	jq  -r -c --argjson PR $DUMP_PROMPT_64 '.+{"properties":$PR}' | \
	jq  -r -c --argjson D $DUMP_DATA '.+{"data":$D}' |
	base64 --wrap=0 \
`

DATABASES_CALL=` \
	jq  -n -r -c --arg DD $DATABASES_DEF_64 '{"call-def":$DD}' | \
	jq  -r -c --arg CN './manage-v2-resources-get-curl-command.bash' '.+{"call":$CN}' \
`

CMDS+=($DATABASES_CALL)

printf '%s\n' "${CMDS[@]}"

