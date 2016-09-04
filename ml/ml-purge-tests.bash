#!/bin/bash

DEFAULT_ARGUMENTS=` \
	echo {} | \
	./ml-server-namerefs.bash
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

ML_SERVER_NAMEREFS=$ARGUMENTS
echo $ML_SERVER_NAMEREFS

#echo {} | ./ml-server-namerefs.bash | jq '.[]|to_entries|.[0].value||select(match(.,/TEST(.*)))/'

#echo {} | ./ml-server-namerefs.bash | jq '.[]|to_entries|.[0].value||select(match(.,/TEST(.*)))/'