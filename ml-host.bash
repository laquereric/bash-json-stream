#!/bin/bash

# Collect Variables From Input JSON
HOSTURL_JSON=` echo $1 | jq -R -c '{host:.}' `
USERPW_JSON=` echo $2 | jq -R -c '{userpw:.}' `

COMPONENT_LIST=` echo $HOSTURL_JSON $USERPW_JSON`
JSON_COMPONENTS=` echo $COMPONENT_LIST | jq --slurp '.' `
JSON=` echo $JSON_COMPONENTS | jq -c '.[0] + .[1] + .[2]' `

#Return Output
echo $JSON
