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
	git worktree add raw master
	git update-server-info
	mv objects/pack/*.pack .
	git unpack-objects < *.pack
	rm -f ./*.pack objects/pack/*
    )
    echo "My personal website source code" > description

    stagit .
    cp log.html index.html
)
