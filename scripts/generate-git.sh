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
    ( export GIT_DIR=.
	git worktree add file master
	git update-server-info
    )

    stagit .
    cp log.html index.html
)
