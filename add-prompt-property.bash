#!/bin/bash

PROPERTIES_JSON=` echo $1 | jq -R '{properties:{prompt:.}}' `

# Read ML Host from pipeline
read ML_HOST_JSON;

# Collect Variables From Input JSON `
HOSTURL_JSON=` echo $ML_HOST_JSON | jq '.host'| tr -d \" | jq -R -c '{host:.}' `
USERPW_JSON=` echo $ML_HOST_JSON | jq '.userpw'| tr -d \" | jq -R -c '{userpw:.}' `

# Assemble JSON Output
COMPONENT_LIST=` echo $PROPERTIES_JSON $HOSTURL_JSON $USERPW_JSON`
JSON_COMPONENTS=` echo $COMPONENT_LIST | jq --slurp '.' `
JSON=` echo $JSON_COMPONENTS | jq -c '.[0] + .[1] + .[2]' `

echo $JSON
