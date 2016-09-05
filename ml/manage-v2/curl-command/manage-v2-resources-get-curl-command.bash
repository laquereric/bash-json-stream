#!/bin/bash +x

# see : https://docs.marklogic.com/REST/POST/manage/v2/[RESOURCE TYPE]

while read -r LINE; do
	CL_ARGUMENTS=` \
		echo $LINE | \
		jq -r -c '.' \
	`
	CL_ML_HOST_CONNECTION_EXIST=` \
		echo $CL_ARGUMENTS | \
		jq -r -c '.["ml-host-connection"] | length' \
	`
	CL_ML_RESOURCE_TYPE_EXIST=` \
		echo $CL_ARGUMENTS | \
		jq -r -c '.["resource-type"] | length' \
	`
	CL_PARAMETER_OBJECT_EXISTS=` \
		echo $CL_ARGUMENTS | \
		jq -r -c '.["parameters"] | length' \
#`
done

RESOURCE_TYPE="servers"

if [[ $CL_ML_RESOURCE_TYPE_EXIST > 0 ]]; then
	RESOURCE_TYPE=` \
		echo $CL_ARGUMENTS | \
		jq -r -c '.["resource-type"]' \
	`
fi

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

##########################

HOSTURL=` \
	echo $ML_HOST_CONNECTION | \
	jq -r -c '.["ml-host-connection"]|.host' \
`

USERPW=` \
	echo $ML_HOST_CONNECTION | \
	jq -r -c '.["ml-host-connection"]|.userpw' \
`

if [[ $CL_PARAMETER_OBJECT_EXISTS > 0 ]]; then
	PS=` \
		echo $CL_ARGUMENTS | \
		jq -r -c '.["parameters"]' \
		jq -j -r -c 'to_entries | .[] | "\(.key)=\(.value)&" ' \
	`
	 echo "?${PS%?}"
else
	PARAMETERS_STRING=""
fi

HEADER="Content-Type:application/json"

COMMAND=$(cat <<EOF
	curl -s \
	--anyauth
	-u $USERPW \
	-H "$HEADER" \
	'http://${HOSTURL}:8002/manage/v2/${RESOURCE_TYPE}${PARAMETERS_STRING}'
EOF
)

JSON_OUTPUT=` \
	echo $COMMAND | \
	base64 --wrap=0 | \
	jq -c -R '{"command-64":.}' \
`

#Return Output
echo $JSON_OUTPUT
