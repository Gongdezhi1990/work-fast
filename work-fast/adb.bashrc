#!/bin/bash
if [ "$bashrcadb" ]; then
    return
fi
export bashrcadb="bashrc-adb"

#===============================================================
# adb
#===============================================================

# 设置adb路径
export PATH=$PATH:/home/segon/work/tools/adb.1.0.32

alias adbr='adb remount '
alias adbk='adb kill-server && adb start-server && adb remount '
alias adbl='adb logcat'
alias adbs='adb shell'
# 得到当前屏幕是哪个Activity
alias adbfa="adb shell dumpsys activity | grep mFocusedActivity"   
# 恢复出厂设置
alias adbfr='adb shell am broadcast -a android.intent.action.MASTER_CLEAR'
# 查看内存信息
alias adbmem="adb shell dumpsys meminfo"      
# 查看CPU信息
alias adbcpu="adb shell cat /proc/cpuinfo"     
# 启动一个Activity
alias adbsa='startActivity '                   

# 启动一个Activity
# usage   : startActivity <component>
# param   : <component>
# example : 
function startActivity(){
    adb shell am start -n $1
}

# 截屏并保存到PC端
# usage   : adbcap [<file-name>]
# param   : 文件名字,如果不指定,则以"手机型号-当前时间"命名。
# example : adbcap
#           adbcap name
function adbcap(){
    local name=`adb shell getprop ro.product.name`
    if [ $? -eq 0 ] ; then
        if [ "$1" = "" ]; then
            local fileName=${name}-`date +%m%d%k%M%S`
        else
            local fileName=${1}
        fi
        adb shell screencap -p /sdcard/${fileName}.png && adb pull /sdcard/${fileName}.png
        echoGreen "--> ${fileName}.png"
    fi
}

# 快速将编译生成的模块push到手机中，注意模块的路径
# usage   : adbp [<path>...]
# param   : 文件路径，“"out/target/product/<ProjectName>/"开头
#           如果指定，则push指定的apk(s)；
#           如果没指定，则检查工程根目录下的make.log文件
# example : adbp out/target/product/a3658/system/app/Email/Email.apk
function adbp(){
    if [ $# -gt 0 ]; then
        adb remount
        for path in $@
        do
            adbPushExt $path
        done
    elif [ -f "./make.log" ]; then
        adb remount
        for path in `cat ./make.log | grep "Install: " | sed 's/^.*Install:\s*//'` 
        do 
            adbPushExt $path
        done
    else
        echoRed "Do nothing !"
    fi
}

# Push files into phone
# usage   : adbp <path>
# param   : file's path, must start with "out/target/product/projectname/"
# example : adbp out/target/product/a3658/system/app/Email/Email.apk
function adbPushExt(){
    local path=$1

    if [ "$path" = "" ] || [ ! -f $path ] ; then
        echoGreen "Source file is not exist, please check!"
    else
        local dir=`dirname $path`
        dir=`echo $dir | sed 's/out\/target\/product\/[a-z0-9A-Z._-]*\///g'`
        echoGreen "adb push $path $dir"
        adb push -p $path $dir
        if [ $? -ne 0 ]; then
            echoError
        fi
    fi
}

# 杀掉手机中进程
# usage   : adbkill <keyword>
# param   : <keyword>, 需要杀死的进程名称关键字
# example : adbkill systemui
function adbkill(){
    pid=0

    OLD_IFS="$IFS"
    IFS=";"
    process=(`adbs ps | grep -i $1 | awk '{printf("%s\t%s\n;", $2, $9)}'`)
    IFS="$OLD_IFS"
    
    length=${#process[@]}

    if [ $length -eq 1 ] ; then
        pid=`echo ${process[0]} | awk '{printf $1}'`
    	echoGreen "killed -> ${process[0]}"
        adb shell kill $pid
    elif [ $length -gt 1 ]; then
        for i in "${!process[@]}"; do 
            printf "%s\t%s" "$i" "${process[$i]}"
        done

        echo -n "For many options, please enter index :"
        read index

        if [ "$index" != "" ] ; then
            if [[ "$index" -ge 0 && "$index" -lt "$length" ]] ; then
                pid=`echo ${process[$index]} | awk '{printf $1}'`
                echoGreen "killed -> ${process[$index]}"
                adb shell kill $pid
            else
                echoRed "Error index!"
            fi
        fi
    else
        echoRed "Not find !!!"
    fi
}

# 开发时要改的一些设置
function adbdev(){
    # 充电时手机常亮
    adbSetSetting global stay_on_while_plugged_in 3
    # 灭屏时间30分钟
    adbSetSetting system screen_off_timeout 1800000
}

function adbSetSetting(){
    local filed=$1
    local name=$2
    local value=$3

    local LENGTH=-25
    adb shell settings put $filed $name $value
    printf "\033[0;32m%s %${LENGTH}s --> %s\033[00m\n" "$filed" "$name" "$value"
}

# 打开mtklog界面
alias omtk='startActivity com.mediatek.mtklogger/.MainActivity'

# 删除手机中的mtklog文件夹
alias dmtk='adb shell rm -rf /sdcard/mtklog'

# 停止mtklogger
alias smtk='adb shell am broadcast -a com.mediatek.mtklogger.ADB_CMD -e cmd_name stop --ei cmd_target 23'

# 重新启动mtklogger，并指定target，注意手机重启会导致选定的target失效
# usage   : adbkill [<target>]
# param   : <target>, 1/2/4/16，分别代表MobileLog/ModemLog/NetworkLog/GPSLog, 可以用"或"进行多选
#           比如'23'表示全部打开
# example : 
function rsmtk(){
    adb shell am broadcast -a com.mediatek.mtklogger.ADB_CMD -e cmd_name stop --ei cmd_target 23

    echo "sleep 3s ..."
    sleep 3

    adb shell rm -rf /sdcard/mtklog

    if [ $# -eq 0 ] ; then
        adb shell am broadcast -a com.mediatek.mtklogger.ADB_CMD -e cmd_name start --ei cmd_target 1
    else
        adb shell am broadcast -a com.mediatek.mtklogger.ADB_CMD -e cmd_name start --ei cmd_target $1
    fi
}

# 将手机中的mtklog拷贝到~/log目录下
function pmtk(){
    local state=`adb get-state`
    if [ "$state" = "device" ] ; then
        local name=`adb shell getprop ro.product.name`
        if [ "$1" = "" ]; then
            local folderName=${name}-`date +%m%d%k%M`
        else
            local folderName=${name}-`date +%m%d%k%M`-${1}
        fi
        local logPath=~/log/${folderName}/mtklog
        mkdir -p "${logPath}"
        adb pull /sdcard/mtklog "${logPath}"
        echo "mtklog is saved in :"
        echoGreen "--> ${logPath}"
    fi
}

