#!/bin/ksh

# Script Name	: unix_users_to_sql.ksh
# Author			: Craig Richards
# Created			: 27 August 2010
# Last Modified	:
# Version			: 1.0

# Modifications 	:

# Description 	: Export UNIX users to sql, you can change the last line if you want the output to go to a file, rather than be inserted straight into the database

#################################
# Start of procedures/functions #
#################################

typeset TABLE='PASSWD_FILE'

passwd_table()
{
print "WHENEVER SQLERROR EXIT"
print "WHENEVER OSERROR EXIT"
print "set autocommit off"
print "create table ${TABLE}
(
hostname varchar2(50),
user_name varchar2(50),
user_description varchar2(100),
shell varchar2(20)
);"
}

{
passwd_table
typeset -i COUNT=0
typeset FILE=/etc/passwd
typeset Item1
typeset Item5
typeset Item7
typeset host
cat ${FILE} | while read LINE
do
let COUNT=COUNT+1
Item1=$(print ${LINE} | cut -d':' -f1)
Item5=$(print ${LINE} | cut -d':' -f5)
Item7=$(print ${LINE} | cut -d':' -f7)
host=`hostname`

print "
insert into ${TABLE}
(
hostname,
user_name,
user_description,
shell
)
values
(
'${host}',
'${Item1}',
'${Item5}',
'${Item7}'
);"

done
print "commit;"

print "select * from ${TABLE};"
# Remove the hash from the line below, and has out the SQLPLUS line if you want ithe output to a file
#} > /tmp/insert_passwd.sql
} | sqlplus -s scott/tiger

## End of Program
