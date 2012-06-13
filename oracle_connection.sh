#!/bin/bash

# Script Name		: oracle_connections.sh
# Author				: Craig Richards
# Created				: 30-May-2012
# Last Modified		:
# Version				: 1.0

# Modifications		:

# Description			: This will show all of the client connections to the database

#################################
# Start of procedures/functions #
#################################

funct_check_params()				# Function Name
{												# Start of the function
  if [ ${NARG} -ne 1 ]; then			# If the number of arguments is not one, then output a message
    echo "$0 : Not enough Parameters passed, you need to supply an ORACLE_SID"
    exit 1									# Quit the program
  elif											# Else if

  # If the argument passed is -h or --h then display the following message in the echo statement

  [[ ${SID} = "-h" ]] || [[ ${SID} = "--h" ]]; then
    echo "Usage: You need to add an ORACLE_SID, e.g $0 BOSSLIVE"
    exit 1									# Quit the program
  fi											# End of the if statement
}												# End of the function

funct_count_connections()			# Function Name
{												# Start of the function
  numconnections=`ps -ef | grep ${SID}| grep -v grep | grep -v ora_ | wc -l` ; export numconnections	# Set the variable numconnections as running the UNIX one liner
  echo " You have ${numconnections} connections to the database ${SID}"										# Display the amount of connections to the database
}												# End of the function

################
# Main Program #
################

# Variable Settings

SID=$1										# Set the variable KEYWORD as the first argument passed
NARG=$# 								# Set the variable NARG to a number of arguments on the command line

{												# Start of the main program
  funct_check_params				# Call the function funct_check_params
  funct_count_connections			# Call the function funct_file_files
}												# End of the main program

## End of Script
