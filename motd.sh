#!/bin/bash
#
#clear
PROCCOUNT=`ps -Afl | wc -l`
PROCCOUNT=`expr $PROCCOUNT - 5`
GROUPZ=`groups`

if [[ $GROUPZ == *irc* ]];
then
ENDSESSION=`cat /etc/security/limits.conf | grep "@irc" | grep maxlogins | awk {'print $4'}`
PRIVLAGED="IRC Account"
else
ENDSESSION="Unlimited"
PRIVLAGED="Regular User"
fi

##check if user is in root and displays it
if [ "$(id -un)" == "root" ]
then
PRIVLAGED="Root User"
fi

#ASCII text here
echo -e "\e[1;37m"
echo -e "\e[1;37m"
echo -e "\e[1;37m"
#you need Figlet installed in order to display the banner
figlet -f standard public_character
#System info and user info here
echo -e "\e[1;35m+++++++++++++++++: \e[1;37mMachine Info\e[1;35m :+++++++++++++++++++
\e[1;35m+ \e[1;37mhostname\e[1;35m = \e[1;32m`hostname`
\e[1;35m+ \e[1;37mAddress \e[1;35m = \e[1;32m`ifconfig  | grep 'inet'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $2}'`
\e[1;35m+ \e[1;37mKernel  \e[1;35m = \e[1;32m`uname -r`
\e[1;35m+ \e[1;37mUptime  \e[1;35m = \e[1;32m`uptime | sed 's/.*up ([^,]*), .*/1/'| sed -e 's/^[ \t]*//'`
\e[1;35m+ \e[1;37mCPU     \e[1;35m = \e[1;32m`lscpu | grep 'Model name:' | cut -d: -f2 |awk '{print $0}' | sed -e 's/^[ \t]*//'`
\e[1;35m+ \e[1;37mMemory  \e[1;35m = \e[1;32m`cat /proc/meminfo | grep MemTotal | awk {'print $2'}` kB
\e[1;35m++++++++++++++++++: \e[1;37mUser Info\e[1;35m :+++++++++++++++++++++
\e[1;35m+ \e[1;37mUsername \e[1;35m = \e[1;32m`whoami`
\e[1;35m+ \e[1;37mPrivlages\e[1;35m = \e[1;32m$PRIVLAGED
\e[1;35m+ \e[1;37mSessions \e[1;35m = \e[1;32m`who | grep $USER | wc -l` of $ENDSESSION MAX
\e[1;35m+ \e[1;37mProcesses\e[1;35m = \e[1;32m$PROCCOUNT of `ulimit -u` MAX
\e[1;35m+ \e[1;37mPackages \e[1;35m = \e[1;32m`pacman -Qq | wc -l`
\e[1;35m++++++++++++++++++: \e[1;37mRules\e[1;35m :+++++++++++++++++++++++++
\e[1;32m This is machine is for Jason briggs. If you are unathorized to
\e[1;32m access this machine. You will be terminated. This machine logs
\e[1;32m everything and everyone. I will find you. If you are athorized.
\e[1;32m Encrypt everything and backup the important files.
\e[1;32m        HAVE A SAFE AND PRODUCTIVE DAY."
