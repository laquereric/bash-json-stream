#!/bin/bash

CL_SERVER_NAMEREFS_EXIST=0

while read -r LINE; do
	CL_ARGUMENTS=` \
		echo $LINE | \
		jq -r -c '.' \
	`
	CL_SERVER_NAMEREFS_EXIST=` \
		echo $CL_ARGUMENTS | \
		jq -r -c '.["server-namerefs"] | length' \
	`
done

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

echo $SERVER_NAMEREFS
exit
