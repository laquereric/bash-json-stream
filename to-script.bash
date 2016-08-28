#!/bin/bash

read COMMAND_LIST_JSON_ARRAY;
#echo $COMMAND_LIST_JSON_ARRAY
COMMANDS=` echo $COMMAND_LIST_JSON_ARRAY | jq -r -c -R '.' `
echo $COMMANDS