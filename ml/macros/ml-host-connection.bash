#!/bin/bash
# Accepts a HOST URL and a User:Password
# Contacts the host and parses the response

CL_ML_HOST_CONNECTION_EXIST=0

while read -r LINE; do
	CL_ARGUMENTS=` \
		echo $LINE | \
		jq -r -c '.' \
	`
	CL_ML_HOST_CONNECTION_EXIST=` \
		echo $CL_ARGUMENTS | \
		jq -r -c '.["ml-host-connection"] | length' \
	`
done

VALUES=` \
	jq -n -r -c '{"host":"localhost","userpw":"admin:admin"}' \
`

if [[ $CL_ML_HOST_CONNECTION_EXIST > 0 ]]; then
	VALUES=` \
		echo $CL_ARGUMENTS | \
		jq -r -c '.["ml-host-connection"]' | \
		jq -r -c --argjson DV $VALUES '$DV+.' \
	`
fi

RESULT=`
	jq -n -r -c --argjson CLA $CL_ARGUMENTS '$CLA' | \
	jq -r -c --argjson VL $VALUES '.+{"ml-host-connection":$VL}'
`

echo $RESULT
