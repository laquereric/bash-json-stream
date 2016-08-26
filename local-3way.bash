#!/bin/bash

ML_HOST_JSON=./ml-host.bash localhost admin:admin 

SETUP_SCRIPT_TEMPLATE=` echo $ML_HOST_JSON | jq '{"ml_host":.}' `

| ./rest-ep-json.bash TEST $PORT | ./rest-ep-curl-command.bash
