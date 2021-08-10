#!/usr/bin/env bash

ignore_file=".gohugoignore"
project_folder="public"

if [[ $# == 1 ]]; then
	project_folder="$1"
elif [[ $# == 2 ]]; then
	ignore_file="$1"
	project_folder="$2"
elif [[ $# != 0 ]]; then
	cat <<EOF
Usage:
	ignore-files.sh
	ignore-files.sh <ignore file> <publish-folder>
	ignore-files.sh <publish-folder>
EOF
fi

if [ ! -f "$ignore_file" ]; then
	echo "Ignore file $ignore_file not found."
	exit 1
fi

if [ ! -d "$project_folder" ]; then
	echo "Project folder $project_folder not found."
	exit 1
fi

while IFS= read -r -d $'\n' ientry; do
	while IFS= read -r -d $'\n' fentry; do
		echo "Ignoring $fentry..."
		rm -rf "$fentry"
	done < <(find "$project_folder" | sed "s|^$project_folder||" | grep "$ientry" | sed -e "s|^|$project_folder|")
done < <(cat "$ignore_file")

