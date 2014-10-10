#!/bin/bash
# Script name: count_files.sh
#
# Description: Counts the number of files in the directory with
# each extension type
#
# Input: None
#
# Output: List of extensions and frequencies with which they occur.
#
# Pseudo-code: Creates an array of etension types and then for each of
# these types counts its frequency and prints it. The program then
# counts files with no extensions (no dot or dot at the end) and prints
# them with the tag "noext"
#

# creates an array of extensions to iterate over
# since there is a dot at the beginning need to split first 
# based on "/"
extensions=( $(find -type f | awk -F "/" '{print $NF}' | grep "\." | awk -F "\." '{print $NF}' | sort | uniq ))



#iterates
for ext in ${extensions[*]}
do
  if [ $ext == "" ] #make sure not the dot at the end type
  then
    continue
  fi

  frequency=`find -type f | grep "\.$ext"$ | wc -l` #calculates number
  echo $frequency $ext #writes to standard output 
done


# calculates no ext, again splitting first at "/" to avoid first "."
noext=`find -type f | awk -F "/" '{print $NF}' | grep -v "\." | wc -l`
let noext="$noext+`find -type f | grep "\."$ | wc -l`"

echo $noext "noext" 

exit 0


