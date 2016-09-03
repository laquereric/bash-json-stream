LC_DEF=` \
	jq  -n -r -c --arg NM $DB_NAME '{"name":$NM}' | \
	jq  -r -c --arg RT "databases" '.+{"resource-type":$RT}' | \
	jq  -r -c --argjson MHC $ML_HOST_CONNECTION '.+{"ml-host-connection":$MHC}' | \
	jq  -r -c --argjson PR $LC_PROMPT_64 '.+{"properties":$PR}' | \
	jq  -r -c '.+{"parameters":{"a":1}}' | \
	jq  -r -c --argjson D $LC_DATA '.+{"data":$D}' \
`




# Remove the DEPLOY server reference to Deploy DB Module

DISCONNECT_PROMPT_64=` \
	echo "echo Disconnecting unneeded $DISCONNECT_MODULES_DB_NAME Database" | tr -d \" | \
	base64 --wrap=0 | \
	jq -R -r -c '{"prompt-64":.}' \
`

DISCONNECT_DATA=` \
	jq -n -r -c '{"modules-database":null}' \
`

DISCONNECT_DEF=` \
	jq  -n -R -r -c --arg DMDB $DEPLOY_SERVER_NAME '{"name":$DMDB}' | \
	jq  -r -c --argjson MHC $ML_HOST_CONNECTION '.+{"ml-host-connection":$MHC}' | \
	jq  -r -c --argjson PR $DISCONNECT_PROMPT_64 '.+{"properties":$PR}' | \
	jq  -r -c --argjson DD $DISCONNECT_DATA '.+{"data":$DD}' \
`

CMDS+=(` \
	echo $DISCONNECT_DEF | \
	./manage-v2-servers-change-properties-curl-command.bash \
`)
#
# Remove the Deploy DB Modules DB that is not needed

DELETE_PROMPT_64=` \
	echo "echo Deleting unneeded $DEPLOY_MODULES_DB_NAME Database" | tr -d \" | \
	base64 --wrap=0 | \
	jq -R -r -c '{"prompt-64":.}' \
`

DELETE_DATA=` \
	jq -n -r -c '{"forest-delete":true}'
`

DELETE_DEF=` \
	jq  -n -R -r -c --arg DMDB $DEPLOY_MODULES_DB_NAME '{"name":$DMDB}' | \
	jq  -r -c --argjson MHC $ML_HOST_CONNECTION '.+{"ml-host-connection":$MHC}' | \
	jq  -r -c --argjson PR $DELETE_PROMPT_64 '.+{"properties":$PR}' | \
	jq  -r -c --argjson DD $DELETE_DATA '.+{"data":$DD}' \
`

CMDS+=(` \
	echo $DELETE_DEF | \
	./manage-v2-databases-delete-curl-command.bash \
`)
