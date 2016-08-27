#!/bin/bash

NAME=$1
BASEPORT=$2

# Read ML Host from pipeline
read ML_HOST_JSON;

function to_template_item() {
	COMMAND_JSON=$1
	PROMPT_JSON=$2
	ECHO $JSON
}

# Collect Variables From Input JSON `
HOSTURL_JSON=` echo $ML_HOST_JSON | jq '.host'| tr -d \" | jq -R -c '{host:.}' `
USERPW_JSON=` echo $ML_HOST_JSON | jq '.userpw'| tr -d \" | jq -R -c '{userpw:.}' `

DOCUMENTS_PORT=$BASEPORT
DOCUMENTS_EP_NAME="$NAME-DOCUMENTS"
PROMPT="Create $NAME Document EP"
PROMPT_JSON=` echo $PROMPT | jq -R '{prompt:.}' `

CREATE_DOCUMENTS_EP_CURL_COMMAND=` echo $ML_HOST_JSON | ./rest-ep-json.bash $DOCUMENTS_EP_NAME $DOCUMENTS_PORT | ./rest-ep-curl-command.bash `
CURL_COMMAND_JSON=` echo $CREATE_DOCUMENTS_EP_CURL_COMMAND | jq -R -c '{curl_cmd_64:.}' `

TI_COMPONENTS=` echo $PROMPT_JSON $CURL_COMMAND_JSON| jq --slurp '.' `
JSON=` echo $TI_COMPONENTS | jq -c '.[0] + .[1]' `
echo $JSON
exit

MODULES_PORT=#BASEPORT+1
MODULES_EP_NAME="$NAME-MODULES"
CREATE_MODULES_EP_CURL_COMMAND=` echo $ML_HOST_JSON | ./rest-ep-json.bash $MODULES_EP_NAME $MODULES_PORT | ./rest-ep-curl-command.bash `
CREATE_DOCUMENTS_TI=to_template_item $CREATE_MODULES_EP_CURL_COMMAND "Create $NAME Document EP" 

DEPLOY_PORT=#BASEPORT+2
DEPLOY_EP_NAME="$NAME-DEPLOY"
CREATE_DEPLOY_EP_CURL_COMMAND=` echo $ML_HOST_JSON | ./rest-ep-json.bash $DEPLOY_EP_NAME DEPLOY_PORT | ./rest-ep-curl-command.bash `
CREATE_DOCUMENTS_TI=to_template_item $CREATE_DEPLOY_EP_CURL_COMMAND "Create $NAME Document" 

# Connect MODULES database to DOCUMENTS server 
# Connect DEPLOY database to MODULES server 

CREATE_EPS_LIST=`echo $CREATE_DOCUMENTS_EP_CURL_COMMAND $CREATE_MODULES_EP_CURL_COMMAND $CREATE_DEPLOY_EP_CURL_COMMAND `
CREATE_EPS=` echo $CREATE_EPS_LIST | jq --slurp '.' `

echo $CREATE_EPS
