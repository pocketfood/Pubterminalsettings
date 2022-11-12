# This changes terminal bash text you can also embed commands to it
# each time you make a command it updates

## Prompt with command history
export PROMPT_COMMAND='export H1="`history 1|sed -e "s/^[\ 0-9]*//; s/[\d0\d31\d34\d39\d96\d127]*//g; s/\(.\{1,50\}\).*$/\1/g"`";history -a;echo -e "sgr0\ncnorm\nrmso"|tput -S'
export PS1='\n\e[1;30m[\j:\!\e[1;30m]\e[0;36m \T \d \e[1;30m[\e[1;34m\u@\H\e[1;30m:\e[0;37m`tty 2>/dev/null` \e[0;32m+${SHLVL}\e[1;30m] \e[1;37m\w\e[0;37m\[\033]0;[ ${H1}... ] \w - \u@\H +$SHLVL @`tty 2>/dev/null` - [ `uptime` ]\007\]\n\[\]\$ '
## Backup prompts
#GREEN="\[$(tput setaf 2)\]"
#RESET="\[$(tput sgr0)\]"
#export PS1="${GREEN}S*M*A*S*H${RESET}> "

# ls colors
alias ls='ls -slah --color'
LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'
export LS_COLORS

# those annyoing case sensitive directories.
shopt -s nocaseglob

# append to the history file, dont overwrite it.
shopt -s histappend

# check the window size after each command and if necessary.
# update the values of lines and columns.
shopt -s checkwinsize

# alias definitions (didnt make it yet)
# its in the file ~/.bash_aliases
