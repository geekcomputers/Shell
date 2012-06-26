#!/bin/ksh

# Script Name	: coalesce.ksh
# Author			: Craig Richards
# Created			: 02-Oct-2002
# Last Modified	: 19 March 2003
# Version			: 1.1

# Modifications 	: 19-March-2003 Changed to take out username and password to use OS authentication and removed funct_check_params
# 						  19-March-2003 Changed so you have to add a SID for the script to run

# Description : This script gets the list of the tablespaces within the database and then coalesces them

#################################
# Start of procedures/functions #
#################################

funct_check_params()
{
if [ ${NARG} -ne 2 ]; then
echo "Not Enough Parameters Passed - Please Supply Username and Password for connection to the database" 
exit 1
fi
}

funct_get_tablespace()
{
${ORACLE_HOME}/bin/sqlplus -s / << EOF
SET LINESIZE 200
SET PAUSE OFF
SET HEADING OFF
SET TERMOUT OFF
SET FEEDBACK OFF
SET ECHO OFF

COLUMN tablespace_name FORMAT A30

SPOOL $LOG_FILE

SELECT tablespace_name 
FROM dba_tablespaces;

SPOOL OFF

EXIT
EOF
}

funct_coalesce()
{
for NAME in $(cat $LOG_FILE)
do
${ORACLE_HOME}/bin/sqlplus -s / << EOF
ALTER TABLESPACE $NAME COALESCE;
EOF
done
}

################
# Main Program #
################

# Variable Settings

NARG=$#
DBAUSER=$1
DBAPASS=$2
DATE=`date +"%d-%b-%Y"`
LOG_FILE="/admin/output/coalesce.lst"

# Oracle Environment

ORATAB_LOC=/etc/oratab ; export ORATAB_LOC
ORACLE_SID=$2 ; export ORACLE_SID
ORACLE_HOME=`sed /#/d ${ORATAB_LOC} | grep $ORACLE_SID | awk -F: '{print $2}'` ; export ORACLE_HOME

{
touch $LOG_FILE
#funct_check_params
funct_get_tablespace
funct_coalesce >> /admin/output/tblsspc.lst
}

## End of Script


