#!/bin/ksh

# Script Name	: test_network.ksh
# Author			: Craig Richards
# Created 			: 27 August 2010
# Last Modified	:
# Version 			: 1.0

# Modifications 	:

# Description 	:  A quick network test to test the network

#################################
# Start of procedures/functions #
#################################



################
# Main Program #
################

# Variable Settings

NARG=$# ; export NARG
DATE=`date +"%d-%B-%Y"` ; export DATE

# Oracle Environment

while true;
do;
  netstat -tn > first;
  sleep 1;
  netstat -tn > second;
  diff first second;
done

## End of Program
