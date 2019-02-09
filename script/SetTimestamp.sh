#!/bin/sh

PRO_PROPERTIES="promote.properties"
URL="http://nexus.example.com:8081/repository/Java-war-dev/com/jenkins/demo/Java-war-dev/maven-metadata.xml"
USER=$1
PASS=$2

TIMESTAMP=`curl -s -u $USER:$PASS $URL | grep lastUpdated | awk -F'<' '{print $2}'|  awk -F'>' '{print $2}'`

echo "TIMESTAMP=${TIMESTAMP}" > ${PRO_PROPERTIES}

