#!/bin/bash

if [ -z "$1" ]; then
	echo "Usage: md2pdf <markdown file>"
	exit 1
fi

input_file="$1"
output_file="${input_file/.md/.pdf}"

pandoc --smart --standalone --number-sections "$input_file"  -o "$output_file" --template=$HOME/Documents/pandoc_template.tex
