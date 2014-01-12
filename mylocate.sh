#!/bin/bash

DIR="$(pwd)"

function handleParam {
	filesrch="$1"
	param="$2"
	value="$3"
	if [[ "$param" = "-dir" ]]; then
		echo "$filesrch" | egrep -i $'\t'"d"$'\t'
	fi
	if [[ "$param" = "-date" ]]; then
		echo "checking date" 2>&1
		#do
	fi
	if [[ "$param" = "-size" ]]; then
		sizes="$(echo "$filesrch" | grep -o $'\t'"[0-9]*"$'\t')"
		while IFS=$'\n' read -r line file
		do
			if ((${line:1: -1} >= $value)); then
				echo "$line"
			fi
		done <<< "$sizes"
		echo "checking size"  2>&1
		#do
	fi
	if [[ "$param" = "-t" ]]; then
		echo "$filesrch" | grep "t$"
	fi
}

if [[ ! -f "$DIR""/""index.txt" ]]; then
	echo "\"index.txt\" not found. Generating Index..."
	./scan.sh
fi

if [[ "$1" = "" ]]; then
	echo "No file to search."
	exit
fi

result=""

count=1
for i in "$@"; 
do
	if [[ "$count" -gt "$#" ]]; then
		break
	fi
	if [[ "$count" -eq "1" ]]; then
		result="$(cat index.txt | grep $'\t'"$1")"
	else
		res="${@:$((count)):1}"
		if [[ "$res" = "-size" || "$res" = "-date" ]]; then
			let "count+=1"
			next="${@:$((count)):1}"
			result="$(handleParam "$result" "$res" "$next")"
		else
			result="$(handleParam "$result" "$res")"
		fi	
	fi
	let "count+=1"
done

echo "$result"
