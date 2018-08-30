#!/bin/sh

POM_FILE="pom.xml"
PRO_PROPERTIES="promote.properties"


VERSION=`cat $POM_FILE |grep "version" | head -n "1" | awk -F'-' '{print \$1}'| sed 's/  <version>//g'`
APPNAME=`cat pom.xml |grep "artifactId" | head -n "1" | awk -F'>' '{print $2}' | awk -F'<' '{print $1}'`

echo "SNAP_VER=${VERSION}" > ${PRO_PROPERTIES}
echo "APPNAME=${APPNAME}" >> ${PRO_PROPERTIES}
