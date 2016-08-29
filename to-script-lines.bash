#!/bin/bash

read COMMAND_LIST_JSON_ARRAY;

LINE_JSON_STREAM=` echo $COMMAND_LIST_JSON_ARRAY | jq --stream '{"path":.[0],"value":.[1]}'`

PROMPT_LINES=` echo $LINE_JSON_STREAM | jq 'select(.path[1] == "properties") | select(.path[2] == "prompt") | select(.value != null) | {"type":"prompt", "index":.path[0], "value":.value} | . ' `

COMMAND_LINES=` echo $LINE_JSON_STREAM | jq 'select(.path[1] == "command") | select(.value != null) | {"type":"command", "index":.path[0], "value":.value} ' `

COMMANDS=` echo $PROMPT_LINES $COMMAND_LINES | jq -s '.' | jq 'sort_by(.index) | .[] | (select(.type=="prompt") | @sh "./to-echo.bash \(.value) \n"), (select(.type=="command") | @sh "./to-command.bash \(.value) \n")' `

echo $COMMANDS

