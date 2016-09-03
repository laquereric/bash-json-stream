#!/bin/bash
# Accepts a HOST URL and a User:Password
# Contacts the host and parses the response

# Collect Attributes
HOST=$1
USERPW=$2

ML_HOST_CONNECTION=` \
	jq -n -r -c --arg HT $HOST '{"host":$HT}' | \
	jq -r -c --arg UP $USERPW '.+{"userpw":$UP}' \
`

HOSTS_GET_DEF=` \
	jq -n -r -c --argjson MHC $ML_HOST_CONNECTION '{"ml-host-connection":$MHC}' \
`

COMMAND=` \
	echo $HOSTS_GET_DEF | \
	./manage-v2-hosts-get-curl-command.bash | \
	base64 --decode \
`

# Run Command
CLUSTER=`eval $COMMAND | jq -r -c '.'`

HOSTS=` \
	echo $CLUSTER | \
	jq -r -c '.["host-default-list"] | \
	.["list-items"] | \
	.["list-item"]' \
`

BOOTSTRAP_HOST_ID=` \
	echo $HOSTS | \
	jq -r -c '.[] | \
	select(.roleref=="bootstrap") | \
	.idref' \
`

OUTPUT_JSON=` \
	jq -n -r -c --argjson MHC $ML_HOST_CONNECTION '.+{"ml-host-connection":$MHC}' | \
	jq -r -c --argjson BSHI $BOOTSTRAP_HOST_ID '.+{"bootstrap-host-id":$BSHI}' \
`

echo $OUTPUT_JSON
