#!/bin/bash

#Program name "Triangle Trigonometry I/O"
#Author: Isaiah Vogt
#This file is the script file that accompanies the "Triangle Trigonometry I/O" program.
#Prepare for execution in normal mode (not gdb mode).

#Delete some un-needed files
rm *.o
rm *.out

#Assemble isfloat.asm
nasm -f elf64 -o isfloat1.o isfloat1.1.asm

#Assemble source file `manager.asm`
nasm -f elf64 -l mgr.lis -o mgr.o manager.asm

#Compile source file `driver.c`
gcc -m64 -no-pie -std=c2x -o driver.o -c driver.c

#Link the object modules to create an executable file
gcc -m64 -no-pie -std=c2x -o trig.out isfloat1.o driver.o mgr.o -lm

#grant all privileges
chmod +x trig.out

#execute
./trig.out
