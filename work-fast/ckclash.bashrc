#!/bin/bash
if [ "$bashrcckclash" ]; then
    return
fi
export bashrcckclash="bashrc-ckclash"

#===============================================================
# check clash
#===============================================================
# 检查代码冲突,可检查所有客户也可以检查单个客户，详见帮助输出内容
# usage   : ckc <start-commit> <end-commit> [<vendor-path>]
# param   : <vendor-path>  如果省略，默认检查所有客户目录；"
#                          如果为\"vendor/dewav/proprietary/custom_folder/source/\", 则只检查指定客户目录。"
#                          注意路径要以\"/\"结尾！"
# example : 
function ckc(){
    if [[ $3 = "" ]]; then
        for path in `tree -L 1 -ifd "vendor/dewav/proprietary/" | egrep "[a-z][0-9]{4}" | sed "/_dw/d"`
        do
            echo -e "\033[0;32m--> $path\033[00m"
            path=$path"/source/"
            files=`find $path -type f`
            git diff --name-only $1..$2 -- ${files//$path/} 2>&1 | tee check.clash.temp
            echo
        done
        rm check.clash.temp
    elif [[ $3 = *"source/" ]]; then
        files=`find $3 -type f`
        git diff --name-only $1..$2 -- ${files//$3/} 2>&1 | tee check.clash.temp
        rm check.clash.temp
    else
        echo "Usage: ckc <start-commit> <end-commit> [<vendor-path>]"

        echo "<vendor-path> : 如果省略，默认检查所有客户目录；"
        echo "                如果为\"vendor/dewav/proprietary/custom_folder/source/\", 则只检查指定客户目录。"
        echo "                注意路径要以\"/\"结尾！"
        echo "Demo:"
        echo "    检查两个commit之间所有客户的冲突："
        echo "        ckc 47fdc5f 617497e"
        echo "    检查两个commit之间\"i6369_dtac-s3\"是否有冲突："
        echo "        ckc 47fdc5f 617497e vendor/dewav/proprietary/i6155_dtac-s3/source/"
    fi
}

# 检查最后编译版本到HEAD之间，是否存在代码冲突
# 参数 1： 检索tag的关键字
# 参数 2： vendor中客户目录的名字
# 示  例： ckv I6155_I61551_DTAC-S3_ i6155_dtac-s3
function ckv(){
    local lastTag=`git tag --sort=-creatordate -l ${1}* | head -n 1`
    if [ ! -z $lastTag ]; then
        echo -e "\033[0;32m--> last tag is: $lastTag\033[00m"
        ckc ${lastTag} HEAD "vendor/dewav/proprietary/${2}/source/"
    else
        echo "Not find tag !"
    fi
}

# 快捷命令，检查指定客户目录
function cki6155dtac(){
    ckv I6155_I61551_DTAC-S3_ i6155_dtac-s3
}
function ckb3679dtac(){
    ckv B3679_DB36792_DTAC-T3_ b3679_dtac-t2n
}
