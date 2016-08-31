#!/bin/bash
# Accepts a HOST URL and a User:Password
# Contacts the host and parses the response

# Collect Attributes
HOST=$1
USERPW=$2

PROMPT_64=` echo "echo Fetching Cluster Info from $HOST" | tr -d \" | base64 --wrap=0 `

BASE=` jq -n -r -c --arg HT $HOST '{"host":$HT}' | jq -r -c --arg UP $USERPW '.+{"userpw":$UP}' `

COMMAND=` echo $BASE | ./manage-v2-hosts-get-curl-command.bash | base64 --decode `

# Run Command
CLUSTER=`eval $COMMAND | jq -r -c '.'`

HOSTS=`echo $CLUSTER | jq -r -c '.["host-default-list"] | .["list-items"] | .["list-item"]' `
BOOTSTRAP_HOST=`echo $HOSTS | jq -r -c '.[] | select(.roleref=="bootstrap")' `

STATUS=`echo $BASE | jq -r -c --argjson HS $HOSTS '.+{"hosts":$HS}' | jq -r -c --argjson BSH $BOOTSTRAP_HOST '.|.+{"bootstrap-host":$BSH}' `

#STATUS=`eval $COMMAND | jq -r -c --argjson BS $BASE '$BS+{"cluster":.}' `

#echo $BOOTSTRAP_HOST
echo $STATUS
