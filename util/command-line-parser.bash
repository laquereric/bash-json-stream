#!/bin/bash

while read -r LINE; do
	CL_ARGUMENTS=` \
		echo $LINE | \
		jq -r -c '.' \
	`
done

CL_ENVIRONMENT=`
	jq -n -r -c '{}' \
`

###

RESOURCE_TYPE="servers"

CL_ML_RESOURCE_TYPE_EXIST=` \
	echo $CL_ARGUMENTS | \
	jq -r -c '.["resource-type"] | length' \
`

if [[ $CL_ML_RESOURCE_TYPE_EXIST > 0 ]]; then
	RESOURCE_TYPE=` \
		echo $CL_ARGUMENTS | \
		jq -r -c '.["resource-type"]' \
	`
fi

CL_ENVIRONMENT=`
	echo $CL_ENVIRONMENT | \
	jq -r -c --arg RT $RESOURCE_TYPE '.+{"resource-type":$RT}' \
`

###

CL_ML_HOST_CONNECTION_EXIST=` \
	echo $CL_ARGUMENTS | \
	jq -r -c '.["ml-host-connection"] | length' \
`

if [[ CL_ML_HOST_CONNECTION_EXIST > 0 ]]; then
	ML_HOST_CONNECTION_SOURCE=` \
		echo $CL_ARGUMENTS | \
		jq -r -c '.["ml-host-connection"]' |
		jq -r -c '{"ml-host-connection":.}'\
	`
else
	ML_HOST_CONNECTION_SOURCE=` \
		jq -r -c '{}' \
	`
fi

ML_HOST_CONNECTION=` \
	echo $ML_HOST_CONNECTION_SOURCE | \
	./ml/macros/ml-host-connection.bash \
`

HOSTURL=` \
	echo $ML_HOST_CONNECTION | \
	jq -r -c '.["ml-host-connection"]|.host' \
`

USERPW=` \
	echo $ML_HOST_CONNECTION | \
	jq -r -c '.["ml-host-connection"]|.userpw' \
`

CL_ENVIRONMENT=`
	echo $CL_ENVIRONMENT | \
	jq -r -c --arg HS $HOSTURL '.+{"hosturl":$HS}' | \
	jq -r -c --arg UP $USERPW '.|.+{"userpw":$UP}' \
`

###

CL_PARAMETER_OBJECT_EXISTS=` \
	echo $CL_ARGUMENTS | \
	jq -r -c '.["parameters"] | length' \
`

if [[ $CL_PARAMETER_OBJECT_EXISTS > 0 ]]; then
	PS=` \
		echo $CL_ARGUMENTS | \
		jq -r -c '.["parameters"]' \
		jq -j -r -c 'to_entries | .[] | "\(.key)=\(.value)&" ' \
	`
	PARAMETERS_STRING=` echo "?${PS%?}" `
	CL_ENVIRONMENT=` \
		echo $CL_ENVIRONMENT | \
		jq -r -c --arg PSS $PARAMETERS_STRING '.+{"parameters-string":$PSS}' \
	`
fi

###

HEADER="Content-Type:application/json"

CL_ENVIRONMENT=`
	echo $CL_ENVIRONMENT | \
	jq -r -c --arg HD $HEADER '.+{"header":$HD}'  \
`

echo $CL_ENVIRONMENT
