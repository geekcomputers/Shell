#!/bin/ksh

# Script Name	: backup.ksh
# Author			: Craig Richards
# Created			: 22-March-2006
# Last Modified	:
# Version			: 1.0

# Modifications	: 

# Description		: Backup script for root disk

LOG=/tmp/backuplog

echo "backup for `date` commencing..." > $LOG
mt -f /dev/rmt/0 rewind
ufsdump 0uf /dev/rmt/0cn / >> $LOG
ufsdump 0uf /dev/rmt/0cn /usr >> $LOG
ufsdump 0uf /dev/rmt/0cn /opt >> $LOG
ufsdump 0uf /dev/rmt/0cn /export/home  >> $LOG
echo "Backup has now completed" >> $LOG
