#!/bin/bash

COMMAND_64=$1
OUTPUT=`echo $COMMAND_64 | base64 --decode`
echo $OUTPUT
