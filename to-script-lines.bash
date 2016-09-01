#!/bin/bash +x
SCRIPT=()

while read -r LINE; do
	PROMPT_LINE=` \
		echo $LINE | \
		jq -r -c '.properties | .["prompt-64"]' | \
		tr -d \" | \
		base64 --decode \
	`
	SCRIPT+=("$PROMPT_LINE")
	COMMAND_LINE=` \
		echo $LINE | \
		jq -r -c '.["command-64"]' | \
		tr -d \" | \
		base64 --decode \
	`
	SCRIPT+=("$COMMAND_LINE")
done

printf "%s;" "${SCRIPT[@]}"
