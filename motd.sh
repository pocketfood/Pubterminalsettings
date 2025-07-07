#!/bin/bash

PROCCOUNT=$(ps -Afl | wc -l)
PROCCOUNT=$((PROCCOUNT - 5))
GROUPZ=$(groups)

IPADDRESS=$(ip address | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2, $7}' | tr -d '\n')
UPTIME=$(uptime | sed 's/.*up \([^,]*\), .*/\1/' | sed -e 's/^[ \t]*//')
CPU=$(lscpu | grep 'Model name:' | cut -d: -f2 | sed -e 's/^[ \t]*//')
GPU=$(lspci | grep 'VGA' | cut -d: -f3 | sed -e 's/^[ \t]*//')
MEMTOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')
MEMFREE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
MEMUSED=$((MEMTOTAL - MEMFREE))
MEMTOTAL_MB=$((MEMTOTAL / 1024))
MEMFREE_MB=$((MEMFREE / 1024))
MEMUSED_MB=$((MEMUSED / 1024))

# RAM bar logic
BAR_LENGTH=10
RAM_FILLED=$((MEMUSED * BAR_LENGTH / MEMTOTAL))
RAM_EMPTY=$((BAR_LENGTH - RAM_FILLED))
RAM_BAR=$(printf "%0.s█" $(seq 1 $RAM_FILLED))
RAM_BAR+=$(printf "%0.s░" $(seq 1 $RAM_EMPTY))
FREE_PCT=$((MEMFREE * 100 / MEMTOTAL))

if [ "$FREE_PCT" -lt 15 ]; then
  RAM_COLOR="\e[1;31m"  # Red
else
  RAM_COLOR="\e[1;32m"  # Green
fi

RAM_VISUAL="${RAM_COLOR}${RAM_BAR} ${MEMFREE_MB} MB free\e[0m"

# Storage bars
STORAGE_VISUAL=""
HTML_STORAGE=""
while read -r DEV TOTAL USED AVAIL PCT MOUNT; do
  TOTAL=${TOTAL%G}
  USED=${USED%G}
  AVAIL=${AVAIL%G}

  if [[ -z "$TOTAL" || "$TOTAL" -eq 0 ]]; then continue; fi

  FILLED=$((USED * BAR_LENGTH / TOTAL))
  EMPTY=$((BAR_LENGTH - FILLED))
  BAR=$(printf "%0.s█" $(seq 1 $FILLED))
  BAR+=$(printf "%0.s░" $(seq 1 $EMPTY))

  STORAGE_VISUAL+="\e[1;35m+ \e[1;37mDisk ($MOUNT) \e[1;35m= \e[1;32m$BAR  ${AVAIL} GB left\n"
  HTML_STORAGE+="<div><b>Disk ($MOUNT)</b>: <span style='font-family:monospace;'>$BAR</span> — $AVAIL GB left</div>"
done < <(df -BG | awk '$1 ~ /^\/dev\// {print $1, $2, $3, $4, $5, $6}')

# User group check
if [[ $GROUPZ == *irc* ]]; then
  ENDSESSION=$(grep "@irc" /etc/security/limits.conf | grep maxlogins | awk '{print $4}')
  PRIVLAGED="IRC Account"
else
  ENDSESSION="Unlimited"
  PRIVLAGED="Regular User"
fi

if [ "$(id -un)" == "root" ]; then
  PRIVLAGED="Root User"
fi

# Display MOTD
echo -e "\e[1;37m"
figlet -f standard "$(hostname)"

echo -e "\e[1;35m+++++++++++++++++: \e[1;37mMachine Info\e[1;35m :+++++++++++++++++++
\e[1;35m+ \e[1;37mhostname \e[1;35m = \e[1;32m$(hostname)
\e[1;35m+ \e[1;37mAddress  \e[1;35m = \e[1;32m$IPADDRESS
\e[1;35m+ \e[1;37mKernel   \e[1;35m = \e[1;32m$(uname -r)
\e[1;35m+ \e[1;37mUptime   \e[1;35m = \e[1;32m$UPTIME
\e[1;35m+ \e[1;37mCPU      \e[1;35m = \e[1;32m$CPU
\e[1;35m+ \e[1;37mGPU      \e[1;35m = \e[1;32m$GPU
$STORAGE_VISUAL\e[1;35m+ \e[1;37mRAM      \e[1;35m = $RAM_VISUAL
\e[1;35m++++++++++++++++++: \e[1;37mUser Info\e[1;35m :+++++++++++++++++++++
\e[1;35m+ \e[1;37mUsername  \e[1;35m = \e[1;32m$(whoami)
\e[1;35m+ \e[1;37mPrivlages \e[1;35m = \e[1;32m$PRIVLAGED
\e[1;35m+ \e[1;37mSessions  \e[1;35m = \e[1;32m$(who | grep $USER | wc -l) of $ENDSESSION MAX
\e[1;35m+ \e[1;37mProcesses \e[1;35m = \e[1;32m$PROCCOUNT of $(ulimit -u) MAX
\e[1;35m+ \e[1;37mPackages  \e[1;35m = \e[1;32m$(pacman -Qq | wc -l)
\e[1;35m+ \e[1;37mHomecount \e[1;35m = \e[1;32m$(ls /home/$USER/ | wc -l)
\e[1;35m++++++++++++++++++++++++++++++++++++++++++++++++++++\e[0m"

# Export to HTML
HTML_OUTPUT="$HOME/motd.html"
cat > "$HTML_OUTPUT" <<EOF
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>System MOTD</title>
  <style>
    body { font-family: monospace; background: #111; color: #eee; padding: 20px; }
    .header { font-size: 24px; color: cyan; }
    .section { margin-top: 20px; }
    .bar { color: lime; }
    .warn { color: red; }
  </style>
</head>
<body>
  <div class="header">$(hostname)</div>
  <div class="section"><b>Address:</b> $IPADDRESS<br>
  <b>Kernel:</b> $(uname -r)<br>
  <b>Uptime:</b> $UPTIME<br>
  <b>CPU:</b> $CPU<br>
  <b>GPU:</b> $GPU<br>
  </div>
  <div class="section">
    <b>Memory:</b>
    <span class="${FREE_PCT}<15 ? 'warn' : 'bar'">$RAM_BAR</span> — $MEMFREE_MB MB free
  </div>
  <div class="section">
    $HTML_STORAGE
  </div>
  <div class="section">
    <b>User:</b> $(whoami) ($PRIVLAGED)<br>
    <b>Sessions:</b> $(who | grep $USER | wc -l) of $ENDSESSION MAX<br>
    <b>Processes:</b> $PROCCOUNT of $(ulimit -u) MAX<br>
    <b>Packages:</b> $(pacman -Qq | wc -l)<br>
    <b>Home files:</b> $(ls /home/$USER/ | wc -l)
  </div>
</body>
</html>
EOF

echo -e "\e[1;36mSaved HTML report to:\e[0m $HTML_OUTPUT"
