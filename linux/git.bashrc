#!/bin/bash
if [ "$bashrcgit" ]; then
    return
fi
export bashrcgit="bashrc-git"

#===============================================================
# Git
#===============================================================
alias gst='git status'
alias gad='git add .'
alias gac='git add . && git commit'
alias gcm='git commit'
alias gam='git commit -am'
alias gpr='git pull --rebase'
alias gbr='git branch'
alias gps='git push'
# Reset code
alias grt='git reset --hard HEAD && git clean -fd && git pull --rebase'

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
