#!/bin/bash

HOST="localhost"
USERPW="admin:admin"

NAME="TEST8"
PORT=8031

SETUP_SCRIPT_GEN=` ./ml-host.bash $HOST $USERPW | ./3way-ep.bash $NAME $PORT | ./to-script-lines.bash `
echo $SETUP_SCRIPT_GEN
