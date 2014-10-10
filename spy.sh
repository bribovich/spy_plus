#!/bin/bash
# Script name: spy.sh
#
# Description: Monitors when users log in and 
# out of a machine and sends e-mail on each 
# time a user logs in and out to the user. 
# It also sends a summary and the end of the
# day to all users informing them of their usage 
# patterns including how many times they logged 
# in and out and the duration. The script also 
# computes which user logged in the most often, 
# and for the longest and shortest periods of time. (from Charles Palmer)
#
# Input: List of users to monitor in terms 
# of their full names such as "Charles Palmer" (from Charles Palmer)
#
# Output: Creates a log "spy.log" that details when each user logs on, 
# for how long, and who has logged in or the most time, the longest 
# session, and the shortest session, as well as the session
# times
#
# Pseudo-code: First check if we were given at least one input
# then put the inputs in an array and note the time
# Now we have two sections
# the first (although found later in the code) executes a while loop and changes
# the online status array every 60 seconds to the updated version of
# the users' online statuses. If the status changes, it writes to thier 
# temporary files, in seconds of the time where they log on or off
#
# The second, located at the top of the file, is the trap function, which calls
# other functions to log all users off in terms of the program's spying
# It then writes a log detailing each session and various statistics about
# the people being tracked. It also removes all of the temporary files.
 



# return error if no inputs

if [ $# -eq 0 ]
then
  echo "Not enough inputs"
  exit 1
fi   

input=( "$@" ) #put inputs into array where each name is one element

starttime=`date` #log start time

#function called with trap

function trapfunc {
  logoff
  endtime=`date` #endtime
  
  #create header
  touch spy.log
  echo "spy.sh Report" >> spy.log
  echo "started at" $starttime >> spy.log
  echo "stopped at" $endtime >> spy.log
  echo "arguments: "${input[*]}"" >> spy.log
  echo \ >> spy.log  


  #call function to write log about each user
  writelog


  #delete everybody's temporary file
  for person in ${users[*]}
    do
    rm ""$person".txt"

  done 
  exit 0
}

function writelog {

#track special session - initialze variables to be changed
biggest=-1
pmost="${users[0]}"
longestSession=-1
shortestSession=10000
pLongest=${users[0]}
pShortest=${users[0]}

for person in ${users[*]}
do
  total=0
  count=`more "$person".txt | wc -w`
  if [ $count != 0 ]
  then
    #track personal stats - initialize variables
    
    personalLongest=-1
    personalShortest=10000
    log="Here is the breakdown:"
    count=0
    while read line || [[ -n "${line}" ]]; #read in each line
    do
      let count="$count+1"
      first=`echo $line | cut -d ";" -f1` #login time in seconds
      second=`echo $line | cut -d ';' -f2` #logout time in seconds
      line="$count) Logged on at `date -d @$first`; logged off at `date -d @$second` "
 
      log="${log}\n${line}"; #add text to log
      let minutes="($second-$first)/60" #convert seconds to minutes

      #update personal longest and shortest variables

      if [ $minutes -gt $personalLongest ]
      then
        let personalLongest=$minutes

      fi

      if [ $minutes -lt $personalShortest ]
      then
        let personalShortest=$minutes
    
      fi

      #calculate everybody's total time

      let total="$total+$minutes"
    done < "$person.txt";

    #update longest and shortest sessions overall
    
    if [ $personalLongest -gt $longestSession ]
    then
      let longestSession=$personalLongest
      pLongest=$person

    fi


    if [ $personalShortest -lt $shortestSession ] 
    then
      let shortestSession=$personalShortest
      pShortest=$person
    fi

    #write person's total to the log

    echo -e "$person logged in $count times for a total of $total minutes." >>spy.log
    echo \ >> spy.log
    echo  -e "$log" >> spy.log
    echo \ >> spy.log
  else
    echo "$person did not log in at all." >> spy.log
    echo \ >> spy.log
  fi

  #update longest overall total time

  if [ $total -gt $biggest ]
  then
    let biggest=$total
    pmost="$person"

  fi

done

#write overall stats to the log

echo "$pmost logged on the most time of $biggest minutes" >> spy.log
echo "$pShortest had the shortest session of $shortestSession minutes, and is therefore the sneakiest" >> spy.log
echo "$pLongest had the longest session of $longestSession minutes" >> spy.log

}


#logoff function to count end of program as everybody logging off

function logoff {
for (( c=0; c<$length; c++))
do
  if [ ${online[$c]} -eq 1 ]
  then 
    echo `date +%s` >> ${users[$c]}.txt 

  fi

done

}

trap trapfunc SIGUSR1 #for the  kill -10 option

# end of trap function explanation

users=() #initialize array to hold usernames, not verbatim inputs

online=() #initialize array to hold online status, with index corresponding to 
#users array; 0 for offline, 1 for online


#add usernames to users array by looking through /etc/passwd fior the input name
#create a text file for each user to track log in and log out times
for person in "$@"
do
  # check for multiple user names and if a user has more than one username,
  # ignore them
  if [ `grep "$person" /etc/passwd | wc -l` -gt 1 ]
  then
    echo $person has multiple user names. They have been ignored.
    continue
  fi

  #this is their UID
  id=`grep "$person" /etc/passwd | cut -d : -f 1`  
  users=( ${users[*]} $id )
  touch "$id".txt #cretate text file for each user to track login/out times

done

#if none of the inputs worked exit the program
if [ ${#users[@]} -eq 0 ]
then
  echo "No valid users."
  exit 1

fi 

#add a 0(offline) for every user in the usernames array
#this means when the program runs, it counts everybody that
# is already logged on as logging on at start of program
for person in "$@"
do
  online=( ${online[*]} 0 )

done

length=${#online[@]} #needed to iterate over both arrays within same loop

#runs the entire time, this is how the text files are written to
while [ true ]
do
  for (( c=0; c<$length; c++))
    do 
      old=${online[$c]}#were they logged on before?
      new=`who | grep -cim1 "${users[$c]}"` #are they online now?
      online[$c]=$new #store current status
      if [ $old -lt $new ] #they logged on
      then
        #first of two columns, **in seconds
        echo -n "`date +%s`;" >> ${users[$c]}.txt 

      fi
      # second  column ,again in seconds
      if [ $old -gt $new ] #they logged off
      then 
        echo `date +%s` >> ${users[$c]}.txt
      
      fi


  done

  sleep 60 #only iterates every minute to save computing power
done 

exit 0 #in case we get here, but we shouldn't
