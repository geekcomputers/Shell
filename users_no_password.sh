#!/bin/bash

# Script Name	: users_no_password.sh
# Author			: Craig Richards
# Created			: 05-September-2012
# Last Modified	: 11-April-2013
# Version			: 1.1

# Modifications	: 1.1 - 11-April-2013 - CR - Changed to do an OS check so the same script can be used on either Solaris or Linux

# Description		: This will show all OS accounts that don't have a password set.

if [[ `uname -s` == 'Linux' ]]; then
  nopass=`passwd -Sa | grep NP | awk '{print $1}'`
elif [[ `uname -s` == 'SunOS' ]]; then
   nopass=`passwd -sa | grep NP | awk '{print $1}'`
fi

  if [ -z "$nopass" ]
    then
      echo "Good - All user accounts have a password"
    else
      echo "Not Good - $nopass has no password set"
  fi

