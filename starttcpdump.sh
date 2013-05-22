#!/bin/sh
# /root/scripts/starttcpdump.sh
# 'daemon' wrapper for tcpdump. 
# Logs network packets to rotating file ring
# while silently running in the background.
# see http://www.tcpdump.org/tcpdump_man.html
# 
# configuration in /root/scripts/starttcpdump.cf
# call by /etc/init.d/tcpdumpd start|stop
#
# V0.2 emcekah@gmail.com 2013 
##  
echo "*** $myversion ***"
if [ $1 ] 
     then echo "added filter:  $tcpdump_FILTER" 
fi 
##
if [ ! -f $mydumpdir/$tcpdump_RINGFILE$ser ]
	ser="0"
	then touch "$mydumpdir/$tcpdump_RINGFILE$ser"
	chmod 664 $mydumpdir/$tcpdump_RINGFILE$ser
	chgrp $myrunuser / $mydumpdir/$tcpdump_RINGFILE$ser
fi
##
nice -n 5 nohup  tcpdump  $tcpdump_VERBOSITY $tcpdump_USER $tcpdump_DUMPDIR/$tcpdump_RINGFILE $tcpdump_FILESIZE  $tcpdump_FILECOUNT $tcpdump_LOGTIME  $tcpdump_FILTER >/dev/null 2>&1&
##
if [ $! ]
	     then echo $! >  $tcpdump_PIDFILE
	     chmod 660 $tcpdump_PIDFILE
	     chmod 664 $mydumpdir/$tcpdump_RINGFILE$ser
	     chgrp $myrunuser $tcpdump_PIDFILE
	     
	     
	     echo "$! : $ERRNO Ringfiles: $tcpdump_DUMPDIR/$tcpdump_RINGFILE* ."
	else 
	      echo "not started: $ERRNO"
	      if [ -f $tcpdump_PIDFILE} ] 
	            then rm $tcpdump_PIDFILE
	      fi
fi
exit
##
# Bugs:
# - Problem: initial logfiles may be unwritable by tcpdumpd user, so it stops after a filecycle. 
#    Solution: chmod log files and directory to be writable by tcpdumpd's user .
# .- Problem: '/.tcpdumpd start' does not work after abnormal termination,.
#     Solution: call './tcpdumpd stop' or manually delete tcpdump_PIDFILE.
##
# Todo:
# - time based log rotation from tcpdump as option / rotate endless with time 
# - output options:   pcap/line format
# - automate chmod for first file of new ring
# - installer package.
#
# Version History
#  V0.2 
#    - added startup script
#    - support for multiple confiration files.
#  V0.1
#    - initial wrapper to run tcpdump in background
##
#This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
