#!/bin/sh

docker rmi $(docker image ls | awk '{print$1}')
