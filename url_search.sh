#!/bin/bash
# Script name: url_search.sh
#
# Description: Program that looks through websites and 
# reports how many instances there are of words given as 
# input
#
# Input: text file of urls followed by words to search for
#
# Output: prints number os instances each word came up
# in each website.
#
# Pseudo-code: get all inputs but the first in an array, and 
# return error if there aren't at least 2 inputs.
# make sure the file is in .txt format
# then test the urls in the first input to make sure they are valid
# If they are, convert them to a readable html file, each of which 
# are stored in an array
# Then go through each of the words in the array of inputs 2,...,n and
# determine the count for each html file. 


#need at least a file and a word to test
if [ $# -lt 2 ]
then
  echo "Not enough inputs."
  exit 1
fi


file="$1" #this is the text file(needs to be tested) containing the urls

#test if a text file - will give one if .txt is at the end of the line

#if it's not an existing file with content, exit and say why
if ! [ -s $file ]
then
  echo "File does not exist or does have any contents."
  exit 1
 
fi

urls=() #initialize array containing urls
shift #takes away the first input so it's just the search words
count=0 #index for keeping track of urls and .html files
htmls=() #intitialize array holding html files
while read line || [[ -n "${line}" ]]; #read in each line #from the text file
do
  let count="$count+1"
  curl $line > /dev/null 2>&1 #check to see if this is a valid url
  if [ $? != 0 ]
  then
    #if we get an error, print this and continue
    echo "$line is not a valid url."
    continue

  fi

  curl $line -so $count.html #write webcontent to html file
  htmls+=("$count.html") #and add html file reference to array
  urls+=("$line") #add url to the url list
done < $file

#go through each of the words and calculate how many times it appears
#in each html file

for word
do
  echo -e "$word" #-e so it recognizes line break
  index=0
  while [ $index -lt ${#urls[*]} ]
  do
    echo "${urls["$index"]} `more ${htmls["$index"]} | grep -o $word | wc -l`"
  let index="$index+1"
  done
echo -e "\n"
done

for file in ${htmls[*]} #remove the temporary files.
do
  rm $file

done


exit 0
