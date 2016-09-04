#!/bin/bash

CL_SERVICE_HOST_CONTEXT_EXIST=0

while read -r LINE; do
	CL_ARGUMENTS=` \
		echo $LINE | \
		jq -r -c '.' \
	`
	CL_SERVICE_HOST_CONTEXT_EXIST=` \
		echo $CL_ARGUMENTS | \
		jq -r -c '.["service-host-context"] | length' \
	`
done

if [[ $CL_SERVICE_HOST_CONTEXT_EXIST > 0 ]]; then
	SERVICE_HOST_CONTEXT=` \
		echo $CL_ARGUMENTS | \
		jq -r -c '.["service-host-context"]' \
	`
else
	SERVICE_HOST_CONTEXT=` \
		echo {} | \
		./ml-service-host-context.bash
	`
fi

SERVER_LIST=` \
	echo $SERVICE_HOST_CONTEXT | \
	jq -r -c '.resources|.["server-default-list"]|.["list-items"]|.["list-item"]|.[]?|{"server-nameref":.nameref}' | \
	jq -s '.'
`

echo $SERVER_LIST
#jq -r -c '.|.["resources"]|.["server-default-list"]|.["list-items"]|.["list-item"]|.[]|.["nameref"]' \

#"server-default-list"
#"database-default-list"
#"forest-default-list"

