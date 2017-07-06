#!/bin/bash
if [ "$bashrcsystem" ]; then
    return
fi
export bashrcsystem="bashrc-system"

#===============================================================
# System
#===============================================================
# 设置开启为256色
if [ "$TERM" == "xterm" ]; then
    export TERM=xterm-256color
fi
eval `dircolors ~/.dir_colors/dircolors/dircolors.256dark`

# open folder
alias of='nautilus'

# cd
alias ..='cd ..'

# grep
alias grepir='grep -inr '

# tar -xvzf
alias untar='tar -xvzf'

#ccache
export USE_CCACHE=1
export CCACHE_DIR=/work/.ccache

# history show date & time
export HISTTIMEFORMAT="%F %T "

echogreen(){
    echo -e "\033[0;32m$1\033[00m"
}

echored(){
    echo -e "\033[0;31m$1\033[00m"
}

echoerror(){
    echored "                   .-\"      \"-. "
    echored "                  /            \  "
    echored "                 |              | "
    echored "                 |,  .-.  .-.  ,| "
    echored "                 | )(__/  \__)( | "
    echored "                 |/     /\     \| "
    echored "                 (_     ^^     _) "
    echored "                  \__|IIIIII|__/  "
    echored "                   |-\IIIIII/-|   "
    echored "                   \          /   "
    echored "                    \`--------\`  "
}
