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

ML_HOST_CONNECTION=` \
	echo $SERVICE_HOST_CONTEXT \
`
#| \ jq -r -c '.["ml-host-connection"]'

echo $ML_HOST_CONNECTION
exit

DATABASE_GP_DEF=` \
	jq  -n -r -c --arg NM $DATABASE_NAMEREF '{"name":$NM}' | \
	jq  -r -c --arg RT "databases" '.+{"resource-type":$RT}' | \
	jq  -r -c --argjson MHC $ML_HOST_CONNECTION '.+{"ml-host-connection":$MHC}' | \
	jq  -r -c --argjson PR $DEPLOY_LC_PROMPT_64 '.+{"properties":$PR}' | \
	jq  -r -c --argjson D $DEPLOY_LC_DATA '.+{"data":$D}' \
`
DATABASE_PROPERTIES=``
CMDS+=(` \
	echo $DEPLOY_LC_DEF | \
	./manage-v2-resource-change-properties-curl-command.bash \
`)
`

echo $DATABASE_RECORD	

echo $PURGE_SERVICE_RESULTS
