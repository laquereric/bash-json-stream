#!/bin/bash

NAME=$1
BASEPORT=$2

# Read ML Host from pipeline
read ML_HOST_JSON;

# Collect Variables From Input JSON `
HOSTURL_JSON=` echo $ML_HOST_JSON | jq '.host'| tr -d \" | jq -R -c '{host:.}' `
USERPW_JSON=` echo $ML_HOST_JSON | jq '.userpw'| tr -d \" | jq -R -c '{userpw:.}' `

DOCUMENTS_PORT=$BASEPORT
DOCUMENTS_EP_NAME="$NAME-DOCUMENTS"
DOCUMENTS_EP_PROMPT="Create $NAME Document EP"

CREATE_DOCUMENTS_EP_COMMAND_JSON=` echo $JSON | ./rest-ep-json.bash "$DOCUMENTS_EP_PROMPT" $DOCUMENTS_EP_NAME $DOCUMENTS_PORT | ./rest-ep-curl-command.bash `

MODULES_PORT=#BASEPORT+1
MODULESS_EP_NAME="$NAME-DOCUMENTS"
MODULES_EP_PROMPT="Create $NAME MODULES EP"

CREATE_MODULES_EP_COMMAND_JSON=` echo $JSON | ./rest-ep-json.bash "$MODULES_EP_PROMPT" $MODULES_EP_NAME $MODULES_PORT | ./rest-ep-curl-command.bash `

DEPLOY_PORT=#BASEPORT+2
DEPLOY_EP_NAME="$NAME-DEPLOY"
DEPLOY_EP_PROMPT="Create $NAME Deploy EP"

CREATE_DEPLOY_EP_COMMAND_JSON=` echo $JSON | ./rest-ep-json.bash "$DEPLOY_EP_PROMPT" $DEPLOY_EP_NAME $DEPLOY_PORT | ./rest-ep-curl-command.bash `

# Connect MODULES database to DOCUMENTS server 
# Connect DEPLOY database to MODULES server 

CREATE_EPS_LIST=`echo $CREATE_DOCUMENTS_EP_COMMAND_JSON $CREATE_MODULES_EP_COMMAND_JSON $CREATE_DEPLOY_EP_COMMAND_JSON `
CREATE_EPS=` echo $CREATE_EPS_LIST | jq --slurp '.' `

echo $CREATE_EPS
