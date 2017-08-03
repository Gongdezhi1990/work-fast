#!/bin/bash
if [ "$bashrcsystem" ]; then
    return
fi
export bashrcsystem="bashrc-system"

#===============================================================
# System
#===============================================================
# 设置开启为256色
#if [ "$TERM" == "xterm" ]; then
    #export TERM=xterm-256color
#fi
#eval `dircolors ~/.dir_colors/dircolors/dircolors.256dark`

# open folder
alias of='nautilus'

# cd
alias ..='cd ..'

# grep
alias grepir='grep -inr '

# tar -xvzf
alias untar='tar -xvzf'

# history show date & time
export HISTTIMEFORMAT="%F %T "

