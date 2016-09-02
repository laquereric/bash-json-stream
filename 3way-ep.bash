#!/bin/bash +x

NAME=$1
BASEPORT=$2

# Read ML Host from pipeline
read JSON_IN;

ML_HOST_CONNECTION=` \
	echo $JSON_IN | \
	jq -r -c '.["ml-host-connection"]' \
`

BOOSTRAP_HOST_ID=` \
	echo $JSON_IN | \
	jq -r -c '.["bootstrap-host-id"]' \
`

TARGET_HOST_ID=BOOSTRAP_HOST_ID

CMDS=()

# Create DEPLOY Server

DEPLOY_SERVER_NAME="$NAME-Deploy"
DEPLOY_SERVER_PORT=$(($BASEPORT+2))

DEPLOY_PROMPT_64=` \
	echo "echo Creating $DEPLOY_SERVER_NAME Server" | tr -d \" | \
	base64 --wrap=0 | \
	jq -R -r -c '{"prompt-64":.}' \
`

DEPLOY_REST_API=` \
	jq -n -r -c --arg SN $DEPLOY_SERVER_NAME '{"name":$SN} ' | \
	jq -r -c --arg PT $DEPLOY_SERVER_PORT '.+{"port":$PT}' | \
	jq -r -c '.+{"forests-per-host":1}' | \
	jq -r -c '.+{"modules-database":"Modules"}' \
`

DEPLOY_DEF=` \
	jq  -n -r -c --argjson MHC $ML_HOST_CONNECTION '{"ml-host-connection":$MHC}' | \
	jq  -r -c --argjson PR $DEPLOY_PROMPT_64 '.+{"properties":$PR}' | \
	jq  -r -c --argjson DRA $DEPLOY_REST_API '.+{"rest-api":$DRA}' \
`

CMDS+=(` \
	echo $DEPLOY_DEF | \
	./manage-v1-rest-api-create-curl-command.bash \
`)

# To be USED by Module Server
DEPLOY_DATABASE_NAME=$DEPLOY_SERVER_NAME
DEPLOY_LC_PROMPT_64=` \
	echo "echo Setting Collection Lexicon for $DEPLOY_DATABASE_NAME" | \
	base64 --wrap=0 | \
	jq -R -r -c '{"prompt-64":.}' \
`

DEPLOY_LC_DATA=` \
	jq -n -r -c '{"collection-lexicon":true}' \
`

DEPLOY_LC_DEF=` \
	jq  -n -r -c --arg NM $DEPLOY_DATABASE_NAME '{"name":$NM}' | \
	jq  -r -c --arg RT "databases" '.+{"resource-type":$RT}' | \
	jq  -r -c --argjson MHC $ML_HOST_CONNECTION '.+{"ml-host-connection":$MHC}' | \
	jq  -r -c --argjson PR $DEPLOY_LC_PROMPT_64 '.+{"properties":$PR}' | \
	jq  -r -c --argjson D $DEPLOY_LC_DATA '.+{"data":$D}' \
`

CMDS+=(` \
	echo $DEPLOY_LC_DEF | \
	./manage-v2-resource-change-properties-curl-command.bash \
`)

# To be USED by Module Server
DEPLOY_DB_NAME="$DEPLOY_SERVER_NAME-modules"
#

# Create MODULES Server
MODULES_SERVER_NAME="$NAME-Modules"
MODULES_SERVER_PORT=$(($BASEPORT+1))

MODULES_PROMPT_64=` \
	echo "echo Creating $MODULES_SERVER_NAME Server" | tr -d \" | \
	base64 --wrap=0 | \
	jq -R -r -c '{"prompt-64":.}' \
`

MODULES_REST_API=` \
	jq -n -r -c --arg SN $MODULES_SERVER_NAME '.+{"name":$SN} | .+{"forests-per-host":1}' | \
	jq -r -c --arg CN $DEPLOY_DB_NAME '.+{"modules-database":$CN}' | \
	jq -r -c --arg PT $MODULES_SERVER_PORT '.+{"port":$PT}' \
`

MODULES_DEF=` \
	jq  -n -r -c --argjson MHC $ML_HOST_CONNECTION '{"ml-host-connection":$MHC}' | \
	jq  -r -c --argjson PR $MODULES_PROMPT_64 '.+{"properties":$PR}' | \
	jq  -r -c --argjson DRA $MODULES_REST_API '.+{"rest-api":$DRA}' \
`

CMDS+=(` \
	echo $MODULES_DEF | \
	./manage-v1-rest-api-create-curl-command.bash \
`)

MODULES_DB_NAME=$MODULES_SERVER_NAME
MODULES_LC_PROMPT_64=` \
	echo "echo Setting Collection Lexicon for $MODULES_DB_NAME" | \
	base64 --wrap=0 | \
	jq -R -r -c '{"prompt-64":.}' \
`

MODULES_LC_DATA=` \
	jq -n -r -c '{"collection-lexicon":true}' \
`

MODULES_LC_DEF=` \
	jq  -n -r -c --arg NM $MODULES_DB_NAME '{"name":$NM}' | \
	jq  -r -c --arg RT "databases" '.+{"resource-type":$RT}' | \
	jq  -r -c --argjson MHC $ML_HOST_CONNECTION '.+{"ml-host-connection":$MHC}' | \
	jq  -r -c --argjson PR $MODULES_LC_PROMPT_64 '.+{"properties":$PR}' | \
	jq  -r -c --argjson D $MODULES_LC_DATA '.+{"data":$D}' \
`

CMDS+=(` \
	echo $MODULES_LC_DEF | \
	./manage-v2-resource-change-properties-curl-command.bash \
`)

# Create Server
SERVER_NAME=$NAME
SERVER_PORT=$(($BASEPORT))

PROMPT_64=` \
	echo "echo Creating $SERVER_NAME Server" | tr -d \" | \
	base64 --wrap=0 | \
	jq -R -r -c '{"prompt-64":.}' \
`

REST_API=` \
	jq -n -r -c --arg CN $MODULES_DB_NAME '{"modules-database":$CN}' | \
	jq -r -c --arg PT $SERVER_PORT '.+{"port":$PT}' | \
	jq -r -c --arg SN $SERVER_NAME '.+{"name":$SN}' | \
	jq -r -c '.+{"forests-per-host":1}' \
`

DEF=` \
	jq  -n -r -c --argjson MHC $ML_HOST_CONNECTION '{"ml-host-connection":$MHC}' | \
	jq  -r -c --argjson PR $PROMPT_64 '.+{"properties":$PR}' | \
	jq  -r -c --argjson DRA $REST_API '.+{"rest-api":$DRA}' \
`

CMDS+=(` \
	echo $DEF | \
	./manage-v1-rest-api-create-curl-command.bash \
`)

DB_NAME=$NAME
LC_PROMPT_64=` \
	echo "echo Setting Collection Lexicon for DB_NAME" | \
	base64 --wrap=0 | \
	jq -R -r -c '{"prompt-64":.}' \
`

LC_DATA=` \
	jq -n -r -c '{"collection-lexicon":true}' \
`

LC_DEF=` \
	jq  -n -r -c --arg NM $DB_NAME '{"name":$NM}' | \
	jq  -r -c --arg RT "databases" '.+{"resource-type":$RT}' | \
	jq  -r -c --argjson MHC $ML_HOST_CONNECTION '.+{"ml-host-connection":$MHC}' | \
	jq  -r -c --argjson PR $LC_PROMPT_64 '.+{"properties":$PR}' | \
	jq  -r -c --argjson D $LC_DATA '.+{"data":$D}' \
`

CMDS+=(` \
	echo $LC_DEF | \
	./manage-v2-resource-change-properties-curl-command.bash \
`)

printf '%s\n' "${CMDS[@]}"

