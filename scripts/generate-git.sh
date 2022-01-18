#!/usr/bin/env bash

(cd public/git/ || exit
    # echo "$(git rev-parse --git-dir)"
    if [ "$(git rev-parse --git-dir)" == "." ]; then
	git fetch
    else
	TEMP_DIR="$(mktemp -d)"
	git clone --bare https://github.com/ljmf00/lsferreira.net "$TEMP_DIR"
	mv "$TEMP_DIR"/* .
    fi
    GIT_DIR=. GIT_WORK_TREE=./file git checkout

    stagit .
    cp log.html index.html
)