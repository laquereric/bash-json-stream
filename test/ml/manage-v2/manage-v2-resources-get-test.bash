#!/bin/bash

TEST="MANAGE-V2-RESOURCES-GET-CURL-COMMAND"
SUB_TEST="DEFAULT"
RESPONSE=` \
	echo '{}' | \
	./ml/manage-v2/curl-command/manage-v2-resources-get-curl-command.bash | \
	jq -r -c '.["command-64"]' | \
	base64 -d 
`
if [[ "$?" -ne 0 ]]; then
	echo "Error running $TEST $SUB_TEST" 1>&2
	exit 1
fi

if [ "$RESPONSE" != "curl -s --anyauth -u admin:admin -H \"Content-Type:application/json\" 'http://localhost:8002/manage/v2/servers'" ]; then
	echo "Error in $TEST $SUB_TEST $SUB_SUB_TEST: ATTR = $ATTR" 1>&2
	exit 1
fi

###

SUB_TEST="OVERRIDE"
SUB_SUB_TEST="resource type"
RESPONSE=` \
	echo '{"resource-type":"databases"}' | \
	./ml/manage-v2/curl-command/manage-v2-resources-get-curl-command.bash | \
	jq -r -c '.["command-64"]' | \
	base64 -d 
`

if [ "$RESPONSE" != "curl -s --anyauth -u admin:admin -H \"Content-Type:application/json\" 'http://localhost:8002/manage/v2/databases'" ]; then
	echo "Error in $TEST $SUB_TEST $SUB_SUB_TEST: ATTR = $ATTR" 1>&2
	exit 1
fi

###

SUB_SUB_TEST="host"
RESPONSE=` \
	echo '{"ml-host-connection":{"userpw":"orU:orP","host":"orH"}}' | \
	./ml/manage-v2/curl-command/manage-v2-resources-get-curl-command.bash | \
	jq -r -c '.["command-64"]' | \
	base64 -d 
`

if [ "$RESPONSE" != "curl -s --anyauth -u orU:orP -H \"Content-Type:application/json\" 'http://orH:8002/manage/v2/servers'" ]; then
	echo "Error in $TEST $SUB_TEST $SUB_SUB_TEST: ATTR = $ATTR" 1>&2
	exit 1
fi

TEST="MANAGE-V2-RESOURCES-GET"
SUB_TEST="DEFAULT"
RESPONSE=` \
	echo '{}' | \
	./ml/manage-v2/driver/ml-manage-v2-resources-get.bash \ 
`
if [[ "$?" -ne 0 ]]; then
	echo "Error running $TEST $SUB_TEST" 1>&2
	exit 1
fi

RESPONSE_LENGTH=`
	echo $RESPONSE | \
	jq 'length' 
`

if [[ "$RESPONSE_LENGTH" == 0 ]]; then
	echo "Error running $TEST $SUB_TEST" 1>&2
	exit 1
fi
