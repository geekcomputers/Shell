#!/bin/bash

# Script Name	: rename_files.sh
# Author			: Craig Richards
# Created			: 28-March-2012
# Last Modified	:
# Version			: 1.0

# Modifications  :

# Description		: This will rename all of the files in a directory by removing the word you pass to it
#						: I use this when doing a PITR recovery from one database to a test database.
#						: PLEASE NOTE YOU MUST BE CAREFUL RUNNING THIS SCRIPT, IF YOU RUN IT IN ERROR THAT'S YOUR MISTAKE

#################################
# Start of procedures/functions #
#################################

funct_check_params()                            # Function Name
{                                               # Start of the function
  if [ ${NARG} -ne 1 ]; then                    # If the number of arguments is not one, then output a message
    echo "$0 : Not enough Parameters passed, you need to supply a keyword to remove"
    exit 1                                      # Quit the program
  elif

  # If the argument passed is -h or --h then display the following message in the echo statement

  [[ ${KEYWORD} = "-h" ]] || [[ ${KEYWORD} = "--h" ]]; then
    echo "Usage: You need to add a keyword after the script name, e.g $0 BOSSLIVE"
    exit 1                                      # Quit the program
  fi                                            # End of the if statement
}                                               # End of the function

funct_move_files()                              # Function Name
{                                               # Start of the function
  for i in `ls *$KEYWORD*`
  do
    echo $i
    mv $i `echo $i | cut -f1,3,4 -d_`
  done
}                                               # End of the function

################
# Main Program #
################

# Variable Settings

DATE=`date +"%d-%B-%Y"` ; export DATE           # Set the DATE variable, format it as 20-February-2012
KEYWORD=$1                                      # Set the variable KEYWORD as the first argument passed
NARG=$#                                         # Set the variable NARG to a number of arguments on the command line

{                                               # Start of the main program
  funct_check_params                            # Call the function funct_check_params
  funct_move_files                              # Call the function funct_file_files
}                                               # End of the main program

## End of Script
