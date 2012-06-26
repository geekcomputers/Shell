#!/bin/bash

# Script Name	: homedir_backup.sh
# Author			: Craig Richards
# Created			: December 4, 2011
# Last Modified	:
# Version			: 1.0

# Modifications  :

# Description		: Backs up the user that is running the script home directory, and copy it to another machine

#################################
# Start of procedures/functions #
#################################

funct_home_dir()
{
  tar cvpzf - /home/${user} | ssh craigdba@backup "cat > /export/home/craigdba/${host}_${user}_backup.tar.gz"
}

################
# Main Program #
################

# Variable Settings

host=`hostname`
user=`whoami`

{
        funct_home_dir
}

## End of Script

