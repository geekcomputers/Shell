#!/bin/bash

# Script Name	: users_no_password.sh
# Author			: Craig Richards
# Created			: 05-September-2012
# Last Modified	: 11-April-2013
# Version			: 1.1

# Modifications	: 1.1 - 11-April-2013 - CR - Changed to do an OS check so the same script can be used on either Solaris or Linux

# Description		: This will show all OS accounts that don't have a password set.

get_user_names(){
  # Unless you have a weird setup. Using the regex from: man useradd(8)
  nopass=`passwd -${1}a | grep -o "^.* NP"`

  for i in ${nopass/ /_}
  {
    nopassnames="${nopassnames:- } $i"
  }
}

if [[ "$OSTYPE" == *linux-gnu* ]]; then
  # NOTE: I required root access for the -a flag on my Ubuntu-based setup of Linux.
  get_user_names S
elif [[ "$OSTYPE" == *sunos* ]]; then
  get_user_names s
fi

if [ -z "$nopassnames" ]
  then
    echo "Good - All user accounts have a password"
  else
    # Might be handy to add a loop to include the UID of each user.
    echo "ERROR: The users listed below have no password set:"\
         "       ${nopassnames//_NP/}"
    exit 1
fi
