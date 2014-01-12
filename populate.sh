#!/bin/bash

function populate {
	#populate current directory list
	list=$(ls "$@")

	#using internal field separator to read until end of line
	while IFS=$'\n' read -r line
	do
		if [[ "$line" = "" ]]; then
			continue
		fi

		#full file/directory path
		echo -n -e "$@\t" >> index.txt

		#full file/directory name
		echo -n -e "$line\t" >> index.txt
		mod_timestamp=$(stat --format=%y "$@""/""$line")
		#timestamp
		echo -n -e "${mod_timestamp:0: -4}" >> index.txt

		#get filetype
		ftype=$(file "$@""/""$line")
		if [[ ${ftype: -9} = "directory" ]]; then
			echo -n -e "d\t" >> index.txt
		else
			echo -n -e "f\t" >> index.txt
		fi

		#get file size
		echo -n -e "$(stat --format=%s "$@""/""$line")\t" >> index.txt
		#check for text file
		if [[ ${ftype: -5} = "ASCII" ]]; then
			echo "t" >> index.txt
		else
			echo "n" >> index.txt
		fi

		#recursive step
		if [[ ${ftype: -9} = "directory" ]]; then
			populate "$@""/""$line"
		fi
	done <<< "$list"
}

#redirect any failure to null stream
rm index.txt > /dev/null 2>&1

#recursively populate
dir="$@"
if [[ "$dir" = "" ]]; then
	dir=$(pwd)
	echo "No Path indicated. Indexing for current working directory..."
fi
populate "$dir"
