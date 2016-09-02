#!/bin/bash

HOST="localhost"
USERPW="admin:admin"

NAME="TEST8"
PORT=8031

COMMAND_OBJS=` \
	./ml-host.bash $HOST $USERPW | \
	./dump.bash $NAME $PORT 
`

DUMP_COMMANDS=`echo $COMMAND_OBJS | \
	jq -r -c '. | "echo \(.["call-def"]) | base64 --decode | \(.["call"])" '
`

echo $DUMP_COMMANDS

# Run Command
#CLUSTER=`eval $COMMAND | jq -r -c '.'`

#echo $SETUP_SCRIPT_GEN
