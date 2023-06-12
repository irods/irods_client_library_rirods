#!/bin/sh

echo -n $1 | jq -sRr @uri
