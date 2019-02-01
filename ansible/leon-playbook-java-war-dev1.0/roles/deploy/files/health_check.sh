#!/bin/sh

URL=$1
PORT=$2
PROJECT=$3

curl -Is $URL:$PORT/$PROJECT/ > /dev/null && echo "The remote side is healthy" || echo "The remote side is failed, please check"
