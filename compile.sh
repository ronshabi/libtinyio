#!/bin/sh
clear
prog=${1}

nasm -felf64 -g ${prog}.asm -o ${prog}.o
ld ${prog}.o -o ${prog}.out