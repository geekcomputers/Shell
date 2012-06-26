#!/bin/bash

# Script Name	: modified_today.sh
# Author			: Craig Richards
# Created			: 20-February-2012
# Last Modified	:
# Version			: 1.0

# Modifications  : 

# Description    : Lists all the files that have been modified that day 

#################################
# Start of procedures/functions #
#################################

funct_check_params()									# Function Name
{																	# Start of the function
  if [ ${NARG} -ne 1 ]; then								# If the number of arguments is not one, then output a message
    echo "$0 : Not enough Parameters passed, you need to supply a directory"
    exit 1														# Quit the program
  elif

  # If the argument passed is -h or --h then display the following message in the echo statement

  [[ ${SLICE} = "-h" ]] || [[ ${SLICE} = "--h" ]]; then
    echo "Usage: You need to add a slice after the script name, e.g $0 /opt"
    exit 1														# Quit the program
  fi																# End of the if statement
}																	# End of the function

funct_find_files()												# Function Name
{																	# Start of the function
  find $SLICE -type f -mtime -1 > $LOGFILE		# Find all the files and put them into a logfile

  for files in $(cat $LOGFILE)							# Loop through all the files and show a long listing
    do
    ls -l $files
  done
}																	# End of the function

################
# Main Program #
################

# Variable Settings

DATE=`date +"%d-%B-%Y"` ; export DATE		# Set the DATE variable, format it as 20-February-2012
SLICE=$1														# Set the variable SLICE as the first argument passed
LOGFILE=/tmp/modifed_$DATE.log				# Set the variable LOGFILE, the stores the files found
NARG=$#														# Set the variable NARG to a number of arguments on the command line

{																	# Start of the main program
  funct_check_params									# Call the function funct_check_params
  funct_find_files												# Call the function funct_file_files
}																	# End of the main program

## End of Script
