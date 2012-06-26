#!/bin/ksh 

# Script Name 	: check_oracle.ksh
# Author 			: Craig Richards
# Created 			: 05-Jul-2005
# Last Modified	:
# Version			:

# Modifications	: 

# Description : This script checks the pmon and the listener processes are running on the server

#################################
# Start of procedures/functions #
#################################

funct_check_user()
{
  if [ `/usr/ucb/whoami` != oracle ]
    then echo 'You Must be oracle to execute this script !!!'
    exit 99
  fi
}

funct_check_params()
{
        if [ ${NARG} -ne 1 ]; then
                echo "Check Oracle Failed : Not enough Parameters passed" >> $LOGFILE
                exit 1
        fi
}

funct_check_pmon()
{
  check_pmon=`ps -ef | grep ${ORACLE_SID} | grep pmon | wc -l`;
  err_log=`tail -100 $ORACLE_BASE/admin/$ORACLE_SID/bdump/alert_$ORACLE_SID.log`
  oracle_num=`expr $check_pmon`

  echo $err_log > /tmp/db_err_$ORACLE_SID.log

  if [ $oracle_num -lt 1 ]
    then
    mailx -s "PMON Process for $ORACLE_SID - Not Running" mail@mailaddress.com < /tmp/db_err_$ORACLE_SID.log
    exit 0
  fi
}

################
# Main Program #
################

# Variable Settings

NARG=$#

# Oracle Environment

ORACLE_SID=$1 ; export ORACLE_SID
ORACLE_BASE=/opt/oracle ; export ORACLE_BASE


{
  funct_check_user
  funct_check_params
  funct_check_pmon

}

## End of Script
