#!/bin/bash

TEST="ML_HOST_CONNECTION"
SUB_TEST="DEFAULT"
RESPONSE=` \
	echo '{}' | \
	./ml/macros/ml-host-connection.bash \
`
if [[ "$?" -ne 0 ]]; then
	echo "Error running $TEST $SUB_TEST" 1>&2
	exit 1
fi

SUB_SUB_TEST="TOP TAG"
ATTR=`
	echo $RESPONSE | \
	jq -r -c '.|to_entries|.[]|.key' \
`

if [ "$ATTR" != "ml-host-connection" ]; then
	echo "Error in $TEST $SUB_TEST $SUB_SUB_TEST: ATTR = $ATTR" 1>&2
	exit 1
fi

TOP_ATTR=`
	echo $RESPONSE | \
	jq -r -c '.["ml-host-connection"]' \
`

SUB_SUB_TEST="HOST ATTRIBUTE"
ATTR=` \
	echo $TOP_ATTR | \
	jq -r -c '.|.["host"]' \
`
if [ "$ATTR" != "localhost" ]; then
	echo "Error in $TEST $SUB_TEST $SUB_SUB_TEST= $ATTR" 1>&2
	exit 1
fi

SUB_SUB_TEST="USERPW ATTRIBUTE"
ATTR=` \
	echo $TOP_ATTR | \
	jq -r -c '.|.["userpw"]' \
`
if [ "$ATTR" != "admin:admin" ]; then
	echo "Error in $TEST $SUB_TEST $SUB_SUB_TEST= $ATTR" 1>&2
	exit 1
fi

SUB_TEST="OVERRIDE userpw"
SUB_SUB_TEST="Value"
RESPONSE=` \
	echo '{"ml-host-connection":{"userpw":"AuSeR:aPaSsWoRd"}}' | \
	./ml/macros/ml-host-connection.bash \
`

TOP_ATTR=`
	echo $RESPONSE | \
	jq -r -c '.["ml-host-connection"]' \
`

ATTR=` \
	echo $TOP_ATTR | \
	jq -r -c '.|.["userpw"]' \
`

if [ "$ATTR" != "AuSeR:aPaSsWoRd" ]; then
	echo "Error in $TEST $SUB_TEST $SUB_SUB_TEST: ATTR = $ATTR" 1>&2
	exit 1
fi

SUB_TEST="OVERRIDE host"
SUB_SUB_TEST="Value"
RESPONSE=` \
	echo '{"ml-host-connection":{"host":"AhOsT"}}' | \
	./ml/macros/ml-host-connection.bash \
`

TOP_ATTR=`
	echo $RESPONSE | \
	jq -r -c '.["ml-host-connection"]' \
`

ATTR=` \
	echo $TOP_ATTR | \
	jq -r -c '.|.["host"]' \
`

if [ "$ATTR" != "AhOsT" ]; then
	echo "Error in $TEST $SUB_TEST $SUB_SUB_TEST: ATTR = $ATTR" 1>&2
	exit 1
fi

SUB_TEST="Extra Top Param"
SUB_SUB_TEST="Value Pass Thru"
RESPONSE=` \
	echo '{"extra-top-xyz":"eXtRaToP","ml-host-connection":{"host":"AhOsT"}}' | \
	./ml/macros/ml-host-connection.bash \
`

TOP_ATTR=`
	echo $RESPONSE | \
	jq -r -c '.["extra-top-xyz"]' \
`

if [ "$TOP_ATTR" != "eXtRaToP" ]; then
	echo "Error in $TEST $SUB_TEST $SUB_SUB_TEST: ATTR = $ATTR" 1>&2
	exit 1
fi

SUB_TEST="Extra Param"
SUB_SUB_TEST="Value Pass Thru"
RESPONSE=` \
	echo '{"ml-host-connection":{"host":"AhOsT","extra-xyz":"eXtRa"}}' | \
	./ml/macros/ml-host-connection.bash \
`

ATTR=`
	echo $RESPONSE | \
	jq -r -c '.["ml-host-connection"]|.["extra-xyz"]' \
`

if [ "$ATTR" != "eXtRa" ]; then
	echo "Error in $TEST $SUB_TEST $SUB_SUB_TEST: ATTR = $ATTR" 1>&2
	exit 1
fi