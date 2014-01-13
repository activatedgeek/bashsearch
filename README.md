bashsearch
==========

Bash Script to index files in folder and search

Do a "chmod +x scan.sh mylocate.sh" for execution (both in same dir)

scan.sh
=======
Recursively populates a given directory.
If path given enumerates path else current working directory

mylocate.sh
===========
Searches for file:
Usage:
./mylocate.sh "[FILE]" [-t | -dir] [-size SIZE] [-date TIMESTAMP]

-t = list only text files
-dir = list only directories
-size SIZE = list all results with size greater than SIZE kB
-date TIMESTAMP = list all result with last modification after TIMESTAMP
TIMESTAMP = DD:MM:YYYY:HH:MM (':' delimiter)
