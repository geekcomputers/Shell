#!/bin/ksh

# Script Name	: exp_using_pipes.ksh
# Author			: Craig Richards
# Created			: 18 March 2009
# Last Modified	:
# Version			: 1.0

# Modifications  : 

# Description    	: An example of running an export, compressing on the fly using a pipe

#################################
# Start of procedures/functions #
#################################

export_dump()
{
	rm -f $HOME/gzippipe
	/usr/sbin/mknod $HOME/gzippipe p

	/opt/gzip124x/bin/gzip -c < $HOME/gzippipe > $EXP_FILE &

	$ORACLE_HOME/bin/exp $DBUSER/$DBPASSWD BUFFER=1000000 COMPRESS=N CONSISTENT=Y CONSTRAINTS=Y \
	FULL=Y GRANTS=Y INDEXES=Y DIRECT=Y LOG=${LOG_FILE} ROWS=Y FILE=${HOME}/gzippipe

	rm -f $HOME/gzippipe
}
	
################
# Main Program #
################

# Variable Settings

DBUSER=system
DBPASSWD=manager
EXP_FILE="/export/home/${ORACLE_SID}_full.dmp.gz"
LOG_FILE="${ORACLE_SID}_full.log"
PATH=$PATH:$ORACLE_HOME/bin:/opt/gzip124x/bin

# Oracle Environment

ORATAB_LOC=/etc/oratab ; export ORATAB_LOC
{
	export_dump
}

## End of Script
