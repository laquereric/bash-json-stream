#!/bin/bash

DEFAULT_ARGUMENTS=`echo '{}' | \
	./ml-service-spec.bash
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


#COMMAND=` \
#	echo $HOSTS_GET_DEF | \
#	./manage-v2-hosts-get-curl-command.bash | \
#	base64 --decode \
#`

# Run Command
#CLUSTER=`eval $COMMAND | jq -r -c '.'`
CLUSTER=`jq -n -r -c '{}'`
#
ML_SERVICE_HOST_CONTEXT=` \
	jq -n -r -c --argjson ARGS $ARGUMENTS '{"ml-service-host-context":$ARGS}' | \
	jq -r -c --argjson CL $CLUSTER '.+{"cluster":$CL}' \
`

echo $ML_SERVICE_HOST_CONTEXT