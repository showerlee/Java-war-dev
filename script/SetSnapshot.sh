#!/bin/sh

USER=$1
PASS=$2
VERSION=$3

PRO_PROPERTIES="promote.properties"
URL="http://nexus.example.com:8081/repository/Java-war-dev/com/jenkins/demo/Java-war-dev/${VERSION}-SNAPSHOT/maven-metadata.xml"

SNAPSHOT=`curl -s -u $USER:$PASS $URL | xmllint --xpath "//metadata/versioning/snapshotVersions/snapshotVersion[last()]/value/text()" -`

echo "SNAPSHOT=${SNAPSHOT}" >> ${PRO_PROPERTIES}

