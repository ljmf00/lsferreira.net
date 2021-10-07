---
title: 'Zettelkasten: Useful Linux commands & snippets'
date: '2021-10-07T03:04:00+01:00'
tags: ['zettelkasten', 'zet', 'linux']
description: "This post lists useful linux commands including file extraction,
file conversion and misc"
---

## File extraction

- **Extract .tar files:** `tar -xvf file.tar`
- **Extract .tar.gz files:** `tar -xzvf file.tar.gz`
- **Extract .tar.bz2 files:** `tar -xjvf file.tar.bz2`

Want to automatically extract a file based on its extension? Add this to your
`.bashrc`:

```bash
extract () {
   if [ -f "$1" ] ; then
       case $1 in
           *.tar.bz2)   tar xvjf "$1"    ;;
           *.tar.gz)    tar xvzf "$1"    ;;
           *.bz2)       bunzip2 "$1"     ;;
           *.rar)       unrar x "$1"     ;;
           *.gz)        gunzip "$1"      ;;
           *.tar)       tar xvf "$1"     ;;
           *.tbz2)      tar xvjf "$1"    ;;
           *.tgz)       tar xvzf "$1"    ;;
           *.zip)       unzip "$1"       ;;
           *.Z)         uncompress "$1"  ;;
           *.7z)        7z x "$1"        ;;
           *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
}
```

## File conversion

- **Copy codec video conversion:** `ffmpeg -i "input.mp4" -codec copy
  "output.mkv"`
- **Record screen and convert to file:** `ffmpeg -f x11grab -r 25 -s 800x600 -i
  :0.0 output.mp4`
- **Convert man pages to PDF:** `man -t manpage | ps2pdf - manpage.pdf`
- **Convert command output into image:** `ifconfig | convert label:@- ip.png`
- **Convert images to PDF:** `convert *.jpg -auto-orient document.pdf`
- **Convert big images to small images:** `convert -resize '1024x600^'
  orig.jpg small.jpg`
- **Convert image to grayscale:** `convert -colorspace gray face.jpg
  gray_face.jpg`
- **Convert UNIX epoch to human readable:** `
echo 1633575771 | awk '{ print strftime("%c", $0); }'`
- **Convert CRLF to LF:** `perl -pi -e 's/\r\n?/\n/g'`
- **Convert JSON to YAML:**
  * _Ruby:_ `ruby -ryaml -rjson -e 'puts YAML.dump(JSON.parse(STDIN.read))' <
    file.json > file.yaml`
  * _Python:_ `python -c 'import sys, yaml, json;
    yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)'
    < file.json > file.yaml`
- **Convert YAML to JSON:**
  * _Python:_ `python -c 'import sys, yaml, json;
    json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)' < file.yaml >
    file.json`
- **Convert CSV to JSON:**
  * _Python:_ `python -c "import csv,json;print
    json.dumps(list(csv.reader(open('csv_file.csv'))))"`

_Notes: `convert` command is part of `imagemagick` package_

## Downloads

- **Download an entire website copy:**
  ```bash
  wget --recursive \
       --no-clobber \
       --page-requisites \
       --html-extension \
       --convert-links \
       --restrict-file-names=windows \
       --domains website.org \
       --no-parent \
           https://www.website.org/path/
  ```

- **Download music copy:**
  ```bash
  youtube-dl \
          -f bestaudio \
          --extract-audio \
          --audio-format mp3 \
          --audio-quality 0 \
          --embed-thumbnail \
          --add-metadata \
          -i \
          -o "%(uploader)s - %(title)s.%(ext)s" \
          https://www.website.org/path/
  ```

## Fun/Memes

- **Matrix:** `tr -c "[:digit:]" " " < /dev/urandom | dd cbs=$COLUMNS
  conv=unblock | GREP_COLOR="1;32" grep --color "[^ ]"`
- **Hexdump hackerman:** `cat /dev/urandom | hexdump -C | grep "ca fe"`

## Misc

- **Reset font cache:** `sudo fc-cache -f -v`
- **Stopwatch:** `time read`
- **Copy files via SSH without ssh-copy-id capability:** `cat ~/.ssh/id_rsa.pub
  | ssh user@machine "mkdir ~/.ssh; cat >> ~/.ssh/authorized_keys"`
- **Translate text using Google API:**
  ```bash
  translate () {
    wget -qO- "http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=$1&langpair=$2|${3:-en}" \
      | sed 's/.*"translatedText":"\([^"]*\)".*}/\1\n/'
  }
  ```
