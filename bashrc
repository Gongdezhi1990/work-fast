
#==================== SegonMergeTag ============================
#========================= Begin ===============================
#===============================================================
# System
#===============================================================
# 设置开启为256色
if [ "$TERM" == "xterm" ]; then
    export TERM=xterm-256color
fi
# show folder size
#alias du='du -h --max-depth=1'

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


#
# copy file(s) to vendor with parents path
# param   : file(s) path
# Useage  : cptovendor <path> [<path>...]
# example : cptovendor packages/apps/Settings/Android.mk packages/apps/Settings/AndroidManifest.xml
#
cptovendor(){
    setVendorPathIfNeed
    
    for src in $@
    do
        dest=$VENDOR_SOURCE_PATH/$src
        if [ "$src" = "" ] || [ ! -f $src ] ; then
            echored "Source file is not exist, please check!"
            echoerror
        else
            if [ -f $dest ] ; then
                echo $dest
                echored "Target is already exsit, do you want to override it ? (y/n/c)"
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
                echogreen "--> $dest"
            else
                echored "Copy error!"
                echoerror
            fi
        fi
    done
}

alias cdtovendor='cd $VENDOR_SOURCE_PATH'

compareToVendor(){
    setVendorPathIfNeed
    if [ "$1" = "" ] ; then
        echo "Error param !"
        echoerror
    else
        if [ "$2" = "vim" ] ; then
            vimdiff $1 $VENDOR_SOURCE_PATH$1
        else
            bcompare $1 $VENDOR_SOURCE_PATH$1
        fi
    fi
}

vdtovendor(){
    compareToVendor $1 vim 
}

bctovendor(){
    compareToVendor $1 bcompare 
}

#
# set vendor path
# param   : vendor path
# example : setVendorPathIfNeed
#
setVendorPathIfNeed(){
    if [ "$VENDOR_SOURCE_PATH" = "" ] || [ ! -d $VENDOR_SOURCE_PATH ] ; then
        echo 'Please input vendor source folder path'
        echo 'for example : vendor/dewav/proprietary/d3679_qmobile-s6/source/'
        while true
        do
            read VENDOR_SOURCE_PATH
            if [ ! -d $VENDOR_SOURCE_PATH ] ; then
                echo "Folder is not exsit, please input vendor source folder path:"
            else
                export VENDOR_SOURCE_PATH=$VENDOR_SOURCE_PATH
                break
            fi
        done
    fi        
    #echo "$VENDOR_SOURCE_PATH"
}

#
# mmm module & push result into phone
# param   : module path
# Useage  : mk [-B] <path>
# example : mk -B packages/apps/Email/
#
mk(){
    logFile="mk.log"
    if [ "$1" = "-B" ] ; then
        mmm -B $2 2>&1 | tee ${logFile}
    else
        mmm $1 2>&1 | tee ${logFile}
    fi

    # 有的时候会编译附加的test apk失败，所以单纯以最后编译结果
    # 判定是否要push 是不准确的
    if [ "`cat ${logFile} | grep -c "Install:"`" != 0 ]; then
        adbp `cat ${logFile} | grep "Install: " | sed 's/^.*Install:\s*//'`
    else
        echoerror
    fi
    
    rm ${logFile}
}

#===============================================================
# Tools
#===============================================================
#===============================================================
# Git
#===============================================================
alias gst='git status'
alias gad='git add .'
alias gac='git add . && git commit'
alias gcm='git commit'
alias gpr='git pull --rebase'
alias gbr='git branch'

# 以前: git push origin d35_s35_a35_custom:refs/for/d35_s35_a35_custom
#   或: git push origin HEAD:refs/for/master
# 现在：gpush
#   ps: 本地branch名记得和服务器上的对应，理由自己看下面代码
gpush(){
    branch=`git branch | grep "\*" | awk -F ' '  '{print $2}'`
    echo "Current branch is : $branch"
    if [ "$branch" == "master" ] ; then
        echo "--> git push origin HEAD:refs/for/master"
        git push origin HEAD:refs/for/master
    else
        echo "--> git push origin $branch:refs/for/$branch"
        git push origin $branch:refs/for/$branch
    fi
}

# Reset code
alias grt='git reset --hard HEAD && git clean -fd && git pull --rebase'

#===============================================================
# SVN
#===============================================================
alias rmsvn='find . -type d -name ".svn" | xargs rm -rf'

#===============================================================
# adb
#===============================================================

alias adbr='adb remount '
alias adbrr='adb kill-server && adb start-server && adb remount '
alias adbl='adb logcat '
alias adbs='adb shell '
alias adbcap="adb shell screencap -p | sed 's/\r$//' >"  # 截屏，example: adbcap ~/Desktop/cap.png
alias adbcurrentactivity="adb shell dumpsys activity | grep mFocusedActivity"   # 得到当前屏幕是哪个Activity
alias adbsmem="adb shell cat /proc/meminfo"     # 查看内存信息
alias adbscpu="adb shell cat /proc/cpuinfo"     # 查看CPU信息

#
# Push files into phone
# param   : file's path, must start with "out/target/product/projectname/"
# Useage  : adbp <path> [<path>...]
# example : adbp out/target/product/a3658/system/app/Email/Email.apk
#
adbp(){
    logFile="push.log"

    adb remount
    for path in $@
    do
        if [ "$path" = "" ] || [ ! -f $path ] ; then
            echogreen "Source file is not exist, please check!"
        else
            dir=`dirname $path`
            dir=`echo $dir | sed 's/out\/target\/product\/.....\///g'`
            echogreen "adb push $path $dir"
            adb push -p $path $dir 2>&1 | tee ${logFile}
            if [ "`cat ${logFile} | grep -c "failed"`" != 0 ]; then
                echoerror
            fi
        fi
    done
}

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

#使用说明：比如想杀掉systemui进程，$ adbkill systemui
adbkill(){
    pid=0

    OLD_IFS="$IFS"
    IFS=";"
    process=(`adbs ps | grep -i $1 | awk '{printf("%s\t%s\n;", $2, $9)}'`)
    IFS="$OLD_IFS"
    
    length=${#process[@]}

    if [ $length == 0 ] ; then
    	echogreen "Not find !!!"
    elif [ $length == 1 ] ; then
        pid=`echo ${process[0]} | awk '{printf $1}'`
    	echogreen "kill -> ${process[0]}"
        adb shell kill $pid
    else
        for i in "${!process[@]}"; do 
            printf "%s\t%s" "$i" "${process[$i]}"
        done

        echo -n "For many options, please enter index :"
        read index

        if [ "$index" != "" ] ; then
            if [[ "$index" -ge 0 && "$index" -lt "$length" ]] ; then
                pid=`echo ${process[$index]} | awk '{printf $1}'`
                echogreen "kill -> ${process[$index]}"
                adb shell kill $pid
            else
                echored "Error index!"
            fi
        fi
    fi
}

# 恢复出厂设置
alias adbfactoryreset='adb shell am broadcast -a android.intent.action.MASTER_CLEAR'
#========================== End ================================
