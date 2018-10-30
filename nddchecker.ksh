##
#!/bin/sh

# Print column header information
/usr/bin/echo "Interface\tSpeed\t\tDuplex"
/usr/bin/echo "---------\t-----\t\t------"

# Determine the speed and duplex for each live NIC on the system
for INTERFACE in `/usr/bin/netstat -i | /usr/bin/egrep -v "^Name|^lo0" \
   | /usr/bin/awk '{print $1}' | /usr/bin/cut -d: -f1 |/usr/bin/sort \
   | /usr/bin/uniq`
do
   # "ce" interfaces
   if [ "`/usr/bin/echo $INTERFACE \
   | /usr/bin/awk '/^ce[0-9]+/ { print }'`" ] ; then
      # Determine the ce interface number
      INSTANCE=`/usr/bin/echo $INTERFACE | cut -c 3-`
      DUPLEX=`/usr/bin/kstat ce:$INSTANCE | /usr/bin/grep link_duplex \
         | /usr/bin/awk '{ print $2 }'`
      case "$DUPLEX" in
         1) DUPLEX="half" ;;
         2) DUPLEX="full" ;;
      esac
      SPEED=`/usr/bin/kstat ce:$INSTANCE | /usr/bin/grep link_speed \
         | /usr/bin/awk '{ print $2 }'`
      case "$SPEED" in
         10) SPEED="10 Mbit/s" ;;
         100) SPEED="100 Mbit/s" ;;
         1000) SPEED="1 Gbit/s" ;;
      esac
   # "bge" interfaces
   elif [ "`/usr/bin/echo $INTERFACE \
   | /usr/bin/awk '/^bge[0-9]+/ { print }'`" ] ; then
      # Determine the bge interface number
      INSTANCE=`/usr/bin/echo $INTERFACE | cut -c 4-`
      DUPLEX=`/usr/bin/kstat bge:$INSTANCE:parameters \
         | /usr/bin/grep link_duplex | /usr/bin/awk '{ print $2 }'`
      case "$DUPLEX" in
         1) DUPLEX="half" ;;
         2) DUPLEX="full" ;;
      esac
      SPEED=`/usr/bin/kstat bge:$INSTANCE:parameters \
         | /usr/bin/grep link_speed | /usr/bin/awk '{ print $2 }'`
      case "$SPEED" in
         10) SPEED="10 Mbit/s" ;;
         100) SPEED="100 Mbit/s" ;;
         1000) SPEED="1 Gbit/s" ;;
      esac
   # "iprb" interfaces
   elif [ "`/usr/bin/echo $INTERFACE \
   | /usr/bin/awk '/^iprb[0-9]+/ { print }'`" ] ; then
      # Determine the iprb interface number
      INSTANCE=`/usr/bin/echo $INTERFACE | cut -c 5-`
      DUPLEX=`/usr/bin/kstat iprb:$INSTANCE \
         | /usr/bin/grep duplex | /usr/bin/awk '{ print $2 }'`
      SPEED=`/usr/bin/kstat iprb:$INSTANCE | /usr/bin/grep ifspeed \
         | /usr/bin/awk '{ print $2 }'`
      case "$SPEED" in
         10000000) SPEED="10 Mbit/s" ;;
         100000000) SPEED="100 Mbit/s" ;;
         1000000000) SPEED="1 Gbit/s" ;;
      esac
   # le interfaces are always 10 Mbit half-duplex
   elif [ "`/usr/bin/echo $INTERFACE \
   | /usr/bin/awk '/^le[0-9]+/ { print }'`" ] ; then
      DUPLEX="half"
      SPEED="10 Mbit/s"
   # All other interfaces
   else
      INTERFACE_TYPE=`/usr/bin/echo $INTERFACE | /usr/bin/sed -e "s/[0-9]*$//"`
      INSTANCE=`/usr/bin/echo $INTERFACE | /usr/bin/sed -e "s/^[a-z]*//"`
      # Only the root user can run /usr/sbin/ndd commands
      if [ "`/usr/bin/id | /usr/bin/cut -c1-5`" != "uid=0" ] ; then
         echo "You must be the root user to determine \
${INTERFACE_TYPE}${INSTANCE} speed and duplex information."
         continue
      fi
      /usr/sbin/ndd -set /dev/$INTERFACE_TYPE instance $INSTANCE
      SPEED=`/usr/sbin/ndd -get /dev/$INTERFACE_TYPE link_speed`
      case "$SPEED" in
         0) SPEED="10 Mbit/s" ;;
         1) SPEED="100 Mbit/s" ;;
         1000) SPEED="1 Gbit/s" ;;
      esac
      DUPLEX=`/usr/sbin/ndd -get /dev/$INTERFACE_TYPE link_mode`
      case "$DUPLEX" in
         0) DUPLEX="half" ;;
         1) DUPLEX="full" ;;
         *) DUPLEX="" ;;
      esac
   fi
   /usr/bin/echo "$INTERFACE\t\t$SPEED\t$DUPLEX"
done
