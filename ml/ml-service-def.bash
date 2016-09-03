#!/bin/bash

DEFAULT_ARGUMENTS=`
		jq -n -r -c '{"name":"TEST","port":"9000"}'\
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

ML_SERVICE_DEF=` \
	jq -n -r -c --argjson ARGS $ARGUMENTS '{"ml-service-def":$ARGS}' \
`

echo $ML_SERVICE_DEF