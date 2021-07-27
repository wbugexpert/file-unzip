#! /usr/bin/env bash

rootPath='/home/cwj/Desktop/test'
desPath='/home/cwj/Desktop/des'

keylist=()
read_key()
{
    while read line ; do
        keylist=("${keylist[@]}" $line)
    done < key.txt
    for i in ${keylist[@]} ; do
        echo $i
    done
}

func()
{
    local path="$1"
    local des="$2"
    for file in $(ls $path);do
        if test -d $path/$file ; then
            mkdir $des/$file
            func $path/$file $des/$file
            continue
        fi
        if [[ $file == *".rar"* ]];then
            tmp=${file//.rar/""}
            mkdir $des/$tmp
            for i in ${keylist[@]} ; do
                rar x -p$i $path/$file -d $des/$tmp
                if [[ $? == 0 ]]; then
                    break
                fi
            done
        elif [[ $file == *".zip"* ]];then
            tmp=${file//.zip/""}
            mkdir $des/$tmp
            for i in ${keylist[@]} ; do
                unzip -P $i $path/$file -d $des/$tmp
                if [[ $? == 0 ]]; then
                    echo 0
                    break
                fi
            done
        elif [[ $file == *".7z"* ]];then
            tmp=${file//.7z/""}
            mkdir $des/$tmp
            7z x $path/$file -o$des/$tmp
        fi
    done
}


read_key
echo [$IFS]
MY_SAVEIFS=$IFS                                                                                                                                         
IFS=$'\n' 
func $rootPath $desPath
IFS=$MY_SAVEIFS
