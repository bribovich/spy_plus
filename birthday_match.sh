#!/bin/bash
# Script name: birthday_match.sh
#
# Description: Determines if two dates took place on the same day of the week
#
# Input: Two dates in the form MM/DD/YYYY
#
# Output: Message indicating whther the dates occurred
# on the same day of the week
#
# Pseudo-code: The program checks to make sure two parameters are given,
# then checks to see if the parameters are valid dates in 
# format MM/DD/YYYY by writing to a /dev/null file
# It then checks if the dates occurred on the same day using the +%A 
# option of the date command

# Program takes in two dates or returns an error

if [ $# != 2 ]
   then
      echo "Incorrect number of arguments, please enter two dates."
      exit 1

fi

#check for valid dates, if error, find out with $?, then exit
date -d $1  > /dev/null 2>&1

if [ $? != 0 ]
  then
    echo "Your first date is invalid"
    exit 1 
fi

date -d $2  > /dev/null 2>&1

if [ $? != 0 ]
  then
    echo "Your second date is invalid"
    exit 1
fi

# +%A to get the day of the week
day1=`date +%A --date=$1`
day2=`date +%A --date=$2`

#start output
echo "The first person was born on: $day1"
echo "The second person was born on: $day2"

#test to see if the two days match and print out result
if [ $day1 = $day2 ]
  then
    echo "They were born on the same day."
    exit 0
else
  echo "They were not born on the same day."
  exit 0
 
fi
exit 0 #exit status is 0 if we get here
