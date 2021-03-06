#!/bin/bash
function checkText {
	echo "$ftype" | grep "ASCII text"
}
function checkDir {
	echo "$ftype" | grep "directory"
}
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
		echo -n -e "${mod_timestamp:0: -16}\t" >> index.txt
		#get filetype
		ftype="$(file "$@""/""$line")"
		if [[ ${ftype: -9} = "directory" ]]; then
			echo -n -e "d\t" >> index.txt
		else
			echo -n -e "f\t" >> index.txt
		fi
		#get file size
		res="$(stat --format=%s "$@""/""$line")"
		res=$((res/1024))
		echo -n -e "$res\t" >> index.txt
		#check for text file
		checkAscii="$(checkText "$ftype")"
		if [[ -n "$checkAscii" ]]; then
			echo "t" >> index.txt
		else
			echo "n" >> index.txt
		fi
		#recursive step
		ifdir="$(checkDir "$ftype")"
		if [[ -n "$ifdir" ]]; then
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
	echo "Indexing for current working directory..."
fi
populate "$dir"
echo "Indexing done in \"$dir\""
