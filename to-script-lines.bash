#!/bin/bash

read COMMAND_LIST_JSON_ARRAY;

LINE_JSON_STREAM=` echo $COMMAND_LIST_JSON_ARRAY | jq --stream '{"path":.[0],"value":.[1]}'`

PROMPT_LINES=` echo $LINE_JSON_STREAM | jq 'select(.path[1] == "properties") | select(.path[2] == "prompt") | select(.value != null) | {"type":"prompt", "index":.path[0], "value":.value} | . ' `

COMMAND_LINES=` echo $LINE_JSON_STREAM | jq 'select(.path[1] == "command") | select(.value != null) | {"type":"command", "index":.path[0], "value":.value} ' `

SCRIPT=` echo $PROMPT_LINES $COMMAND_LINES | jq -s '.' | jq 'sort_by(.index) | .[] | .value' | while read -r line; do
	BASH=$(echo $line | tr -d \" | base64 --decode)
	echo "$BASH;"
done `

echo $SCRIPT