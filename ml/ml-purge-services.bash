#!/bin/bash

DEFAULT_ARGUMENTS=` \
	echo {} | \
	./ml-server-namerefs.bash | \
	jq '.[]|to_entries|.[0].value|select(.|tostring|.[0:4]=="TEST")|{"server-nameref":.}'
`

while read -r LINE; do
	CL_ARGUMENTS=` \
		echo $LINE | \
		jq -r -c '.'
	`
done

INPUTS_EXIST=` \
	echo $CL_ARGUMENTS | \
	jq 'length' \
`

if [[ $INPUTS_EXIST > 0 ]]; then
	ARGUMENTS=$CL_ARGUMENTS
else
	ARGUMENTS=$DEFAULT_ARGUMENTS
fi

ML_SERVER_NAMEREFS=$ARGUMENTS
echo $ARGUMENTS
exit
