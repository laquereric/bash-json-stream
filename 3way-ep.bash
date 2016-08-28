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
PROMPT="Create $NAME Document EP"

CREATE_DOCUMENTS_EP_COMMAND_JSON=` echo $JSON | ./rest-ep-json.bash "$PROMPT" $DOCUMENTS_EP_NAME $DOCUMENTS_PORT | ./rest-ep-curl-command.bash `
echo $CREATE_DOCUMENTS_EP_COMMAND_JSON

exit

MODULES_PORT=#BASEPORT+1
DEPLOY_PORT=#BASEPORT+2

# Connect MODULES database to DOCUMENTS server 
# Connect DEPLOY database to MODULES server 

CREATE_EPS_LIST=`echo $CREATE_DOCUMENTS_EP_CURL_COMMAND $CREATE_MODULES_EP_CURL_COMMAND $CREATE_DEPLOY_EP_CURL_COMMAND `
CREATE_EPS=` echo $CREATE_EPS_LIST | jq --slurp '.' `

echo $CREATE_EPS
