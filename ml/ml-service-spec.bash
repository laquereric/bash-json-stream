#!/bin/bash

DEFAULT_ML_CONNECTION=`echo '{}' | \
	./ml-host-connection.bash
`

DEFAULT_SERVICE_DEF=`
		echo '{}' | \
		./ml-service-def.bash
`

DEFAULT_ARGUMENTS=`
	jq -n -r -c --argjson DMC $DEFAULT_ML_CONNECTION '{"ml-host-connection":$DMC}' |\
	jq -r -c --argjson DSD $DEFAULT_SERVICE_DEF '.+{"service-def":$DSD}' \
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

ML_SERVICE_SPEC=` \
	jq -n -r -c --argjson ARGS $ARGUMENTS '{"ml-service-spec":$ARGS}' \
`

echo $ML_SERVICE_SPEC
