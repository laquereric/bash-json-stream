#!/bin/bash

NAME=$1
BASEPORT=$2

# Read ML Host from pipeline
read JSON_IN;

EPS=()

# Create MAIN Server
SERVER_NAME="$NAME"
PORT=$BASEPORT
DATABASE_NAME="$NAME"
PROMPT_64=` echo "echo Creating $SERVER_NAME Server" | tr -d \" | base64 --wrap=0 `
EPS+=(` echo $JSON_IN | jq -r -c --arg SN $SERVER_NAME '.+{"server-name":$SN}' | jq -r -c --arg DN $DATABASE_NAME '{"content-database":$DN}' | jq -r -c --arg PT $PORT '{"port":$PT}'| jq -r -c --arg PR $PROMPT_64 '{"properties":{"prompt":$PR}}' | ./manage-v2-servers-create-curl-command.bash `)

# Create MODULE Server
MODULE_SERVER_NAME="$NAME-Modules"
PORT=$(($BASEPORT+1))
MODULES_DATABASE_NAME="$NAME-Modules"
PROMPT_64=`echo "echo Creating $SERVER_NAME Server" | tr -d \" | base64 --wrap=0 `
EPS+=(` echo $JSON_IN | jq -r -c --arg SN $MODULE_SERVER_NAME '.+{"server-name":$SN}' | jq -r -c --arg DN $MODULES_DATABASE_NAME '{"content-database":$DN}' | jq -r -c --arg PT $PORT '{"port":$PT}'| jq -r -c --arg PR $PROMPT_64 '{"properties":{"prompt":$PR}}' | ./manage-v2-servers-create-curl-command.bash `)

# Create DEPLOY Server
SERVER_NAME="$NAME-Deploy"
PORT=$(($BASEPORT+2))
DEPLOY_DATABASE_NAME="$NAME-Deploy"
PROMPT_64=` echo "Creating $SERVER_NAME Server" | tr -d \" | base64 --wrap=0 `
EPS+=(` echo $JSON_IN | jq -r -c --arg SN $SERVER_NAME '.+{"server-name":$SN}' | jq -r -c --arg DN $DEPLOY_DATABASE_NAME '.+{"content-database":$DN}' | jq -r -c --arg PT $PORT '.+{"port":$PT}'| jq -r -c --arg PR $PROMPT_64 '.+{"properties":{"prompt":$PR}}' | ./manage-v2-servers-create-curl-command.bash `)

# Connect MODULES database to DOCUMENTS server
FROM_DATABASE_NAME=$MODULES_DATABASE_NAME
TO_SERVER_NAME=$SERVER_NAME
PROMPT_64=`echo "echo Connecting $FROM_DATABASE_NAME to $TO_SERVER_NAME" | tr -d \" | base64 --wrap=0 `
EPS+=(` echo $JSON_IN | jq -r -c --arg SN $TO_SERVER_NAME '.+{"server-name":$SN}' | jq -r -c --arg MDN $FROM_DATABASE_NAME '.+{"modules-database":$MDN}' | jq -r -c --arg PR $PROMPT_64 '.+{"properties":{"prompt":$PR}}' | ./manage-v2-servers-change-properties-curl-command.bash `)

# Connect MODULES database to DOCUMENTS server
FROM_DATABASE_NAME=$DEPLOY_DATABASE_NAME
TO_SERVER_NAME=$MODULE_SERVER_NAME
PROMPT_64=` echo "echo Connecting $FROM_DATABASE_NAME to $TO_SERVER_NAME" | tr -d \" | base64 --wrap=0 `
EPS+=(` echo $JSON_IN | jq -r -c --arg SN $TO_SERVER_NAME '.+{"server-name":$SN}' | jq -r -c --arg MDN $FROM_DATABASE_NAME '.+{"modules-database":$MDN}' | jq -r -c --arg PR $PROMPT_64 '.+{"properties":{"prompt":$PR}}' | ./manage-v2-servers-change-properties-curl-command.bash `)

printf '%s\n' "${EPS[@]}"
