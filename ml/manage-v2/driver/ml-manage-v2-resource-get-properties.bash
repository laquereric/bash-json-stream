#!/bin/bash

while read -r LINE; do
	CL_ARGUMENTS=` \
		echo $LINE | \
		jq -r -c '.'
	`
done

RESULT=` \
	echo $CL_ARGUMENTS | \
	./ml/manage-v2/curl-command/manage-v2-resource-get-properties-curl-command.bash | \
	jq  -r -c '.["command-64"]' | \
	base64 -d | \
	xargs -i -t sh -c "{}" | \
	jq -R -r -c 'tojson'
`

echo $RESULT
