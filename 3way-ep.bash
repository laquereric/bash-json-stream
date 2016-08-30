#!/bin/bash

NAME=$1
BASEPORT=$2

# Read ML Host from pipeline
read JSON_IN;

DOCUMENTS_PORT=$BASEPORT
DOCUMENTS_EP_NAME="$NAME-Document"
DOCUMENTS_EP_PROMPT="echo Create $NAME Document EP"
DOCUMENTS_EP_PROMPT_64=` echo $DOCUMENTS_EP_PROMPT | base64 --wrap=0 `
CREATE_DOCUMENTS_EP_COMMAND_JSON=` echo $JSON_IN | ./rest-ep-json.bash $DOCUMENTS_EP_PROMPT_64 $DOCUMENTS_EP_NAME $DOCUMENTS_PORT | ./manage-v2-servers-create-curl-command.bash `

MODULES_EP_PORT=$(($BASEPORT+1))
MODULES_EP_NAME="$NAME-Module"
MODULES_EP_PROMPT="echo Create $NAME MODULES EP"
MODULES_EP_PROMPT_64=` echo $MODULES_EP_PROMPT | base64 --wrap=0 `
CREATE_MODULES_EP_COMMAND_JSON=` echo $JSON_IN | ./rest-ep-json.bash $MODULES_EP_PROMPT_64 $MODULES_EP_NAME $MODULES_EP_PORT | ./manage-v2-servers-create-curl-command.bash `

DEPLOY_EP_PORT=$(($BASEPORT+2))
DEPLOY_EP_NAME="$NAME-Deploy"
DEPLOY_EP_PROMPT="echo Create $NAME Deploy EP"
DEPLOY_EP_PROMPT_64=` echo $DEPLOY_EP_PROMPT | base64 --wrap=0 `
CREATE_DEPLOY_EP_COMMAND_JSON=` echo $JSON_IN | ./rest-ep-json.bash $DEPLOY_EP_PROMPT_64 $DEPLOY_EP_NAME $DEPLOY_EP_PORT | ./manage-v2-servers-create-curl-command.bash `

# Connect MODULES database to DOCUMENTS server
#manage-v2-servers-change-properties-curl-command.bash 
# Connect DEPLOY database to MODULES server 
#manage-v2-servers-change-properties-curl-command.bash

CREATE_EPS_LIST=`echo $CREATE_DOCUMENTS_EP_COMMAND_JSON $CREATE_MODULES_EP_COMMAND_JSON $CREATE_DEPLOY_EP_COMMAND_JSON `
CREATE_EPS=` echo $CREATE_EPS_LIST | jq -r --slurp '.' `

echo $CREATE_EPS
