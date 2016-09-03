#!/bin/bash
DEFAULT_ARGUMENTS=`
		jq -n -r -c '{"name":"TEST8","port":"8035","host":"localhost","userpw":"admin:admin"}'\
`

while read -r LINE; do
	CL_ARGUMENTS=` \
		echo $LINE | \
		jq -r -c '.'
	`
done

ARGUMENTS=` \
	echo $DEFAULT_ARGUMENTS | \
	jq -r -c --argjson CLA $CL_ARGUMENTS '.|.+$CLA' \
`

PORT=` \
	echo $ARGUMENTS | \
	jq -r -c '.port'
`

HOST=` \
	echo $ARGUMENTS | \
	jq -r -c '.host'
`

USERPW=` \
	echo $ARGUMENTS | \
	jq -r -c '.userpw'
`

NAME=` \
	echo $ARGUMENTS | \
	jq -r -c '.name'
`

ML_HOST_CONNECTION=` \
	echo $JSON_IN | \
	jq -r -c '.["ml-host-connection"]' \
`

#SETUP_SCRIPT_GEN=` ./ml-host.bash $HOST $USERPW | ./3way-ep.bash $NAME $PORT | ./to-script-lines.bash `
#echo $SETUP_SCRIPT_GEN
echo $ARGUMENTS