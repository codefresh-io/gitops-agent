#!/bin/sh


if [[ -z "$1" ]]; then
    echo "enter repo name"
fi

if [[ -z "$2" ]]; then
    echo "enter binary name"
fi

echo "renaming repo name to $1"
find . \( ! -regex '.*/\..*' \) -type f | LC_ALL=C xargs sed -i '' "s~github.com/codefresh-io/go-template~$1~g"


echo "renaming binary name to $2"
find . \( ! -regex '.*/\..*' \) -type f | LC_ALL=C xargs sed -i '' "s/BINARY_NAME/$2/g"
