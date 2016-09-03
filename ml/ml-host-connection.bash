#!/bin/bash
# Accepts a HOST URL and a User:Password
# Contacts the host and parses the response
#!/bin/bash

DEFAULT_ARGUMENTS=`
		jq -n -r -c '{"host":"localhost","userpw":"admin:admin"}'\
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

ML_HOST_CONNECTION=` \
	jq -n -r -c --argjson ARGS $ARGUMENTS '{"ml-host-connection":$ARGS}' \
`

echo $ML_HOST_CONNECTION
