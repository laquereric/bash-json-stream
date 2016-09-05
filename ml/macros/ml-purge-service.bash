#!/bin/bash

CL_SERVICE_HOST_CONTEXT_EXIST=0
CL_SERVER_NAMEREF_EXIST=0

while read -r LINE; do
	CL_ARGUMENTS=` \
		echo $LINE | \
		jq -r -c '.' \
	`
	CL_SERVICE_HOST_CONTEXT_EXIST=` \
		echo $CL_ARGUMENTS | \
		jq -r -c '.["service-host-context"] | length' \
	`
	CL_SERVER_NAMEREF_EXIST=` \
		echo $CL_ARGUMENTS | \
		jq -r -c '.["server-nameref"] | length' \
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
		./ml-service-host-context.bash | \
		jq -r -c '.["service-host-context"]'
	`
fi


if [[ $CL_SERVER_NAMEREF_EXIST > 0 ]]; then
	SERVER_NAMEREF=` \
		echo $CL_ARGUMENTS | \
		jq -r -c '.["server-nameref"]' \
	`
else
	echo "Must pass server-nameref to ml-purge-service"
	exit
fi

SERVER_RECORD=`
	echo $SERVICE_HOST_CONTEXT |
	jq -r -c '.["resources"] | .["server-default-list"] | .["list-items"] | .["list-item"] | .[]?' | \
	jq -r -c --arg NR "^${SERVER_NAMEREF}\$" '.|select(.nameref|tostring|test($NR))'
`
CONTENT_DB=`echo $SERVER_RECORD | jq -r -c '.["content-db"]'`

PURGE_SERVICE_RESULTS=`
	echo $CONTENT_DB
`

echo $PURGE_SERVICE_RESULTS
