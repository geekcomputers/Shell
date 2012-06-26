#!/bin/ksh
#set -x
################################################################################
# Simple script to GET stats about network cards
# Should work on hme and qfe. Will NOT change anything.
# Will report on speed and config of all network interfaces.
# Paul Bates 27.03.2000
# James Council 26.09.2001
#       - Changed output to one liners.
#       - Added IPversion check.
# James Council 10.10.2002 (jamescouncil@yahoo.com)
#       - Added test for Cassini Gigabit-Ethernet card (ce_).
#       - Added test for GEM Gigabit-Ethernet (ge_)
#       - Added test for eri Fast-Ethernet (eri_).
#       - Added "Ethernet Address" field.
#       - Removed "IPversion" field.
#       - Removed checking of a port more than once (i.e. qfe0 qfe0:1)
# James Council 10.25.2002 (jamescouncil@yahoo.com)
#       - Fixed 1GB check on ge device.
# James Council 04.02.2003 (jamescouncil@yahoo.com)
#       - Added dmfe check (suggested by John W. Rudick, & Erlend Tronsmoen)
# Octave Orgeron 02.06.2004 (unixconsole@yahoo.com)
#       - Added bge check (bge_).
# Octave Orgeron 05.18.2005 (unixconsole@yahoo.com)
#       - Corrected CE check to use kstat, which is required in Solaris 10.
# Paul Bates 21.11.2005 (sun@paulbates.org)
#       - Corrected Cassini GE check to use cap_autoneg not adv_cap_autoneg
#       - Thanks to Christian Jose of CSC for finding bug and suggesting fix.
# Octave Orgeron 12.13:2005 (unixconsole@yahoo.com)
#       - Corrected DMFE check. Added IPGE check. Special thanks to
#         Paul Bates, Christian Jose, and Bill Qualye for suggesting fixes and
#         for keeping me on my toes;) 
# NOTE: For further updates or comments please feel free to contact me via
#       email.  James Council or Octave Orgeron
#
################################################################################
NDD=/usr/sbin/ndd
KSTAT=/usr/bin/kstat
IFC=/sbin/ifconfig

typeset -R5 LINK
typeset -R9 AUTOSPEED
typeset -R6 STATUS
typeset -R6 SPEED
typeset -R5 MODE
typeset -R18 ETHER

#---- Function to test that the user is root.
#
Check_ID()
{
ID=$(/usr/ucb/whoami)
if [ $ID != "root" ]; then
        echo "$ID, you must be root to run this program."
        exit 1
fi
}


#---- Function to test a Intel 82571-based ethernet controller port (i.e. ipge_).
#
Check_IPGE()
{
autospeed=`${KSTAT} -m ipge -i $num -s cap_autoneg | grep cap_autoneg | awk '{print $2}'`
case $autospeed in
   1) AUTOSPEED=on      ;;
   0) AUTOSPEED=off     ;;
   *) AUTOSPEED=Error   ;;
esac

status=`${KSTAT} -m ipge -i $num -s link_up | grep link_up | awk '{print $2}'`
case $status in
   1) STATUS=Up         ;; 
   0) STATUS=DOWN       ;;
   *) STATUS=Error      ;;
esac

speed=`${KSTAT} -m ipge -i $num -s link_speed | grep link_speed | awk '{print $2}'`
case $speed in
   1000) SPEED=1GB      ;;
   100) SPEED=100MB     ;;
   10) SPEED=10MB       ;;
   0) SPEED=10MB        ;;
   *) SPEED=Error       ;;
esac

mode=`${KSTAT} -m ipge -i $num -s link_duplex | grep link_duplex | awk '{print $2}'`
case $mode in
   2) MODE=FDX          ;;
   1) MODE=HDX          ;;
   0) MODE=---          ;;
   *) MODE=Error        ;;
esac
}

#---- Function to test a Cassini Gigabit-Ethernet port (i.e. ce_).
#
Check_CE()
{
autospeed=`${KSTAT} -m ce -i $num -s cap_autoneg | grep cap_autoneg | awk '{print $2}'`
case $autospeed in
   1) AUTOSPEED=on      ;;
   0) AUTOSPEED=off     ;;
   *) AUTOSPEED=Error   ;;
esac

status=`${KSTAT} -m ce -i $num -s link_up | grep link_up | awk '{print $2}'`
case $status in
   1) STATUS=Up         ;; 
   0) STATUS=DOWN       ;;
   *) STATUS=Error      ;;
esac

speed=`${KSTAT} -m ce -i $num -s link_speed | grep link_speed | awk '{print $2}'`
case $speed in
   1000) SPEED=1GB      ;;
   100) SPEED=100MB     ;;
   10) SPEED=10MB       ;;
   0) SPEED=10MB        ;;
   *) SPEED=Error       ;;
esac

mode=`${KSTAT} -m ce -i $num -s link_duplex | grep link_duplex | awk '{print $2}'`
case $mode in
   2) MODE=FDX          ;;
   1) MODE=HDX          ;;
   0) MODE=---          ;;
   *) MODE=Error        ;;
esac
}


#---- Function to test Quad Fast-Ethernet, Fast-Ethernet, and
#     GEM Gigabit-Ethernet (i.e. qfe_, hme_, ge_)
#
Check_NIC()
{
${NDD} -set /dev/${1} instance ${2}

if [ $type = "ge" ];then
        autospeed=`${NDD} -get /dev/${1} adv_1000autoneg_cap`
else    autospeed=`${NDD} -get /dev/${1} adv_autoneg_cap`
fi
case $autospeed in
   1) AUTOSPEED=on      ;;
   0) AUTOSPEED=off     ;;
   *) AUTOSPEED=Error   ;;
esac

status=`${NDD} -get /dev/${1} link_status`
case $status in
   1) STATUS=Up         ;;
   0) STATUS=DOWN       ;;
   *) STATUS=Error      ;;
esac

speed=`${NDD} -get /dev/${1} link_speed`
case $speed in
   1000) SPEED=1GB      ;;
   1) SPEED=100MB       ;;
   0) SPEED=10MB        ;;
   *) SPEED=Error       ;;
esac

mode=`${NDD} -get /dev/${1} link_mode`
case $mode in
   1) MODE=FDX          ;;
   0) MODE=HDX          ;;
   *) MODE=Error        ;;
esac
}

#---- Function to test the Davicom Fast Ethernet, DM9102A, devices
#     on the Netra X1 and SunFire V100 (i.e. dmfe_)
#
Check_DMF_NIC()
{
autospeed=`${NDD} -get /dev/${1}${2} adv_autoneg_cap`
case $autospeed in
   1) AUTOSPEED=on      ;;
   0) AUTOSPEED=off     ;;
   *) AUTOSPEED=Error   ;;
esac

status=`${NDD} -get /dev/${1}${2} link_status`
case $status in
   1) STATUS=Up         ;;
   0) STATUS=DOWN       ;;
   *) STATUS=Error      ;;
esac

speed=`${NDD} -get /dev/${1}${2} link_speed`
case $speed in
   100) SPEED=100MB     ;;
   10) SPEED=10MB       ;;
   0) SPEED=10MB        ;;
   *) SPEED=Error       ;;
esac

mode=`${NDD} -get /dev/${1}${2} link_mode`
case $mode in
   2) MODE=FDX          ;;
   1) MODE=HDX          ;;
   0) MODE=---          ;;
   *) MODE=Error        ;;
esac
}

# Function to detect Sun BGE interface on Sun Fire V210 and V240.
# The BGE is a Broadcom BCM5704 chipset. There are four interfaces
# on the V210 and V240.
Check_BGE_NIC()
{
autospeed=`${NDD} -get /dev/${1}${2} adv_autoneg_cap`
case $autospeed in
   1) AUTOSPEED=on      ;;
   0) AUTOSPEED=off     ;;
   *) AUTOSPEED=Error   ;;
esac
                                                                                
status=`${NDD} -get /dev/${1}${2} link_status`
case $status in
   1) STATUS=Up         ;;
   0) STATUS=DOWN       ;;
   *) STATUS=Error      ;;
esac
                                                                                
speed=`${NDD} -get /dev/${1}${2} link_speed`
case $speed in
   1000) SPEED=1GB      ;;
   100) SPEED=100MB     ;;
   10) SPEED=10MB       ;;
   0) SPEED=10MB        ;;
   *) SPEED=Error       ;;
esac
                                                                                
mode=`${NDD} -get /dev/${1}${2} link_duplex`
case $mode in
   2) MODE=FDX          ;;
   1) MODE=HDX          ;;
   0) MODE=---          ;;
   *) MODE=Error        ;;
esac
}

#############################################
# Start
#############################################
#
Check_ID

# Output header.
echo
echo " Link Autospeed Status  Speed  Mode   Ethernet Address"
echo "----- --------- ------ ------ ----- ------------------"

# Create a uniq list of network ports configured on the system.
#
# NOTE: This is done to avoid multiple references to a single network port
#       (i.e. qfe0 and qfe0:1).
#
for LINK in `${IFC} -a| egrep -v "lo|be|dman|lpfc"| \
awk -F: '/^[a-z,A-z]/ {print $1}'| sort -u`
do
 type=$(echo $LINK | sed 's/[0-9]//g')
 num=$(echo $LINK | sed 's/[a-z,A-Z]//g')

# Here we reference the functions above to set the variables for each port which
# will be outputed below.
#
 case $type in
   bge)  Check_BGE_NIC $type $num ;;
   ce)   Check_CE $type $num      ;;
   dmfe) Check_DMF_NIC $type $num ;;
   ipge) Check_IPGE $type $num      ;;
   *)    Check_NIC $type $num     ;;
 esac


# Set ethernet variable and output all findings for a port to the screen.
#
 ETHER=`${IFC} ${LINK}| awk '/ether/ {print $2}'`
 echo "$LINK $AUTOSPEED $STATUS $SPEED $MODE $ETHER"
done

set +x
#############################################
# End
#############################################





##############################################################################
### This script is submitted to BigAdmin by a user of the BigAdmin community.
### Sun Microsystems, Inc. is not responsible for the
### contents or the code enclosed. 
###
###
### Copyright 2006 Sun Microsystems, Inc. ALL RIGHTS RESERVED
### Use of this software is authorized pursuant to the
### terms of the license found at
### http://www.sun.com/bigadmin/common/berkeley_license.html
##############################################################################

