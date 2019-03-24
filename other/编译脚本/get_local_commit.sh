#!/bin/bash
####脚本还有问题，可以采取手动指定10代码对应仓库起始commit-id的方式，来一笔 一笔合入。


ROOT_PATH=$(pwd)

function args_parse(){
    local_be_get_code="$1"    #当前仓库 在本地10代码的绝对路径
    [ ! -d "$local_be_get_code" ] && echo "路径不正确" && exit 1
    local_be_get_code_branch="$2"      #当前仓库再本地10代码上的本地分支
    pushd  "$local_be_get_code"
        git br | grep "$local_be_get_code_branch" 
        [ "$?" != "0" ] && echo "分支不存在" && exit 1
    popd
    local_code_branch="$3"     #251代码分支
    git br | grep "$local_code_branch" 
    [ "$?" != "0" ] && echo "分支不存在" && exit 1
}


function get_commit_id_list(){
    current_commit=$(git log --pretty=oneline -1 | awk '{print $1}')       #获取当前仓库的最新commit-id
    pushd "$local_be_get_code"
        update_commit_array=($(git log "${current_commit}"..HEAD --pretty=oneline | awk '{print $1}'))    #到本地10代码 仓库 看看一共有多少笔提交
        git log "${current_commit}"..HEAD --pretty=oneline --format=%s > "$ROOT_PATH"/commit_message.txt   #本地10代码 提交信息
    popd
    commit_len=${#update_commit_array[@]}

    readarray -t update_commit_message_array < commit_message.txt
    message_len=${#update_commit_message_array[@]}
    message_len_1=$(($message_len - 1))
}


function cp_add_commit(){
    for i in $(seq 0 $message_len_1)
    do
        pushd "$local_be_get_code"
            echo "${update_commit_array[$(($message_len_1 - $i ))]}" "${update_commit_message_array[$(($message_len_1 - $i ))]}"   #因为 git log显示的提交信息顺序和我们需要的是相反的。所以数组倒叙输出
            git reset --hard "${update_commit_array[$(($message_len_1 - $i ))]}"  #每次回退一笔
        popd
        cp -a "$local_be_get_code"/* .    #每次覆盖过来，这里只覆盖了。我没有删除哦
    done
    
}


################################

args_parse "$@"
get_commit_id_list
cp_add_commit
