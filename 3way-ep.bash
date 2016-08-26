#!/bin/bash

NAME=$1
BASEPORT=$2

# Read ML Host from pipeline
read ML_HOST_JSON;

function to_template_item() {
	COMMAND_B64=$1
	CURL_COMMAND_JSON=` echo $COMMAND_B64 | jq -R -c '{curl_cmd_64:.}' `
	PROMPT=$2
	PROMPT_JSON=` echo $PROMPT | jq -R '{prompt:.}' `
	LIST=` echo $CURL_COMMAND_JSON $PROMPT_JSON `
	JSON=` echo $LIST | jq --slurp '.' `
	ECHO $JSON
}

# Collect Variables From Input JSON `
HOSTURL_JSON=` echo $ML_HOST_JSON | jq '.host'| tr -d \" | jq -R -c '{host:.}' `
USERPW_JSON=` echo $ML_HOST_JSON | jq '.userpw'| tr -d \" | jq -R -c '{userpw:.}' `

DOCUMENTS_PORT=$BASEPORT
DOCUMENTS_EP_NAME="$NAME-DOCUMENTS"
CREATE_DOCUMENTS_EP_CURL_COMMAND=` echo $ML_HOST_JSON | ./rest-ep-json.bash $DOCUMENTS_EP_NAME $DOCUMENTS_PORT | ./rest-ep-curl-command.bash `
COMMAND_B64=`echo $CREATE_DOCUMENTS_EP_CURL_COMMAND | base64 `

to_template_item $COMMAND_B64 "Create $NAME Document EP"
CREATE_DOCUMENTS_EP_TI=$?  
#echo "$COMMAND_B64"
echo $CREATE_DOCUMENTS_EP_TI
exit

MODULES_PORT=#BASEPORT+1
MODULES_EP_NAME="$NAME-MODULES"
CREATE_MODULES_EP_CURL_COMMAND=` echo $ML_HOST_JSON | ./rest-ep-json.bash $MODULES_EP_NAME $MODULES_PORT | ./rest-ep-curl-command.bash `
CREATE_DOCUMENTS_TI=to_template_item $CREATE_MODULES_EP_CURL_COMMAND "Create $NAME Document EP" 

DEPLOY_PORT=#BASEPORT+2
DEPLOY_EP_NAME="$NAME-DEPLOY"
CREATE_DEPLOY_EP_CURL_COMMAND=` echo $ML_HOST_JSON | ./rest-ep-json.bash $DEPLOY_EP_NAME DEPLOY_PORT | ./rest-ep-curl-command.bash `
CREATE_DOCUMENTS_TI=to_template_item $CREATE_DEPLOY_EP_CURL_COMMAND "Create $NAME Document EP" 

# Connect MODULES database to DOCUMENTS server 
# Connect DEPLOY database to MODULES server 

CREATE_EPS_LIST=`echo $CREATE_DOCUMENTS_EP_CURL_COMMAND $CREATE_MODULES_EP_CURL_COMMAND $CREATE_DEPLOY_EP_CURL_COMMAND `
CREATE_EPS=` echo $CREATE_EPS_LIST | jq --slurp '.' `

echo $CREATE_EPS
