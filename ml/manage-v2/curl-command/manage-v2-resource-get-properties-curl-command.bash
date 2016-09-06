#!/bin/bash
# see : https://docs.marklogic.com/REST/POST/manage/v2/[RESOURCE TYPE]

while read -r LINE; do
	CL_ARGUMENTS=` \
		echo $LINE | \
		jq -r -c '.' \
	`
done

NAME=` echo $CL_ARGUMENTS | jq -r -c '.name' | tr -d \" `

CL_ENVIRONMENT=` \
	echo $CL_ARGUMENTS | \
	./util/command-line-parser.bash | \
	jq -r -c --arg NM $NAME '.+{"name":$NM}' \
`

USERPW=`echo $CL_ENVIRONMENT | jq '.userpw' | tr -d \" `
HOSTURL=`echo $CL_ENVIRONMENT | jq '.hosturl' | tr -d \" `
HEADER=`echo $CL_ENVIRONMENT | jq '.header' | tr -d \" `
RESOURCE_TYPE=`echo $CL_ENVIRONMENT | jq '.["resource-type"]' | tr -d \" `
PARAMETERS_STRING=`echo $CL_ENVIRONMENT | jq 'if .["parameters-string"] then .["parameters-string"] else "" end' `
URL=`echo "'http://${HOSTURL}:8002/manage/v2/${RESOURCE_TYPE}/${NAME}/properties${PARAMETERS_STRING}'" | tr -d \" `

COMMAND=$(cat <<EOF
	curl -s \
	--anyauth
	-u ${USERPW} \
	-H "$HEADER" \
	${URL}
EOF
)

JSON_OUTPUT=` \
	echo $COMMAND | \
	base64 --wrap=0 | \
	jq -c -R '{"command-64":.}' \
`

#Return Output
echo $JSON_OUTPUT
