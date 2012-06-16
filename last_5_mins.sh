#!/bin/bash

# Script Name	: last_5_mins.sh
# Author			: Craig Richards
# Created			: November 3, 2011
# Last Modified	:
# Version			: 1.0

# Modifications	:

# Description		: Captures just the last five minutes of a given logfile

#################################
# Start of procedures/functions #
#################################

funct_check_params()										# Function Name
{																		# Start of the function
        if [ ${NARG} -ne 1 ]; then							# If no arguments are passed then display the following message
                echo "last_5_mins FAILED : Not enough Parameters passed, you need to provide a logfile"
                exit 1												# Quit the program
        fi
}																		# End of the function

funct_last_five()													# Function Name
{																		# Start of the function
	NEWFILE=`basename $LOGFILE`					# Set a local variable

        e=															# Logic to gather the last 5 minutes
                for (( i = 5; i >= 0; i-- )) ; do
                e='-e /'`date +\%R -d "-$i min"`'/p '$e
        done

        grep "^$(date '+%b %e')" $LOGFILE | $(sed -n $e > $NEWLOG) 
}

################
# Main Program #
################

# Variable Settings

LOGFILE=$1														# Set the variable LOGFILE to the filename that is passed when the script is called
NEWLOG=/tmp/last_5_mins_$NEWFILE			# Set the variable NEWLOG, this is a new file just containing the last 5 minutes
NARG=$#															# Check the number of arguments passed to the script

{
	funct_check_params										# Call the function
	funct_last_five												# Call the function
}

## End of Script
