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

ML_HOST_CONNECTION=`
	echo $ARGUMENTS | \
	jq -r -c '.["ml-service-spec"] | .["ml-host-connection"] | {"ml-host-connection":.}'
`

ML_SERVICE_HOST_CONTEXT=` \
	echo $ML_HOST_CONNECTION | \
	./ml-resources-dump.bash | \
	jq -r -c '.|{"resources":.}' | \
	jq -r -c --argjson MLH $ML_HOST_CONNECTION '.+{"ml-host-connection":$MLH}' \
`

echo $ML_SERVICE_HOST_CONTEXT
exit

#
#BOOTSTRAP_HOST_ID=` \
#	echo $HOSTS | \
#	jq -r -c '.[] | \
#	select(.roleref=="bootstrap") | \
#	.idref' \
#`