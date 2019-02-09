#!/bin/sh

USER=$1
PASS=$2
VERSION=$3

PRO_PROPERTIES="promote.properties"
URL="http://nexus.example.com:8081/repository/Java-war-dev/com/jenkins/demo/Java-war-dev/${VERSION}-SNAPSHOT/maven-metadata.xml"

TIMESTAMP=`curl -s -u $USER:$PASS $URL | grep value | head -n "1" | awk -F'<' '{print $2}'|  awk -F'>' '{print $2}'`

echo "SNAPSHOT=${SNAPSHOT}" >> ${PRO_PROPERTIES}

