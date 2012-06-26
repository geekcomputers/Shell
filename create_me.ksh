#!/bin/ksh

# Script Name 	: create_me.ksh 
# Author			: Craig Richards
# Created			: 11-February-2007 
# Last Modified	:
# Version			:

# Modifications 	:

# Description 	: I use this to create me on new Solaris builds

#################################
# Start of procedures/functions #
#################################

funct_check_user()
{
  if [ `/usr/ucb/whoami` != root ]
    then echo 'You Must be ROOT to execute this script !!!'
    exit 99
  fi
}

funct_create_user()
{
  cat /etc/passwd | grep craigdba
  if [[ $? != 0 ]]; then
    useradd -c "Craig Richards - Senior Oracle/Unix Admin" -m -d $HOMEDIR -s $SH $USER
    chown $USER $HOMEDIR
  fi
}
    

################
# Main Program #
################

# Variable Settings

NARG=$# ; export NARG
DATE=`date +"%d-%B-%Y"` ; export DATE
HOMEDIR=/export/home/craigdba ; export HOMEDIR
SH=/bin/ksh
USER=craigdba

# Oracle Environment

ORATAB_LOC=/etc/oratab ; export ORATAB_LOC

{
  funct_check_user
  funct_create_user
}

## End of Program
