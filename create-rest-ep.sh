#!/bin/bash

SHOW_POSITIONAL_PARAMETERS='false'
SHOW_NAMED_PARAMETERS='false'
SHOW_DATA='false'
SHOW_COMMAND='true'
RUN_COMMAND='true'

function quit {
exit
}

if [ $SHOW_POSITIONAL_PARAMETERS = 'true' ]; then
	echo "Positional Parameters"
	echo '$0 = ' $0
	echo '$1 = ' $1
	echo '$2 = ' $2
	echo '$3 = ' $3
	echo '$4 = ' $4
fi

script=$0
HOSTURL=$1
USERPW=$2
BASENAME=$3
PORT=$4

if [ $SHOW_NAMED_PARAMETERS = 'true' ]; then
	echo "Named Parameters"
	echo SCRIPT = $script
	echo HOSTURL = $HOSTURL
	echo USERPW = $USERPW
	echo BASENAME=$3
	echo PORT=$PORT
fi

if [ "$#" -ne 4 ]; then
    echo "create-rest-api HOST NAME:PW BASENAME PORT"
    quit
fi

INNER_JSON=$(cat <<EOF
{ "name": "${BASENAME}Server","database": "${BASENAME}Database","port": "${PORT}"}
EOF
)

JSON=$(cat <<EOF
{ "rest-api" : $INNER_JSON }
EOF
)

if [ $SHOW_DATA = 'true' ]; then
    echo INNER_JSON = $INNER_JSON
	echo JSON = $JSON
fi

COMMAND=$(cat <<EOF
	curl -v -X POST \
	--anyauth \
	-u $USERPW \
	--header "Content-Type:application/json" \
	-d '${JSON}' \
	http://$HOSTURL:8002/v1/rest-apis
EOF
)

if [ $SHOW_COMMAND = 'true' ]; then
   echo $COMMAND
fi

if [ $RUN_COMMAND = 'true' ]; then
	eval $COMMAND
fi
