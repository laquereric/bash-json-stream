#!/bin/bash

HOST="localhost"
USERPW="admin:admin"

NAME="TEST"
PORT=8011

SETUP_SCRIPT=` ./ml-host.bash $HOST $USERPW | ./3way-ep.bash $NAME $PORT | ./to-script.bash `
echo $SETUP_SCRIPT
