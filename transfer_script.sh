#!/bin/bash

# Script Name	: transfer_script.sh
# Author	: Craig Richards
# Created	: 18-July-2012
# Last Modified	:
# Version	: 1.0

# Modifications	:

# Description	: This will send a given script to a certain server once prompted, if it can't find the script it searches for scripts with a similar name

#################################
# Start of procedures/functions #
#################################

funct_check_params()
{
  if [ ${NARG} -lt 1 ]; then
    echo "Usage: $0 argument"
    echo "Argument = Script Name"
    exit 1
  elif
  
  # If the argument passed is -h or --h then display the following message in the echo statement

  [[ ${script_name} = "-h" ]] || [[ ${script_name} = "--h" ]]; then
    echo "Usage: $0 argument"
    echo "Argument = Script Name"
    exit 1                                                                      # Quit the program
  fi                                                                                # End of the if statement
}                                                                                     # End of the function

funct_copy_file()
{
  if [ ! -z $transfer_file ]; then
    read -p "What server to you want to copy the file to : " SERVER
    echo "Sending $transfer_file to $SERVER in /tmp"
    scp $transfer_file $SERVER:/tmp
  else
    echo -e "File does not exist \n"
    echo -e "A search for similar files shows :"
    no_ext=`echo $script_name | cut -f1 -d.`
    #echo $no_ext
    new_search=`find ${scripts} -name *$no_ext* -print > /tmp/cr_list.txt` ; export new_search
    for files in $(cat /tmp/cr_list.txt)
      do
        new_files=`basename $files`
        echo $new_files
      done
      echo -e "\nWould you like to use one of these scripts? If so re-run the script and pass the correct script"
  fi
}  

################
# Main Program #
################

# Variable Settings

script_name=$1 ; export script_name
scripts=/export/home/craigdba/unicle/scripts ; export scripts
transfer_file=`find ${scripts} -name ${1} -print` ; export transfer_file
NARG=$#

{
  funct_check_params
  funct_copy_file
}

## End of Script

