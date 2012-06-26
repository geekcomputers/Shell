#!/bin/bash

# Script Name	: myping.bash
# Author			: Craig Richards
# Created			: September 25, 2011 
# Last Modified	:
# Version			: 1.0

# Modifications  : 

# Description		: Prefixes the ping command with a date stamp, you then prove when it was run, works on Solaris and Linux

#################################
# Start of procedures/functions #
#################################

funct_check_params()
{
        if [ ${NARG} -ne 1 ]; then
                echo "myping failed : Not enough Parameters passed, you need to add an IP address"
                exit 1
        fi
}

funct_SunOS()
{
	ping -s $IP | while read pong; do echo "$(date +%F_%T) -- $pong"; done
}

funct_Linux()
{
	ping $IP | while read pong; do echo "$(date +%F_%T) -- $pong"; done
}
        
################
# Main Program #
################

# Variable Settings

NARG=$#
IP=$1

{
        funct_check_params 
	if [[ `uname -s` == 'Linux' ]]; then
	  funct_Linux
	elif [[ `uname -s` == 'SunOS' ]]; then
	  funct_SunOS
	fi
}

## End of Script

