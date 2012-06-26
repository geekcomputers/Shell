#!/bin/ksh

# Script Name	: current_users.ksh
# Author 			: Craig Richards(CR)
# Created 			: 21 July 2002
# Last Modified	:
# Version			: 1.0

# Modifications	: 31-July-2002 (CR) Re-formatted the script to be inline with the template 
# 						: 15-October-2002 (CR) Changed user script to identify more information

# Description		: This will gather information about the users that are currently attached to the database.

#################################
# Start of procedures/functions #
#################################

funct_get_users()
{
sqlplus -s / as sysdba<< EOF
SET PAUSE OFF
SET PAGESIZE 200
SET LINESIZE 200
COLUMN username FORMAT A15
SPOOL $INFILE
select s.username, osuser, status, server as "Connect Type",
to_char(logon_time,'fmHH24:MI:SS AM') as "Logon Time",
sid, s.serial#, p.spid as "UNIX Proc"
from v\$session s, v\$process p
where s.paddr = p.addr
and s.username is not null
order by status, s.username, s.program, logon_time;
spool off
EXIT
EOF
}

funct_mail_file()
{
mailx -s " Current Users " $SALIST < $INFILE
}

################
# Main Program #
################

# Variable Settings

INFILE=/tmp/current_users.lst
SALIST='dba@whatever.com'

# Oracle Environment

ORATAB_LOC=/etc/oratab ; export ORATAB_LOC
ORACLE_HOME=`sed /#/d ${ORATAB_LOC} | grep $ORACLE_SID | awk -F: '{print $2}'` ; export ORACLE_HOME

{
	funct_get_users
	funct_mail_file
}

## End of Script


