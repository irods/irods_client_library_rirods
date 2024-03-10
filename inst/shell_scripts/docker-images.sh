#!/bin/sh

docker images --filter=reference=$1 --filter=reference=$2 --format $3 2> /dev/null
