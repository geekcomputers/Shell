#!/bin/ksh

# Script Name	: newuser.ksh
# Author			: Craig Richards
# Created			: 10th December 2008 
# Last Modified	:
# Version			: 1.0

# Modifications	:

# Description		: A simple script to create a new OS account

#################################
# Start of procedures/functions #
#################################

funct_check_user()
{
  if [ `/usr/ucb/whoami` != root ]
    then echo 'You Must be root to execute this script !!!'
    exit 99
  fi
}

funct_get_info()
{
  clear
  print -n "Please enter username of the user to be created : ";
  read username
  print -n "Please enter a comment for the User : ";
  read comment
  print -n "Please enter the FULL path for the home directory : ";
  read dir
  print -n "Please enter the full shell you would like to use eg /bin/ksh for Korn Shell : ";
  read shell
}
  
funct_create_user()
{
  useradd -c "$comment" -m -d $dir -s $shell $username
  echo ' ';
  echo "User $username has been created on $DATE\n\n";
  echo "You will have to set the password for $username !!!\n\n";
}

funct_permission()
{
  chmod 700 $dir
}

funct_password_expiry()
{
  passwd -x 90 -n 7 $username
}

################
# Main Program #
################

# Variable Settings

DATE=`date +"%d-%B-%Y"` ; export DATE

{
  funct_check_user;
  funct_get_info;
  funct_create_user;
  funct_permission;
  funct_password_expiry;
}


## End of Program
