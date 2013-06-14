#!/bin/bash

# Script Name 	: export_users.ksh 
# Author 			: Craig Richards
# Created 			: 08-November-2012
# Last Modified	:
# Version			: 1.0

# Modifications	:

# Description 	: Get a list of the Oracle schemas then export them 

#################################
# Start of procedures/functions #
#################################

funct_check_params()								# Function to check the amount of parameters being passed
{
  if [ ${NARG} -ne 1 ]; then
    echo "Not enough parameters passed"
    echo "call : $0 script name"
    exit 1
  fi
}

funct_toUpper()											# Function to convert to Uppercase
{
  echo $1 | tr "[:lower:]" "[:upper:]"
}

funct_format()											# Function to carry out the formatting
{
  for OLD in `cat $my_config/words.txt`; 
  do 
  new=`echo $OLD | tr "[:lower:]" "[:upper:]"`
  sed -e 's/\<'$OLD'\>/'$new'/g'  "$FILENAME" > output.sql && cat output.sql > "$FILENAME"
  done
  rm output.sql
  echo -e "\n[+] $FILENAME has been formatted [+]\n"
}
  
################
# Main Program #
################

# Variable Settings

NARG=$#
my_config='/cygdrive/c/users/crichards/Dropbox/config'
FILENAME=$1


{
  funct_check_params
  funct_format
}

## End of Script
