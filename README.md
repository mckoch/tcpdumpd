tcpdumpd
========

Logs  network  packets  to rotating file ring while silently running in        the background. Command line utility and 'daemon' wrapper for  tcpdump. Supports multiple configurations and instances.

## tcpdumpd v0.21

Wrapper and control script for tcpdump which makes it easy to log network packets in the background to a file ring. tcpdump allows multiple configurations and instances for simultaneous logging to several file rings. By default, one tcpdumpd instance is started at boot time as a permanent short time logging service. 

### Usage

      $> tcpdumpd (start|status|stop|restart|setup) < -param val >

### Dependencies

A linux box, some knowledge about tcpdump, ssh root access.

### Installation

1. Unzip/untar the archive in a safe place
2. chdir there.
3. Run ./tcpdump-setup.sh as root.
4. Answer 'yes' for default installation.

### Changing install configuration

To change the setup values, edit starttcpdump.cfg. To install to a different program directory, you will have to edit the file tcpdumpd too.  First line:

	    myinstallpath="/root/scripts/tcpdumpd/"    

## Post install

	$> man tcpdumpd'.
1. Adjust the defaults for size and number of ring files to the size and traffic of the box.

	 	#number of logfiles before overwritimg
	    tcpdump_FILECOUNT="-W 3"
	    # int max filesize in millions of bytes 
		tcpdump_FILESIZE="-C 1" 

2. Adjust the filter, except you want to log everything.

	    # tcpdump verbosity optipns: -v -vv -vvv
	    tcpdump_VERBOSITY=" -v -n "
	    # tcpdump filter, i.e. ' -i eth0 -p udp host 1.2.3.4 "
	    tcpdump_FILTER=" not host localhost "	


### Uninstall

The installer script will overwrite its default files from a previous installation. It will not touch any files generated during runtime (logs, configs). 

0. Stop all running instances.
1. Run 'tcdumpd setup' or
2. Chdir to the program directory (which is /usr/local/tcpdumpd by default) and run './tcpdumpd setup' as root.
3. 'no' if setup asks if tcpdumpd shall start at system boot.
4. 'no' if setup asks for creating a link in /sbin.
5. You may 'ctrl-c' afterwards to exit setup.
6. Manually delete /usr/local/tcpdumpd and /var/log/tcpdumpd

## Important


This program is NOT designed to run in user space. It is NOT a good idea to add users to tcpdumpd's group since this would be a massive break of privacy in a shared environment, at least. Last, it is absolutely NO good idea to let tcpdumpd run as user or in group 'root'.


### Bugs
This script is tested in Debian 4, 5 and 6, even if 'update-rc.d' may complain during setup This will be fixed with a future (hopefully) dpkg release. Check https://github.com/mckoch/tcpdumpd for questions and updates.  

### License
Copyright M. Christian Koch, emcekah@gmail.com, 2013. This program and documentation is licensed under the GNU General Public License V3 (because 'free' in 'free software' has nothing to with 'free' in 'free beer'). 

Enjoy!
