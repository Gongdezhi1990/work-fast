#!/bin/bash
if [ "$bashrcutils" ]; then
    return
fi
export bashrcutils="bashrc-utils"

#===============================================================
# Utils
#===============================================================

# 输出绿色高亮信息
function echoGreen() {
    echo -e "\033[0;32m$1\033[00m"
}

# 输出红色高亮信息
function echoRed() {
    echo -e "\033[0;31m$1\033[00m"
}

# 输出醒目报错图案
function echoError() {
    echoRed "                   .-\"      \"-. "
    echoRed "                  /            \  "
    echoRed "                 |              | "
    echoRed "                 |,  .-.  .-.  ,| "
    echoRed "                 | )(__/  \__)( | "
    echoRed "                 |/     /\     \| "
    echoRed "                 (_     ^^     _) "
    echoRed "                  \__|IIIIII|__/  "
    echoRed "                   |-\IIIIII/-|   "
    echoRed "                   \          /   "
    echoRed "                    \`--------\`  "
}
