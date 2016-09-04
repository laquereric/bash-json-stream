#!/bin/bash

DEFAULT_ARGUMENTS=` \
	echo {} | \
	./ml-service-host-context.bash
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

ML_SERVICE_HOST_CONTEXT=$ARGUMENTS

SERVER_LIST=` \
	echo $ML_SERVICE_HOST_CONTEXT | \
	jq -r -c '.resources|.["server-default-list"]|.["list-items"]|.["list-item"]|.[]?|{"server-nameref":.nameref}' | \
	jq -s '.'
`

echo $SERVER_LIST
#jq -r -c '.|.["resources"]|.["server-default-list"]|.["list-items"]|.["list-item"]|.[]|.["nameref"]' \

#"server-default-list"
#"database-default-list"
#"forest-default-list"

