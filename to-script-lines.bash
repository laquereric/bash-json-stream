#!/bin/bash
SCRIPT=()

while read -r LINE; do
	PROMPT_LINE=`echo $LINE | jq '. | .properties | .prompt ' | tr -d \" | base64 --decode `
	SCRIPT+=("$PROMPT_LINE")
	COMMAND_LINE=` echo $LINE | jq '. | .command' | tr -d \" | base64 --decode `
	SCRIPT+=("$COMMAND_LINE")
done
printf "%s;" "${SCRIPT[@]}"
