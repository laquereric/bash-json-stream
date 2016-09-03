#!/bin/bash

DEFAULT_ML_CONNECTION=`echo '{}' | \
	./ml-host-connection.bash
`

DEFAULT_SERVICE_DEF=`
		jq -n -r -c '{"name":"TEST8","port":"8035"}'\
`

DEFAULT_ARGUMENTS=`
	jq -n -r -c --argjson DMC $DEFAULT_ML_CONNECTION '{"ml-host-connection":$DMC}' |\
	jq -r -c --argjson DSD $DEFAULT_SERVICE_DEF '.+{"service-def":$DSD}' \
`

echo $DEFAULT_ARGUMENTS
exit

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

SERVICE_CONNECTION=` \
	jq -n -r -c --argjson ARGS $ARGUMENTS '{"ml-service-host":$ARGS}' \
`

echo $SERVICE_CONNECTION