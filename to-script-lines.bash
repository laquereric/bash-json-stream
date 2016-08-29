#!/bin/bash

read COMMAND_LIST_JSON_ARRAY;

LINE_JSON_STREAM=` echo $COMMAND_LIST_JSON_ARRAY | jq --stream '{"path":.[0],"value":.[1]}'`

PROMPT_LINES=` echo $LINE_JSON_STREAM | jq 'select(.path[1] == "properties") | select(.path[2] == "prompt") | select(.value != null) | {"type":"prompt", "index":.path[0], "value":.value} | . ' `

#NUM_PROMPT_LINES=${#PROMPT_LINES[@]}

COMMAND_LINES=` echo $LINE_JSON_STREAM | jq 'select(.path[1] == "command") | select(.value != null) | {"type":"command", "index":.path[0], "value":.value} ' `

#NUM_COMMAND_LINES=${#COMMAND_LINES[@]}

OUTPUTS=` echo $PROMPT_LINES $COMMAND_LINES | jq -s '.' | jq -r 'sort_by(.index) | .[] | select(.type=="prompt") .value, select(.type=="command") .value' `
#' `
echo $OUTPUTS

#RESULT= `echo PROMPT_LINES for i in $NUM_PROMPT_LINES
#do
#	echo "$i - $PROMPT_LINES[i]" 
#done
