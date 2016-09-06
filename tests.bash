#!/bin/bash

RESPONSE=`./test/ml/macros/ml-host-connection-test.bash`
if [[ "$?" -ne 0 ]]; then
	echo "Error running /test/ml/macros/ml-host-connection-test ${RESPONSE}" 1>&2
	exit 1
fi

RESPONSE=`./test/ml/manage-v2/manage-v2-resources-get-test.bash`
if [[ "$?" -ne 0 ]]; then
	echo "Error running $TEST $SUB_TEST: ${RESPONSE}" 1>&2
	exit 1
fi

RESPONSE=`./test/ml/manage-v2/manage-v2-resource-get-properties-test.bash`
if [[ "$?" -ne 0 ]]; then
	echo "Error running $TEST $SUB_TEST: ${RESPONSE}" 1>&2
	exit 1
fi

echo "OK"
