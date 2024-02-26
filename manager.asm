; //*****************************************************************************************************************************
; //Program name: "Triangle Trigonometry I/O".  This program provides user inputs for two sides of a triangle and the angle     *
; // between them. Then the program calculates the length of the third side of the triangle. This value is then sent to the     *
; // driver.c file as a means of demonstrating successful completion. This program demonstrates input validation by rejecting   *
; // all badly formed inputted numbers and negative numbers. The file isfloat.asm is used for this process and was retrieved    *
; // from https://sites.google.com/a/fullerton.edu/activeprofessor/4-subjects/x86-programming/library-software/isfloat-x86-only *
; // and was modified to include negative number validation. Copyright (C) 2024 Isaiah Vogt. *                                  *
; //                                                                                                                            *
; // "Triangle Trigonometry I/O" is free software: you can redistribute it and/or modify it under the terms of the GNU General  *
; // Public License version 3 as published by the Free Software Foundation. Average Driving Time is distributed in the hope     *
; // that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A    *
; //PARTICULAR PURPOSE.  See the GNU General Public License for more details. A copy of the GNU General Public License v3 is    *
; // available here:  <https:;www.gnu.org/licenses/>.                                                                           *
; //*****************************************************************************************************************************


; //=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
; //
; //Author information
; //  Author name: Isaiah Vogt
; //  Author email: ivogt@csu.fullerton.edu
; //
; //Program information
; //  Program name: Triangle Trigonometry I/O
; //  Programming languages: One modules in C, two modules in X86, and one in bash
; //  Date program began: 2024-Feb-15
; //  Date of last update: 2024-Feb-23
; //  Date of reorganization of comments: 2024-Feb-23
; //  Files in this program: manager.asm, isfloat1.1.asm, driver.c, r.sh
; //  Status: Finished.  The program was tested extensively with no errors in 11.1.0ubuntu4.
; //
; //Purpose
; // This program provides triangle trionometric information and demonstrates input validation for netaive and badly formatted inputted numbers.
; //
; //This file
; //   File name: manager.asm
; //   Language: C
; //   Max page width: 132 columns
; //   Compile: nasm -f elf64 -l mgr.lis -o mgr.o manager.asm
; //   Link: gcc -m64 -no-pie -std=c2x -o trig.out isfloat.o driver.o mgr.o -lm
; //   Optimal print specification: 132 columns width, 7 points, monospace, 8½x11 paper
; //
; //=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
; //
; //
; //===== Begin code area ===========================================================================================================


;Declaration Section.

; C Output library
extern printf

; C Input libraries
extern fgets
extern stdin

; C String Data library
extern strlen

; C output Library
extern scanf

; C math Libraries
extern cos

extern atof ; converts string to float

; isfloat.asm used for error handling invalid user input
extern isfloat1 ; !!check this one


; function used in this file and called in driver.c to run Triangle Trigonometry Calculations and I/O
global trigIO

; *** Note ***
; We are declaring a max size for our string input variables here.
;   We are doing this for two reasons: security and hardware limitations. The C library function fgets allows us to specify a specific
;   buffer length in order to prevent the user from inputting function pointers, executable code, or excessively long strings.
;   See this geeksforgeeks article for more information: https://www.geeksforgeeks.org/why-to-use-fgets-over-scanf-in-c/
; ***End of Note ***

; max length of user's inputted name
name_string_size equ 48

; max length of user's inputted title
title_string_size equ 56

segment .data ; initialized variables

; dialogue for collecting user's identifier input
prompt_for_name db 10, "Please enter your name: ", 0
prompt_for_title db 10, "Please enter your title (Sargent, Chief, CEO, President, Teacher, etc): ", 0

; friendly messages

tic_first_output db 10, "The starting time on the system clock is %llu tics.", 10, 0
friendly_message db 10, "Good morning %s %s. We take care of all your triangles.", 10, 0
data_confirm_message db 10, "Thank you %s. You entered %1.6lf %1.6lf and %1.6lf.", 10, 0
driver_send_confirmation db 10, "This length will be sent to the driver program.", 10, 0
tic_second_output db 10, "The final time on the system clock is %llu tics.", 10, 0

departure_message db 10, "Have a good day %s %s.", 10, 0

; dialogue for collecting user's length and angle inputs
prompt_for_first_length db 10, "Please enter the length of the first side: ", 0
prompt_for_second_length db "Please enter the length of the second side: ", 0
prompt_for_angle db "Please enter the size of the angle in degrees: ", 0

; Computation Outputs
output_third_side db 10, "The length of the third side is %1.6lf.", 10, 0

; Error Message
error_message db "The input is invalid. Please try again.", 10, 0

string_input_format db "%s", 0

; Constants
pi dq 3.141592
radToDeg dq 180.0

two dq 2.00

zero dq 0.00

segment .bss

align 64

backup_storage_area resb 832

; variables storing user's inputted name and title
; !!!!!!!!!!!!!!!Are there any better ways to store these!!!!!!!!!!!
user_name resb name_string_size
user_title resb title_string_size

segment .text
trigIO:

; ------------- Back up the GPRs -------------
push rbp
mov rbp, rsp
push rbx
push rcx
push rdx
push rdi
push rsi
push r8
push r9
push r10
push r11
push r12
push r13
push r14
push r15
pushf

; ------------- Backup the registers other than the GPRs -------------
mov rax,7
mov rdx,0
xsave [backup_storage_area]

; -------------------------- Get number of ticks since pc boot --------------------------
mov rax, 0
mov rdx, 0
cpuid
rdtsc

shl rdx, 32
add rax, rdx
mov r12, rax 

mov rdi, tic_first_output
mov rsi, r12
call printf

; ------------- Output for Collecting User's name -------------
mov rax, 0
mov rdi, prompt_for_name
call printf

; ------------- Input for Collecting user's name -------------
mov rax, 0

; destination for input
mov rdi, user_name

; max size of input
mov rsi, name_string_size

; third paramater of fgets, holding standard input
mov rdx, [stdin]
; function for reading and writing from input
call fgets 


; ------------- Remove newline for user's name -------------
mov rax, 0

; first parameter for strlen, retrieving data to read from
mov rdi, user_name

; function for calculating length of a string
call strlen

; *******Check this*************removes newline by replacing the newline character with a byte of 0( 8 bits )
mov [user_name+rax-1], byte 0


; ------------- Output for collecting User's title -------------
mov rax, 0
mov rdi, prompt_for_title
call printf

; ------------- Input for Collecting User's title -------------
mov rax, 0
mov rdi, user_title
mov rsi, title_string_size
mov rdx, [stdin]
call fgets

; ------------- Remove newline for user's title
mov rax, 0
mov rdi, user_title
call strlen
mov [user_title+rax-1], byte 0

; ------------- Friendly message for user -------------
mov rax, 0
; Output array
mov rdi, friendly_message
mov rsi, user_title
mov rdx, user_name
call printf

; **************************************************************************** Beginning of loop ****************************************************************************
; First label
begin_loop:


; ------------- Output for collecting length of the first side -------------
mov rax, 0
mov rdi, prompt_for_first_length
call printf

; ------------- Input for collecting length of the first side -------------

mov rax, 0 ; one float value is being collected
push qword 0
push qword 0
mov rdi, string_input_format ; "%s"

mov rsi, rsp
call scanf

; Block to validate the recent input
mov rax, 0
mov rdi, rsp
call isfloat1

; store return value from isfloat in r15
mov r15, rax ; will this work with rsp instead of rax



; compare return value of isfloat, stored in r15, to 0.
cmp r15, 0

; jump to error_message if 
je first_input_error

; clean up r15
mov r15, 0



; -------------------------- Convert length of the first side string to float --------------------------

; One float is being passed
mov rax, 1
mov rdi, rsp 
call atof
movsd xmm10, xmm0

pop rax 
pop rax

; Second label
loop_second:

; ------------- Output for collecting length of the second side -------------
mov rax, 0
mov rdi, prompt_for_second_length
call printf

; ------------- Input for collecting length of the second side -------------

mov rax, 0 ; one float value is being collected
push qword 0
push qword 0
mov rdi, string_input_format ; "%s"

mov rsi, rsp

call scanf

; Block to validate the recent input
mov rax, 0
mov rdi, rsp
call isfloat1

; store return value from isfloat in r15
mov r15, rax ; will this work with rsp instead of rax


; compare return value of isfloat, stored in r15, to 0.
cmp r15, 0

; jump to error_message if 
je second_input_error

; Clear out r15 register
mov r15, 0

; -------------------------- Convert length of the second side string to float --------------------------

; One float is being passed
mov rax, 1

mov rdi, rsp 
call atof
movsd xmm11, xmm0

pop rax 
pop rax

; third label
loop_third:

; ------------- Output for collecting angle in degrees -------------
mov rax, 0
mov rdi, prompt_for_angle
call printf

; ------------- Input for collecting angle in degrees -------------

mov rax, 0 ; one float value is being collected
push qword 0
push qword 0
mov rdi, string_input_format ; "%s"

mov rsi, rsp

call scanf

; Block to validate the recent input
mov rax, 0
mov rdi, rsp
call isfloat1

; store return value from isfloat in r15
mov r15, rax ; will this work with rsp instead of rax

; compare return value of isfloat, stored in r15, to 0.
cmp r15, 0

; jump to error_message if 
je third_input_error

; Clear out r15 register
mov r15, 0

; -------------------------- Convert the angle to float --------------------------

; One float is being passed
mov rax, 1
mov rdi, rsp
call atof
movsd xmm12, xmm0


pop rax 
pop rax

jmp message_and_conclusion

; --------------------------------------- first_input_error ---------------------------------------
first_input_error:
pop rax 
pop rax
mov rax, 0
mov rdi, error_message
call printf


; go back to beginning of loop
jmp begin_loop

; --------------------------------------- second_input_error ---------------------------------------

second_input_error:
pop rax 
pop rax
mov rax, 0
mov rdi, error_message
call printf

jmp loop_second

; --------------------------------------- third_input_error ---------------------------------------
third_input_error:
pop rax 
pop rax
mov rax, 0
mov rdi, error_message
call printf
jmp loop_third

; --------------------------------------- end of error handling ---------------------------------------

message_and_conclusion:
; ------------- Friendly message for input validation -------------

mov rax, 1

; Move the inputted values into the first three parameters to be outputted



movsd xmm0, xmm10
movsd xmm1, xmm11
movsd xmm2, xmm12

mov rdi, data_confirm_message
mov rsi, user_name
call printf


; --------------------------------------- Calculate third side ---------------------------------------
; convert angle to radians: (angle * 3.141592) / 180
; formula is c = sqrt(a^2 + b^2 - 2abcos(theta))


; ------------- Convert angle to radians: answer = (angle * 3.141592) / 180 -------------
; answer is stored in xmm13
mov rax, 1

; Multiply angle by pi
mulsd xmm12, qword [pi]

; Divide product by 180 to complete computation of angle to radians
divsd xmm12, qword [radToDeg]

; Move Quotient into xmm0 to be used in the called cosin function
movsd xmm0, xmm12
call cos

; Store calculation in xmm13
movsd xmm13, xmm0

; ------------- answer=  2 * first length * second length * cos(angle) -------------
; answer is stored in xmm13
mov rax, 1

; multiply cos(angle) * 2
mulsd xmm13, qword [two]

; multiply by first length
mulsd xmm13, xmm10

; multiply by second length
mulsd xmm13, xmm11

; ------------- answer = first_length^2 + second_length^2 -------------
; answer is stored in xmm10

; first length squared
mulsd xmm10, xmm10


; second length squared
mulsd xmm11, xmm11

; add squares together. Sum is held in xmm10
addsd xmm10, xmm11

; ------------- answer = a^2 + b^2 - 2abcos(theta) -------------
; answer is stored in xmm10

subsd xmm10, xmm13

; ------------- third_side = sqrt(a^2 + b^2 - 2abcos(theta) -------------
; third_side is stored in xmm14
sqrtsd xmm14, xmm10

; --------------------------------------- Output third side length ---------------------------------------
mov rax, 1
mov rdi, output_third_side


movsd xmm0, xmm14
call printf


; --------------------------------------- Confirm third side length is being sent to driver.c ---------------------------------------
mov rax, 0
mov rdi, driver_send_confirmation
call printf

; -------------------------- Get number of ticks since pc boot --------------------------
mov rax, 0
mov rdx, 0
cpuid
rdtsc

shl rdx, 32
add rax, rdx
mov r12, rax 

mov rdi, tic_second_output
mov rsi, r12
call printf

; --------------------------------------- Departure message ---------------------------------------

mov rax, 0
mov rdi, departure_message
mov rsi, user_title
mov rdx, user_name
call printf

; Store length of third side in rsp before SSE registers get wiped
push qword 0

movsd [rsp], xmm14

;Restore the values to non-GPRs
mov rax,7
mov rdx,0
xrstor [backup_storage_area]

; Send length of third side to driver.c
movsd xmm0, [rsp]
pop rax


;Restore the GPRs
popf
pop r15
pop r14
pop r13
pop r12
pop r11
pop r10
pop r9
pop r8
pop rsi
pop rdi
pop rdx
pop rcx
pop rbx
pop rbp   ;Restore rbp to the base of the activation record of the caller program
ret
;End of the function trigIO ====================================================================

