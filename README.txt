Assignment 2 README file
README file
Created by Ben Ribovich

There are four aspects of this assignement covered in this document.
They are: birthday_match.sh, count_files.sh, url_search.sh, and spy.sh

The first, birthday_match.sh, determines whether two dates occurred on the same day of the week, and assumes exactly two dates are given in MM/DD/YYYY format. If these are not met, an error is thrown.
It outputs to standard output.

The second, count_files.sh, counts how many files of each extension type there are in a directory. It runs without inputs. Assumptions include that anything after the second "." is considered an extension, and that files will only contain letters, numbers, and underscores. It outputs to standard output.

The third, url_search.sh, searches urls given in a list for the given keywords and prints the frequency of each word in each of the urls. It requires at least two inputs and checks to make sure the first input is a .txt file. It exits if either of these fails. It creates and deletes temporoary html files for searching. It outputs to standard output. 

The fourth, spy.sh, tracks server presence for given users. It assumes users can be found in the etc/passwd file. It exits if no valid users are given. If an invalid user is given with valid ones, the invalid user(s) is/are ignored. If a given name is associated with two or more user names, they are ignored. The program creates temprory text files for each valid username and deletes them at the program's conclusion. Output is to a file called spy.log in the directory in which the file is run. The entirety of this file is created during the call to the trap function. Program assumes kill -10 is called to end the spying an user mnames are passed in quotes.
