#!/bin/bash

DIR="$(pwd)"

function handleParam {
	filesrch="$1"
	param="$2"
	value="$3"
	if [[ "$param" = "-dir" ]]; then
		#echo "checking only directories"  2>&1
		echo "$filesrch" | egrep -i $'\t'"d"$'\t'
	fi
	if [[ "$param" = "-date" ]]; then
		echo "checking date..." 2>&1
		#do
	fi
	if [[ "$param" = "-size" ]]; then
		#echo "checking size"  2>&1
		while IFS=$'\n' read -r line
	    do
	    	res="$(echo "$line" | grep -o $'\t'"[0-9]*"$'\t')"
	    	if (( ${res:1: -1} >= $value )) ; then
	    		echo "$line"
	    	fi
	    done <<< "$filesrch"
	fi
	if [[ "$param" = "-t" ]]; then
		#echo "checking only text files"  2>&1
		echo "$filesrch" | grep "t$"
	fi
}

if [[ ! -f "$DIR""/""index.txt" ]]; then
	echo "\"index.txt\" not found. Generating Index..."
	if [[ ! -f "scan.sh" ]]; then
		echo "Scan file not found. Exitting.."
		exit
	fi
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

if [[ ! -n "$result" ]]; then
	echo "No files found with given parameters.."
	exit
fi
echo "$result"
