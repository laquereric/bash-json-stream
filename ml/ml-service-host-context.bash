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

#echo $ARGUMENTS
#exit

ML_HOST_CONNECTION=`
	echo $ARGUMENTS | \
	jq -r -c '.["ml-service-spec"]'
`

PARAMETERS=` \
	jq -n -r -c '{"format":"json"}' \
`

COMMAND_DEF=` \
	jq  -n -r -c --arg RT "databases" '{"resource-type":$RT}' | \
	jq  -r -c --argjson MHC $ML_HOST_CONNECTION '.+$MHC' | \
	jq  -r -c --argjson PM $PARAMETERS '.+{"parameters":$PM}' \
`

COMMAND=` \
	echo $COMMAND_DEF | \
	./manage-v2/manage-v2-resources-get-curl-command.bash | \
	jq  -r -c '.["command-64"]' | \
	base64 --decode \
`

# Run Command
RESPONSE=`eval $COMMAND`
CLUSTER=` \
	echo $RESPONSE | \
	jq -R -r -c 'tojson'`
echo $CLUSTER
exit


#CLUSTER=`jq -n -r -c '{}'`
#
#HOSTS=` \
#	echo $CLUSTER | \
#	jq -r -c '.["host-default-list"] | \
#	.["list-items"] | \
#	.["list-item"]' \
#`
#
#BOOTSTRAP_HOST_ID=` \
#	echo $HOSTS | \
#	jq -r -c '.[] | \
#	select(.roleref=="bootstrap") | \
#	.idref' \
#`

#ML_SERVICE_HOST_CONTEXT=` \
#	jq -n -r -c --argjson ARGS $ARGUMENTS '{"ml-service-host-context":$ARGS}' | \
#	jq -r -c --argjson CL $CLUSTER '.+{"cluster":$CL}' \
#`
#
#echo $ML_SERVICE_HOST_CONTEXT