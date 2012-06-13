#!/bin/bash

# Script Name		: kill_oracle.sh
# Author				: Craig Richards
# Created				: 31-May-2012
# Last Modified		:
# Version				: 1.0

# Modifications		:

# Description			: This will kill all the oracle processes associated with a given sid

#################################
# Start of procedures/functions #
#################################

funct_check_params()																									# Function Name
{																																	# Start of the function
  if [ ${NARG} -ne 1 ]; then																								# If the number of arguments is not one, then output a message
    echo "$0 : Not enough Parameters passed, you need to supply an ORACLE_SID"
    exit 1																														# Quit the program
  elif																																# Else if

  # If the argument passed is -h or --h then display the following message in the echo statement

  [[ ${SID} = "-h" ]] || [[ ${SID} = "--h" ]]; then
    echo "Usage: You need to add an ORACLE_SID, e.g $0 BOSSLIVE"
    exit 1																														# Quit the program
  fi																																# End of the if statement
}																																	# End of the function

funct_check_user()																										# Function Name
{																																	# Start of the function
  if [ `/usr/ucb/whoami` != 'oracle' ]; then																			# Check the user is Oracle
    echo "Error: you must run this as oracle"																		# Display a message if its another user
    exit 99																														# Quit the program
  fi																																	
}																																	# End of the function

funct_kill_oracle()																											# Function Name
{																																	# Start of the function
  get_processes=`ps -ef | grep "ora_" | grep ${SID} | grep -v grep` ; export get_processes		# Set the variable get_processes to show the processes that will be killed
  echo -e "\nProcesses that will be killed is \n\n ${get_processes}"
  ps -ef | grep "ora_" | grep ${SID} | grep -v grep | awk '{print $2}' | xargs kill -9						# Kill all the processes associated with the given sid
}																																	# End of the function

################
# Main Program #
################

# Variable Settings

SID=$1																															# Set the variable KEYWORD as the first argument passed
NARG=$# 																													# Set the variable NARG to a number of arguments on the command line

{																																	# Start of the main program
  funct_check_params																									# Call the function funct_check_params
  funct_check_user																										# Call the function funct_check_user
  funct_kill_oracle																											# Call the function funct_kill_oracle
}																																	# End of the main program

## End of Script
