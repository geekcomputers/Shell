#!/bin/bash

# Script Name	: vosstat.sh 
# Author			: Craig Richards
# Created			:
# Last Modified	:
# Version			: 1.0

# Modifications 	:

# Description		:  Gather OS statistics to place in to the database

#################################
# Start of procedures/functions #
#################################



################
# Main Program #
################

# Variable Settings

NARG=$# ; export NARG
DATE=`date +"%d-%B-%Y"` ; export DATE

# Oracle Environment

ORATAB_LOC=/etc/oratab ; export ORATAB_LOC
ORACLE_HOME=`sed /#/d ${ORATAB_LOC} | grep $ORACLE_SID | awk -F: '{print $2}'` ; export ORACLE

export ORACLE_HOME=/u02/opt/oracle/home/10ghome
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME:$PATH
export ORACLE_SID=DBATEST

c=0
while [ "$c" -lt "10" ]
do
  sqlplus -s / as sysdba @vosstat.sql
  ((c=c+1))
done

## End of program
