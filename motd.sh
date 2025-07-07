#!/bin/bash

# This script is for Arch Linux Systems

PROCCOUNT=$(ps -Afl | wc -l)
PROCCOUNT=$(expr $PROCCOUNT - 5)
GROUPZ=$(groups)

IPADDRESS=$(ip address | grep 'inet ' | grep -v '127.0.0.1' | cut -d: -f2 | awk '{print $2,$7}' | sed -e 's/^[ \t]*/ /' | tr -d '[\n]')
UPTIME=$(uptime | sed 's/.*up \([^,]*\), .*/\1/' | sed -e 's/^[ \t]*//')
CPU=$(lscpu | grep 'Model name:' | cut -d: -f2 | sed -e 's/^[ \t]*//')
GPU=$(lspci | grep 'VGA' | cut -d: -f3 | sed -e 's/^[ \t]*//')
MEMORY=$(grep MemTotal /proc/meminfo | awk '{print $2}')

# Visual Storage Bars for all real mounted block devices
STORAGE_VISUAL=""
BAR_LENGTH=10

while read -r DEV TOTAL USED AVAIL PCT MOUNT; do
  # Remove 'G' suffix
  TOTAL=${TOTAL%G}
  USED=${USED%G}
  AVAIL=${AVAIL%G}

  # Skip if total is zero or empty
  if [[ -z "$TOTAL" || "$TOTAL" -eq 0 ]]; then
    continue
  fi

  FILLED=$((USED * BAR_LENGTH / TOTAL))
  EMPTY=$((BAR_LENGTH - FILLED))
  BAR=$(printf "%0.s█" $(seq 1 $FILLED))
  BAR+=$(printf "%0.s░" $(seq 1 $EMPTY))

  STORAGE_VISUAL+="\e[1;35m+ \e[1;37mDisk ($MOUNT) \e[1;35m= \e[1;32m$BAR  ${AVAIL} GB left\n"
done < <(df -BG | awk '$1 ~ /^\/dev\// {print $1, $2, $3, $4, $5, $6}')

# Check user group
if [[ $GROUPZ == *irc* ]]; then
  ENDSESSION=$(grep "@irc" /etc/security/limits.conf | grep maxlogins | awk '{print $4}')
  PRIVLAGED="IRC Account"
else
  ENDSESSION="Unlimited"
  PRIVLAGED="Regular User"
fi

# Check if root
if [ "$(id -un)" == "root" ]; then
  PRIVLAGED="Root User"
fi

# Banner
echo -e "\e[1;37m"
figlet -f standard "$(hostname)"

# Final Output
echo -e "\e[1;35m+++++++++++++++++: \e[1;37mMachine Info\e[1;35m :+++++++++++++++++++
\e[1;35m+ \e[1;37mhostname \e[1;35m = \e[1;32m$(hostname)
\e[1;35m+ \e[1;37mAddress  \e[1;35m = \e[1;32m$IPADDRESS
\e[1;35m+ \e[1;37mKernel   \e[1;35m = \e[1;32m$(uname -r)
\e[1;35m+ \e[1;37mUptime   \e[1;35m = \e[1;32m$UPTIME
\e[1;35m+ \e[1;37mCPU      \e[1;35m = \e[1;32m$CPU
\e[1;35m+ \e[1;37mGPU      \e[1;35m = \e[1;32m$GPU
$STORAGE_VISUAL\e[1;35m+ \e[1;37mMemory   \e[1;35m = \e[1;32m$MEMORY Kb
\e[1;35m++++++++++++++++++: \e[1;37mUser Info\e[1;35m :+++++++++++++++++++++
\e[1;35m+ \e[1;37mUsername  \e[1;35m = \e[1;32m$(whoami)
\e[1;35m+ \e[1;37mPrivlages \e[1;35m = \e[1;32m$PRIVLAGED
\e[1;35m+ \e[1;37mSessions  \e[1;35m = \e[1;32m$(who | grep $USER | wc -l) of $ENDSESSION MAX
\e[1;35m+ \e[1;37mProcesses \e[1;35m = \e[1;32m$PROCCOUNT of $(ulimit -u) MAX
\e[1;35m+ \e[1;37mPackages  \e[1;35m = \e[1;32m$(pacman -Qq | wc -l)
\e[1;35m+ \e[1;37mHomecount \e[1;35m = \e[1;32m$(ls /home/$USER/ | wc -l)
\e[1;35m++++++++++++++++++++++++++++++++++++++++++++++++++++\e[0m"
