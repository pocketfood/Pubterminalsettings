## Custom Pubterminal Settings

# Motd-Arch
Displays the stuff below in terminal everytime you load up the terminal or sign into ssh
* hostname
* cpu
* gpu
* address
* Uptime
* Kernal
* memory
* username
* privlages
* sessions
* processes
* packages
* User Rules text :)

# ![image](https://github.com/briggsoft/Pubterminalsettings/blob/master/images/pubterm2.png?raw=true)

# Motd-debian
Its a little bit differnt from the Arch one and I plan on merging the two files together
* Hostname
* Address
* Kernal
* Uptime
* Memory
* Username
* Privlages
* Sessions
* Processes
* User Rules text :)


```shell
cp motd.sh /etc/profile.d
cp config /.config/terminator/
cp .bashc /home/$USER/
cp .bashrc /usr/share/fonts/
cp .zshrc /home/$USER/
```



## Dependencies
Figlet package and PxPlus IBM VGA 10 font have to be installed
http://www.figlet.org/


## This font is optional but will look ugly in terminator
https://github.com/briggsoft/Pubterminalsettings/blob/master/font/PxPlus_IBM_VGA8.ttf
[.bashrc] with my prompt with some shopt commands
and [config] is a terminator config file

## Little Notes
will be making a pkg soon for AUR maybe even APT. Shurg.
Planning on making it for multiple distros so far only works for Arch...duh. Of course.
For Debian the figlet text is difffernt but still the text from hostname.
