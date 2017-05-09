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
#You need Figlet installed in order to display the banner
echo -e "\e[1;37m"
figlet `hostname`
#System info and user info here
echo -e "\e[1;35m+++++++++++++++++: \e[1;37mMachine Info\e[1;35m :+++++++++++++++++++
\e[1;35m+ \e[1;37mhostname\e[1;35m = \e[1;32m`hostname`
\e[1;35m+ \e[1;37mAddress \e[1;35m = \e[1;32m`ip address | grep 'inet '| grep -v '127.0.0.1'| cut -d: -f2 |awk '{print $2}'| sed -e 's/^[ \t]*//'`
\e[1;35m+ \e[1;37mKernel  \e[1;35m = \e[1;32m`uname -r`
\e[1;35m+ \e[1;37mUptime  \e[1;35m = \e[1;32m`uptime | sed 's/.*up ([^,]*), .*/1/'| sed -e 's/^[ \t]*//'`
\e[1;35m+ \e[1;37mMemory  \e[1;35m = \e[1;32m`cat /proc/meminfo | grep MemTotal | awk {'print $2'}` kB
\e[1;35m++++++++++++++++++: \e[1;37mUser Info\e[1;35m :+++++++++++++++++++++
\e[1;35m+ \e[1;37mUsername \e[1;35m = \e[1;32m`whoami`
\e[1;35m+ \e[1;37mPrivlages\e[1;35m = \e[1;32m$PRIVLAGED
\e[1;35m+ \e[1;37mSessions \e[1;35m = \e[1;32m`who | grep $USER | wc -l` of $ENDSESSION MAX
\e[1;35m+ \e[1;37mProcesses\e[1;35m = \e[1;32m$PROCCOUNT of `ulimit -u` MAX
\e[1;35m++++++++++++++++++: \e[1;37mRules\e[1;35m :+++++++++++++++++++++++++
\e[1;32m Encrypt everything and backup the important files.
\e[1;32m Be nice to the machine. Have a to do list.
\e[1;32m        HAVE A SAFE AND PRODUCTIVE DAY."
