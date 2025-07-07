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
MEMORY=`cat /proc/meminfo | grep MemTotal | awk {'print $2'}`

# Visual Storage Bar
STORAGE_TOTAL=$(df -BG /dev/sda4 | awk 'NR==2 {gsub("G","",$2); print $2}')
STORAGE_AVAIL=$(df -BG /dev/sda4 | awk 'NR==2 {gsub("G","",$4); print $4}')
STORAGE_USED=$((STORAGE_TOTAL - STORAGE_AVAIL))
BAR_LENGTH=10
FILLED=$((STORAGE_USED * BAR_LENGTH / STORAGE_TOTAL))
EMPTY=$((BAR_LENGTH - FILLED))
BAR=$(printf "%0.s█" $(seq 1 $FILLED))
BAR+=$(printf "%0.s░" $(seq 1 $EMPTY))
STORAGE_VISUAL="$BAR  ${STORAGE_AVAIL} GB of storage left"

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
\e[1;35m+ \e[1;37mStorage \e[1;35m = \e[1;32m$STORAGE_VISUAL
\e[1;35m+ \e[1;37mMemory  \e[1;35m = \e[1;32m$MEMORY Kb
\e[1;35m++++++++++++++++++: \e[1;37mUser Info\e[1;35m :+++++++++++++++++++++
\e[1;35m+ \e[1;37mUsername \e[1;35m = \e[1;32m`whoami`
\e[1;35m+ \e[1;37mPrivlages\e[1;35m = \e[1;32m$PRIVLAGED
\e[1;35m+ \e[1;37mSessions \e[1;35m = \e[1;32m`who | grep $USER | wc -l` of $ENDSESSION MAX
\e[1;35m+ \e[1;37mProcesses\e[1;35m = \e[1;32m$PROCCOUNT of `ulimit -u` MAX
\e[1;35m+ \e[1;37mPackages \e[1;35m = \e[1;32m`pacman -Qq | wc -l`
\e[1;35m+ \e[1;37mHomecount\e[1;35m = \e[1;32m`ls /home/$USER/ | wc -l`
\e[1;35m++++++++++++++++++++++++++++++++++++++++++++++++++++\e[0m"
