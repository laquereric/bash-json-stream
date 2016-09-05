#!/bin/bash +x

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
	CL_DATABASE_NAMEREF_EXIST=` \
		echo $CL_ARGUMENTS | \
		jq -r -c '.["database-nameref"] | length' \
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

if [[ $CL_DATABASE_NAMEREF_EXIST > 0 ]]; then
	DATABASE_NAMEREF=` \
		echo $CL_ARGUMENTS | \
		jq -r -c '.["database-nameref"]' \
	`
else
	echo "Must pass database-nameref to ml-purge-databsse"
	exit
fi

DATABASE_RECORD=`
	echo $SERVICE_HOST_CONTEXT |
	jq -r -c '.["resources"] | .["database-default-list"] | .["list-items"] | .["list-item"] | .[]? ' | \
	jq -r -c --arg NR "^${DATABASE_NAMEREF}\$" '.|select(.nameref|tostring|test($NR))' \
`

DATABASE_PROPERTIES=` \
	echo $SERVICE_HOST_CONTEXT | \
	jq -r -c '.["ml-host-connection"]' | \
	jq -s '.[0]|{"ml-host-connection":.}' | \
	jq  -r -c --arg NM $DATABASE_NAMEREF '.+{"name":$NM}' | \
	jq  -r -c --arg RT "databases" '.+{"resource-type":$RT}' | \
	jq  -r -c '.+{"parameters":{"format":"json"}}' | \
	./manage-v2/manage-v2-resource-get-properties-curl-command.bash | \
	jq  -r -c '.["command-64"]' | \
	base64 -d | \
	xargs -i -t sh -c "{}" | \
	jq -R -r -c 'tojson'
`
FOREST_NAMEREFS=`
	echo $SERVICE_HOST_CONTEXT | \
	jq -r -c '.|to_entries|.[]|.key' \
`
echo $FOREST_NAMEREFS
