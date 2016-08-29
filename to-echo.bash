#!/bin/bash

PROMPT_64=$1
OUTPUT=`echo "$PROMPT_64" | base64 --decode`
echo "echo $OUTPUT"

