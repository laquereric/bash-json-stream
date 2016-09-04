#!/bin/bash

DEFAULT_ARGUMENTS=`echo '{}' | \
	./ml-host-connection.bash
`

while read -r LINE; do
	CL_ARGUMENTS=` \
		echo $LINE | \
		jq -r -c '.'
	`
done

ARGUMENTS=` \
	echo $DEFAULT_ARGUMENTS | \
	jq -r -c --argjson CLA $CL_ARGUMENTS '.|.+$CLA' \
`

ML_HOST_CONNECTION=$ARGUMENTS

DUMP_STREAM=` \
	echo $ML_HOST_CONNECTION | \
	./ml-resources-dump-stream.bash | \
	jq -s -r -c '.|.[0] + .[1] + .[2]' \
`

echo $DUMP_STREAM
