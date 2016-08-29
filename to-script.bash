#!/bin/bash

read COMMAND_LIST_JSON_ARRAY;

#COMMANDS=` echo $COMMAND_LIST_JSON_ARRAY | jq -r -c '.[] | .command' | base64 --decode`
index=0
PROMPTS=` echo $COMMAND_LIST_JSON_ARRAY | jq -r -c '.[] | .properties.prompt' | OUTPUTS=(); while read PROMPT; do
#    echo $PROMPT
	LINE="echo Command $index : $PROMPT"
	#echo $LINE
	OUTPUTS+=($LINE)
#	OUTPUTS+=(echo Hello)
	let index+=1
#	OUTPUTS+=(echo Hello2)
	echo "echo $index $PROMPT"
done
echo ${OUTPUTS[@]}
`
echo $PROMPTS

#for((i=0;i<${#PROMPTS[@]};i++))
#do
#    echo "$i: ${PROMPTS[$i]}"
#done

OUTPUTS+=(echo Hello)
${OUTPUTS[@]}

#echo ${OUTPUTS[0]}