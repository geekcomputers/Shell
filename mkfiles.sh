#!/usr/bin/bash

# Script Name		: mkfiles.sh
# Author				: Craig Richards
# Created				: 30-October-2012
# Last Modified		:
# Version				: 1.0

# Modifications		:

# Description			: This will create several 100Mb files

i=0
while [ $i -lt 11 ]
do
  dd if=/dev/zero of=/file_$i bs=1024 count=10000
  i=$[ $i + 1 ]
done
