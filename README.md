## Custom Pubterminal Settings

Displays the stuff below in terminal everytime you load up the terminal or sign into ssh
* hostname
* cpu
* address
* Uptime
* memory
* username
* privlages
* sessions
* processes
* packages
* 

```shell
cp motd.sh /etc/profile.d
cp config /.config/terminator/
cp .bashc /home/$USER/
cp .bashrc /usr/share/fonts/
```



# ![image](https://github.com/briggsoft/Pubterminalsettings/blob/master/images/pubterm.png?raw=true)

## Dependencies
Figlet package and PxPlus IBM VGA 10 font have to be installed

http://www.figlet.org/

https://github.com/briggsoft/Pubterminalsettings/blob/master/font/PxPlus_IBM_VGA8.ttf

[.bashrc] with my prompt with some shopt commands
and [config] is a terminator config file 

will be making a pkg soon.
