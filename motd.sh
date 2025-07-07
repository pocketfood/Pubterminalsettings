#!/bin/bash
#clear

# This script is for Arch Linux Systems

PROCCOUNT=`ps -Afl | wc -l`
PROCCOUNT=`expr $PROCCOUNT - 5`
GROUPZ=`groups`

IPADDRESS=`ip address | grep 'inet '| grep -v '127.0.0.1'|cut -d: -f2 |awk '{print $2,$7}'|sed -e 's/^[ \t]*/ /' |tr -d '[\n]'`
UPTIME=`uptime | sed 's/.*up ([^,]*), .*/1/'| sed -e 's/^[ \t]*//'`
CPU=`lscpu | grep 'Model name:' | cut -d: -f2 |awk '{print $0}' | sed -e 's/^[ \t]*//'`
GPU=`lspci | grep 'VGA' | cut -d: -f3 |awk '{print $0}'| sed -e 's/^[ \t]*//'`
STORAGE=`df -h /dev/sda4 | awk '{print$5}'| sed -e 's/^[ \t]*/ /' | tr -d '[\n]'`
MEMORY=`cat /proc/meminfo | grep MemTotal | awk {'print $2'}`

## Check what kind of user are you 
if [[ $GROUPZ == *irc* ]];
then
ENDSESSION=`cat /etc/security/limits.conf | grep "@irc" | grep maxlogins | awk {'print $4'}`
PRIVLAGED="IRC Account"
else
ENDSESSION="Unlimited"
PRIVLAGED="Regular User"
fi

## Check if user is in root and displays it
if [ "$(id -un)" == "root" ]
then
PRIVLAGED="Root User"
fi

#ASCII text here
#You need Figlet installed in order to display the banner
echo -e "\e[1;37m"
figlet -f standard `hostname`

#System info and user info here
echo -e "\e[1;35m+++++++++++++++++: \e[1;37mMachine Info\e[1;35m :+++++++++++++++++++
\e[1;35m+ \e[1;37mhostname\e[1;35m = \e[1;32m`hostname`
\e[1;35m+ \e[1;37mAddress \e[1;35m =\e[1;32m$IPADDRESS
\e[1;35m+ \e[1;37mKernel  \e[1;35m = \e[1;32m`uname -r`
\e[1;35m+ \e[1;37mUptime  \e[1;35m = \e[1;32m$UPTIME
\e[1;35m+ \e[1;37mCPU     \e[1;35m = \e[1;32m$CPU
\e[1;35m+ \e[1;37mGPU     \e[1;35m = \e[1;32m$GPU
\e[1;35m+ \e[1;37mStorage \e[1;35m =\e[1;32m$STORAGE
\e[1;35m+ \e[1;37mMemory  \e[1;35m = \e[1;32m$MEMORY Kb
\e[1;35m++++++++++++++++++: \e[1;37mUser Info\e[1;35m :+++++++++++++++++++++
\e[1;35m+ \e[1;37mUsername \e[1;35m = \e[1;32m`whoami`
\e[1;35m+ \e[1;37mPrivlages\e[1;35m = \e[1;32m$PRIVLAGED
\e[1;35m+ \e[1;37mSessions \e[1;35m = \e[1;32m`who | grep $USER | wc -l` of $ENDSESSION MAX
\e[1;35m+ \e[1;37mProcesses\e[1;35m = \e[1;32m$PROCCOUNT of `ulimit -u` MAX
\e[1;35m+ \e[1;37mPackages \e[1;35m = \e[1;32m`pacman -Qq | wc -l`
\e[1;35m+ \e[1;37mHomecount\e[1;35m = \e[1;32m`ls /home/$USER/ | wc -l`
\e[1;35m++++++++++++++++++++++++++++++++++++++++++++++++++++\e[0m"
