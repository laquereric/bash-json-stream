#!/bin/bash

HOST="localhost"
USERPW="admin:admin"

NAME="TEST6"
PORT=8025

SETUP_SCRIPT_GEN=` ./ml-host.bash $HOST $USERPW | ./3way-ep.bash $NAME $PORT | ./to-script-lines.bash `
echo $SETUP_SCRIPT_GEN
