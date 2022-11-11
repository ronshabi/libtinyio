#!/bin/sh
clear
executable="libtinyio"
executable_suffix="out"
task_compile=""
task_strace="strace"
task=${1}

if [ $task == $task_compile ] ; then
    # build
    nasm -felf64 -g ${executable}.asm -o ${executable}.o
    ld ${executable}.o -o ${executable}.${executable_suffix}
elif [ -a "${executable}.${executable_suffix}" ] && [ $task == $task_strace ] ; then
    # strace if file exists
    ${task_strace} ./${executable}.${executable_suffix}
else
    echo "Target doesn't exist."
fi