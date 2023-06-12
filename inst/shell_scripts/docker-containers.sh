#!/bin/sh

STATE="$(docker container inspect -f '{{.State.Status}}' $1 2> /dev/null)"
if [ $STATE = "running" ]; then
  exit 0
else
  exit 1
fi
