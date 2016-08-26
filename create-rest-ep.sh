#!/bin/bash

SHOW_INPUT_JSON='true'
SHOW_NAMED_PARAMETERS='true'
SHOW_DATA='false'
SHOW_COMMAND='true'
RUN_COMMAND='true'

function quit {
exit
}

if [ $SHOW_INPUT_JSON = 'true' ]; then
	echo $1
fi

HOSTURL=`echo $1 | jq '.host'`
USERPW=`echo $1 | jq '.userpw'`
NAME=`echo $1 | jq '.name'`
PORT=`echo $1 | jq '.port'`

if [ $SHOW_NAMED_PARAMETERS = 'true' ]; then
	echo "Named Parameters"
	echo SCRIPT = $script
	echo HOSTURL = $HOSTURL
	echo USERPW = $USERPW
	echo NAME=$NAME
	echo PORT=$PORT
fi

if [ "$#" -ne 1 ]; then
	echo ./create-rest-ep.sh '{"host":"localhost","userpw":"admin:admin","basename":"TEST","port":"8011"}'
	HOST=`echo $1 | jq '.host'`
	echo $HOST
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
