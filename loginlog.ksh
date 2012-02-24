#!/bin/ksh

# Script Name : loginlog.ksh

# Author : Craig Richards
# Created : 08-Nov-2004

# Modifications :

# Description : This creates the file which tracks failed login attempts after five failed attempts

# Instructions : loginlog.ksh

#################################
# Start of procedures/functions #
#################################

funct_check_user()
{
  if [ `whoami` != root ]
    then echo 'You Must be root to execute this script !!!'
    exit 99
  fi
}

funct_loginlog()
{
  touch /var/adm/loginlog
  chown root /var/adm/loginlog
  chgrp sys /var/adm/loginlog
  chmod 600 /var/adm/loginlog
}

################
# Main Program #
################

# Variable Settings

# Oracle Environment


{
  funct_check_user
  funct_loginlog
}

## End of Script

