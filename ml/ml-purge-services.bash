#!/bin/bash

CL_SERVICE_HOST_CONTEXT_EXIST=0
CL_SERVER_NAMEREFS_EXIST=0

while read -r LINE; do
	CL_ARGUMENTS=` \
		echo $LINE | \
		jq -r -c '.' \
	`
	CL_SERVICE_HOST_CONTEXT_EXIST=` \
		echo $CL_ARGUMENTS | \
		jq -r -c '.["service-host-context"] | length' \
	`
	CL_SERVER_NAMEREFS_EXIST=` \
		echo $CL_ARGUMENTS | \
		jq -r -c '.["server-namerefs"] | length' \
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

if [[ $CL_SERVER_NAMEREFS_EXIST > 0 ]]; then
	SERVER_NAMEREFS=` \
		echo $CL_ARGUMENTS | \
		jq -r -c '.["server-namerefs"]' \
	`
else
	SERVER_NAMEREFS=` \
		echo {} | \
		./ml-server-namerefs.bash | \
		jq '.[]|to_entries|.[0].value|select(.|tostring|.[0:4]=="TEST")|{"server-nameref":.}' | \
		jq -s -r -c '.'\
	`
fi

CL_SERVER_NAMEREFS_EXIST=` \
	echo $CL_ARGUMENTS | \
		jq -r -c '.["server-namerefs"] | length' \
	`

if [[ $CL_SERVER_NAMEREFS_EXIST > 0 ]]; then
	SERVER_NAMEREFS=` \
		echo $CL_ARGUMENTS | \
		jq -r -c '.["server-namerefs"]' \
	`
else
	SERVER_NAMEREFS=` \
		echo $SERVICE_HOST_CONTEXT | \
		./ml-server-namerefs.bash | \
		jq '.[]|to_entries|.[0].value|select(.|tostring|.[0:4]=="TEST")|{"server-nameref":.}' | \
		jq -s -r -c '.'\
	`
fi

echo $SERVER_NAMEREFS
exit
