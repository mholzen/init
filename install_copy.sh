#!/bin/bash

srcdir="$( cd "$( dirname "$0" )" && pwd )"

target=$HOME/.init

if [ -d "$target" ]; then
	echo "Directory $target already exists"
	exit 1
fi

set -o xtrace
cp -r $srcdir $target