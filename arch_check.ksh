#!/bin/ksh

# Script Name	: arch_check.ksh
# Author			: Craig Richards
# Created			: 30-Jul-2002
# Last Modified	:
# Version			: 1.1

# Modifications	: Added ORACLE_SID as $2, also changed the funct_check_params

# Description		: This script checks the archive location for any log files that have not yet been compressed and compresses them.

#################################
# Start of procedures/functions #
#################################

funct_check_params()
{
        if [ ${NARG} -ne 2 ]; then
                echo "Archive Check Failed : Not enough Parameters passed" >> $LOGFILE
                exit 1
        fi
}

funct_check_logmode()
{
        STATUS=`${ORACLE_HOME}/bin/sqlplus -s << EOF
        /
        SET HEADING OFF
        SET FEEDBACK OFF
        SET PAUSE OFF
        SELECT Log_mode from v\\$database;
        exit
EOF`
        if [ $STATUS = "NOARCHIVELOG" ]; then
                echo "Archive Check Failed : $ORACLE_SID database is in NOARCHIVE LOG MODE" >> $LOGFILE
                exit 1
        fi

}

funct_gzip_files()
{
        for i in `ls $ARCH_DIR/*.arc`
        do
                PIDS=`$INUSE $i`
                if [ $PIDS != 0 ]; then
                        continue
                else
                        $ZIP $i
                fi
        done
}
        
################
# Main Program #
################

# Variable Settings

NARG=$#
ARCH_DIR=$1
LOGFILE='/admin/output/arch_check1.log'
ZIP='/usr/bin/gzip'
INUSE='/etc/fuser'
integer PIDS

# Oracle Environment

ORATAB_LOC=/etc/oratab ; export ORATAB_LOC
ORACLE_SID=$2 ; export ORACLE_SID
ORACLE_HOME=`sed /#/d ${ORATAB_LOC} | grep $ORACLE_SID | awk -F: '{print $2}'` ; export ORACLE_HOME

{
        funct_check_params 
        funct_check_logmode
        funct_gzip_files 
}

## End of Script

