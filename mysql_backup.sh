#!/bin/bash

# Script Name	: mysql_backup.sh
# Author			: Craig Richards
# Created			: 08-March-2012
# Last Modified	:
# Version			: 1.0

# Modifications  : 

# Description		: Backup MySQL database, either the full database or just a single database

#################################
# Start of procedures/functions #
#################################

funct_check_params()									# Function Name
{																	# Start of the function
  if [ ${NARG} -lt 1 ]; then								# If the number of arguments is not one, then output a message
    echo "Usage: $0 argument"
    echo "full = Full MySQL Backup"
    echo "db dbname = Single Database backup"
    exit 1														# Quit the program
  elif

  # If the argument passed is -h or --h then display the following message in the echo statement

  [[ ${choice} = "-h" ]] || [[ ${choice} = "--h" ]]; then
    echo "Usage: $0 argument"
    echo "full = Full MySQL Backup"
    echo "db dbname = Single Database backup"
    exit 1														# Quit the program
  fi																# End of the if statement
}																	# End of the function

funct_backup()												# Function Name
{																	# Start of the function
  if [ ${choice} = "full" ]; then 							# If the choice is full, then..
    mkdir -p ${BACKUP_DIR}							# Make the backup directory

    # Run the command to backup ALL the databases in MySQL, timestamp the file to the dated folder

    mysqldump --all-databases | gzip > ${BACKUP_DIR}/full_mysql_backup-`date +%H:%M`.gz
  elif																# Or
  [[ ${choice} = "db" ]]; then							# If the choice is db, then..
    mkdir -p ${BACKUP_DIR}							# Make the backup directory

    # Backup just the given database, timestamp the file to the dated folder

    mysqldump ${dbbkup} | gzip > ${BACKUP_DIR}/${dbbkup}_mysql_backup-`date +%H:%M`.gz
  fi  
}																	# End of the function


################
# Main Program #
################

# Variable Settings

DATE=`date +"%d-%B-%Y"` ; export DATE		# Set the DATE variable, format it as 20-February-2012
choice=$1														# Set the variable choice as the first argument passed
dbbkup=$2													# Set the variable dbbkup as the database to backup
NARG=$#														# Set the variable NARG to a number of arguments on the command line

{																	# Start of the main program
  funct_check_params									# Call the function funct_check_params
  funct_backup												# Call the function funct_backup
}																	# End of the main program

## End of Script

