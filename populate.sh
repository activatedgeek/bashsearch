#!/bin/bash

function populate {
	list=$(ls "$@")
	while IFS=$'\n' read -r line
	do
		if [[ "$line" = "" ]]; then
			continue
		fi
		echo -n -e "$@\t" >> index.txt
		echo -n -e "$line\t" >> index.txt
		echo -n -e "$(stat --format=%y "$@""/""$line")\t" >> index.txt
		ftype=$(file "$@""/""$line")
		#echo "file ""$line"
		if [[ ${ftype: -9} = "directory" ]]; then
			echo -n -e "d\t" >> index.txt
		else
			echo -n -e "f\t" >> index.txt
		fi
		echo -n -e "$(stat --format=%s "$@""/""$line")\t" >> index.txt
		if [[ ${ftype: -5} = "ASCII" ]]; then
			echo "t" >> index.txt
		else
			echo "n" >> index.txt
		fi
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