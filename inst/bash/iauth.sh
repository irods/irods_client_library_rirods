#!/bin/sh

# get token
SECRETS=$(echo -n "$1:$2" | base64)
echo $(curl -X POST -H "Authorization: Basic ${SECRETS}" "$3/auth")
