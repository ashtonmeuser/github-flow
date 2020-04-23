#!/bin/sh

PREFIX=$( echo "$1" | awk '/^v/{print "v"} !/^v/{print ""}' )
VERSION=$( echo "$1" | cut -d v -f 2 )
INCREMENT=$( echo "$2" | tr [a-z] [A-Z] )

if [ -z $( echo "$VERSION" | awk '/^[0-9]+\.[0-9]+\.[0-9]+$/' ) ]; then
  echo "Invalid major, minor, patch semver string"
  exit 1
fi

MAJOR=$( echo "$VERSION" | cut -d . -f 1 )
MINOR=$( echo "$VERSION" | cut -d . -f 2 )
PATCH=$( echo "$VERSION" | cut -d . -f 3 )

case "$INCREMENT" in
  'MAJOR' ) MAJOR=$((MAJOR+1));;
  'MINOR' ) MINOR=$((MINOR+1)) ;;
  'PATCH' ) PATCH=$((PATCH+1)) ;;
esac

echo "$PREFIX$MAJOR.$MINOR.$PATCH"
