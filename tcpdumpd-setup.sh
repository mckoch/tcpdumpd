# This file is part of tcpdumpd.
# tcpdumpd is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# tcpdumpd is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with tcpdumpd.  If not, see <http://www.gnu.org/licenses/>.
##
setupconfig="starttcpdump.cfg"
if  [ ! -f  $setupconfig ] 
  then echo "No config file found. Aborting installation." 
	exit
fi 
source $setupconfig 
clear
echo "*******************************************"
echo $myversion
echo $mydescription
##
while true; do    
    echo "*******************************************"
    read -p "Do you wish to install $myversion ? :" yn
    case $yn in
        [Yy]* ) 
	echo "Installing..."  
	break;;
        [Nn]* ) echo "Installation aborted. " 
	exit;;
        * ) 
	echo "y/es or n/o.";;
    esac
done
##
echo "*******************************************"
echo "Using defaults from $setupconfig "
grep -v \# starttcpdump.cfg
echo "*******************************************"
##
while true; do
    read -p "Install to these defaults?" yn
    case $yn in
        [Yy]* ) echo "Installing...";  
	break;;
        [Nn]* ) echo "To change defaults, please edit $setupconfig. "; 
	exit;;
        * ) 
	echo "y/es or n/o.";
    esac
done
##
echo "*******************************************"
echo "... creating directories"
if [ -d $myinstallpath ]
	then echo "$myinstallpath already exists."
	else mkdir $myinstallpath
fi
#
if [ -d $mydumpdir ]
	then echo "$mydumpdir already exists."
	else mkdir $mydumpdir
fi
##
echo "... copying program files"
cp starttcpdump.sh $myinstallpath
cp $setupconfig $myinstallpath
cp tcpdumpd $myinstallpath
cp tcpdumpd-setup.sh $myinstallpath/tcpdumpd-setup
cp tcpdumpd.man $myinstallpath
cp LICENSE $myinstallpath

echo "... creating user"
adduser --no-create-home --system --group   $myrunuser

echo "... chmod / chgroup files & directories"
chmod 750 $myinstallpath 
chmod 770 $mydumpdir
chgrp $myrunuser $mydumpdir
chmod 700 $myinstallpath/starttcpdump.cfg 
chmod 700 $myinstallpath/tcpdumpd
chmod 700 $myinstallpath/tcpdumpd-setup
echo "Files installed."
##
while true; do
    echo "*******************************************"
    read -p "Run tcpdumpd at system boot?" yn
    case $yn in
        [Yy]* ) echo "Setting up /etc/rc.d ...";  
	ln -s  -f -t  /etc/init.d $myinstallpath/tcpdumpd
	# chmod 770 /etc/init.d/tcpdumpd
	echo "Added /etc/init.d/tcpdumpd"
	update-rc.d tcpdumpd defaults
	echo "Ok."
	break;;
        [Nn]* ) echo "Ok. Trying to remove symlinks...";
		update-rc.d -f tcpdumpd remove
		rm /etc/init.d/tcpdumpd
	break;;
        * ) 
	echo "y/es or n/o.";
    esac
done
## 
while true; do
    echo "*******************************************"
    read -p "Install man page and create link in /sbin to use tcpdumpd from CLI (recommended)?" yn
    case $yn in
        [Yy]* ) echo "Setting up /sbin/tcpdumpd ...";  
	ln -s  -f -t /sbin $myinstallpath/tcpdumpd 
	cp tcpdumpd.man /usr/local/man/man1/tcpdumpd.1
	echo "Run 'tcpdumpd <opts>' from command line or in scripts."
	break;;
        [Nn]* ) echo "Ok. Trying to remove /sbin/tcpdumpd...";
		rm /sbin/tcpdumpd
		rm /usr/local/man/man1/tcpdumpd.1
	break;;
        * ) 
	echo "y/es or n/o.";
    esac
done
## 
while true; do
    echo "*******************************************"
    read -p "Start tcpdumpd now?" yn
    case $yn in
        [Yy]* ) echo "Starting...";  
	$myinstallpath/tcpdumpd start
	break;;
        [Nn]* ) echo "Ok."; 
	break;;
        * ) 
	echo "y/es or n/o.";
    esac
done
##
echo "Setup completed. Have fun!"
echo "*******************************************"
##
