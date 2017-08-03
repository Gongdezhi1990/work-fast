#!/bin/bash
if [ "$bashrcandroid" ]; then
    return
fi
export bashrcandroid="bashrc-android"

#===============================================================
# Android develop
#===============================================================
# copy file(s) to vendor with parents path
# usage   : cptovendor <path> [<path>...]
# param   : file(s) path
# example : cptovendor packages/apps/Settings/Android.mk packages/apps/Settings/AndroidManifest.xml
function cptv(){
    if [ ! "$VENDOR_SOURCE_PATH" ]; then
        echoRed "Please set 'VENDOR_SOURCE_PATH' first ."
        return
    fi
    
    for src in $@
    do
        dest=$VENDOR_SOURCE_PATH/$src
        if [ "$src" = "" ] || [ ! -f $src ] ; then
            echoRed "Source file is not exist, please check!"
            echoError
        else
            if [ -f $dest ] ; then
                echo $dest
                echoRed "Target is already exsit, do you want to override it ? (y/n/c)"
                read yesno
                if [ $yesno = "y" ] || [ $yesno = "Y" ]; then   # 覆盖
                    rm $dest
                elif [ $yesno = "c" ] || [ $yesno = "C" ]; then # 对比
                    vimdiff $src $dest
                    continue
                else                                            # Do nothing...
                    continue
                fi
            fi

            cp --parents $src $VENDOR_SOURCE_PATH

            if [ $? -eq 0 ] ; then
                echoGreen "--> $dest"
            else
                echoRed "Copy error!"
                echoError
            fi
        fi
    done
}

# cd 到客户source目录
# usage   : cdtv
# param   : 
# example : 
function cdtv(){
    if [ ! "$VENDOR_SOURCE_PATH" ]; then
        echoRed "Please set 'VENDOR_SOURCE_PATH' first ."
        return
    fi
    cd $VENDOR_SOURCE_PATH
}

# 对比公版和客户文件夹中的文件
# usage   : cmptv <path> [b]
# param   : <path> 公版文件的路径
#           b      使用bcompare, 默认为vimdiff
# example : 
function cmptv(){
    if [ ! "$VENDOR_SOURCE_PATH" ]; then
        echoRed "Please set 'VENDOR_SOURCE_PATH' first ."
        return
    fi
    
    if [ "$1" = "" ] ; then
        echo "Error param !"
        echoError
    else
        if [ "$2" = "b" ] ; then
            bcompare $1 $VENDOR_SOURCE_PATH$1
        else
            vimdiff $1 $VENDOR_SOURCE_PATH$1
        fi
    fi
}

# 对比公版和客户文件夹中的文件
# usage   : vdtv <path>
# param   : <path> 公版文件的路径
# example : 
function vdtv(){
    cmptv $1 v
}

# 对比公版和客户文件夹中的文件
# usage   : bctv <path>
# param   : <path> 公版文件的路径
# example : 
function bctv(){
    cmptv $1 b
}

# set vendor path
# usage   : setvp <path>
# param   : <path> 客户文件夹source路径
# example : 
function setvp(){
    # 确保以”/”结尾
    if [[ "$1" =~ "source/" ]]; then
        local path=$1
    else
        local path=$1/
    fi

    if [ -d ${path} ]; then
        export VENDOR_SOURCE_PATH=${path}
    else
        echoRed "'$1' is not exist !!!"
    fi
}

# 编译模块,会在工程根目录下生成make.log文件供"adbp"命令解析将mk结果push到手机中
# mk <path>      - 如果没有指定path，编译当前所在文件夹
#                  如果指定path，编译指定路径的模块
# mk framework   - 编译整个框架
# mk systemimage - 编译system.img
function mk(){
    local ppath=`pwd`
    while [ ! -f "${ppath}/scm-using.sh" ]; do
        ppath="${ppath}/.."
    done
    local logFile="${ppath}/make.log"

    if [[ "$1" != "" && -e "$1/Android.mk" ]] ; then
        mmm -j8 $1 2>&1 | tee ${logFile}
        highlightShowInstall ${logFile}
    elif [[ "$1" = "" && -e "./Android.mk" ]] ; then
        mm -j8 2>&1 | tee ${logFile}
        highlightShowInstall ${logFile}
    elif [[ "$1" = "framework" || "$1" = "systemimage" ]] ; then
        make -j8 $1 2>&1 | tee ${logFile}
        highlightShowInstall ${logFile}
    else
        echoRed "Nothing to mk !"
    fi
}

# 编译模块以及依赖模块, 会在工程根目录下生成make.log文件供"adbp"命令解析将mk结果push到手机中
# usage   : mk <path>
# param   : <path> 如果没有指定path，编译当前所在文件夹的模块以及其依赖的模块
#                  如果指定path，编译指定路径的模块以及其依赖的模块
# example : 
function mka(){
    local ppath=`pwd`
    while [ ! -f "${ppath}/scm-using.sh" ]; do
        ppath="${ppath}/.."
    done
    local logFile="${ppath}/make.log"

    if [[ "$1" != "" && -e "$1/Android.mk" ]] ; then
        mmma -j8 $1 2>&1 | tee ${logFile}
        highlightShowInstall ${logFile}
    elif [[ "$1" = "" && -e "./Android.mk" ]] ; then
        mma -j8 2>&1 | tee ${logFile}
        highlightShowInstall ${logFile}
    else
        echoRed "Nothing to mk !"
    fi
}

# 高亮显示编译结果
# usage   : startActivity <component>
# param   : <component>
# example : 
function highlightShowInstall(){
    if [[ "$1" != "" && -e "$1" && "`cat $1 | grep -c "Install:"`" != 0 ]] ; then
        for path in `cat $1 | grep "Install: " | sed 's/^.*Install:\s*//'`
        do
            echoGreen $path
        done
    else
        echoRed "No installed modules in $1 !"
    fi
}

# 在Android.mk中添加"LOCAL_DEX_PREOPT := false"，即不提取odex
# usage   : ndex <Android.mk-path>
# param   : Android.mk 路径
# example : 
function ndex(){
    if [[ `egrep -c "LOCAL_PACKAGE_NAME :=|LOCAL_MODULE :=" $1` > 0 ]] ; then
        sed '/LOCAL_PACKAGE_NAME :=\|LOCAL_MODULE :=/a\LOCAL_DEX_PREOPT := false' -i $1

        cat $1 | egrep "LOCAL_PACKAGE_NAME :=|LOCAL_MODULE :=|LOCAL_DEX_PREOPT :=" | while read line
        do
            local result=$(echo $line | grep "LOCAL_DEX_PREOPT := false") 
            if [ "$result" != "" ]; then
                echo -e "\033[36m+${line}\033[0m"
            else
                echo ${line}
            fi 
        done
    else
        echoRed "Not find \"LOCAL_PACKAGE_NAME\" or \"LOCAL_MODULE\" in this file !"
    fi
}
