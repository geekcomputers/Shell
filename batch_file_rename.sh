#!/bin/bash

# Script Name	: batch_file_rename.sh
# Author			: Craig Richards
# Created			: 06-August-2012
# Last Modified	:
# Version			: 1.0

# Modifications	:

# Description		: This will batch rename all files from one extension to another

#################################
# Start of procedures/functions #
#################################

funct_check_params()				# Start of the procedure
{
  if [ ${NARG} -lt 3 ]; then			# Check there are 3 arguments passed to the script, if not display the help 
    echo "Usage: $0 directory *.old_extension *.new_extension"
    exit 1					# Quit the program
  elif						# Else if
  
  # If the argument passed is -h or --h then display the following message in the echo statement

  [[ ${script_name} = "-h" ]] || [[ ${script_name} = "--h" ]]; then
    echo "Usage: $0 directory old_extension new_extension"
    exit 1					# Quit the program
  fi						# End of the if statement
}						# End of the function

funct_batch_rename()				# Start of the procedure
{
  old_ext_cut=`echo ${old_ext} | cut -f2 -d .` 	# Cut just the extension passed, lose the .
  new_ext_cut=`echo ${new_ext} | cut -f2 -d .`	# Cut just the extension passed, lose the . 
  
  # This will carry out the rename

  for file in $(ls $work_dir/*$old_ext); do mv $file `echo $file | sed 's/\(.*\.\)'$old_ext_cut'/\1'$new_ext_cut/` ; done
}

################
# Main Program #
################

# Variable Settings

script_name=$0 
work_dir=$1
old_ext=$2
new_ext=$3
NARG=$#

{						# Start the main program
  funct_check_params				# Call the procedure
  funct_batch_rename				# Call the procedure
}						# End of the main program 	

## End of Script
