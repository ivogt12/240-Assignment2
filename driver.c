//*****************************************************************************************************************************
//Program name: "Triangle Trigonometry I/O".  This program provides user inputs for two sides of a triangle and the angle     *
// between them. Then the program calculates the length of the third side of the triangle. This value is then sent to the     *
// driver.c file as a means of demonstrating successful completion. This program demonstrates input validation by rejecting   *
// all badly formed inputted numbers and negative numbers. The file isfloat.asm is used for this process and was retrieved    *
// from https://sites.google.com/a/fullerton.edu/activeprofessor/4-subjects/x86-programming/library-software/isfloat-x86-only *
// and was modified to include negative number validation. Copyright (C) 2024 Isaiah Vogt. *                                  *
//                                                                                                                            *
// "Triangle Trigonometry I/O" is free software: you can redistribute it and/or modify it under the terms of the GNU General  *
// Public License version 3 as published by the Free Software Foundation. Average Driving Time is distributed in the hope     *
// that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A    *
//PARTICULAR PURPOSE.  See the GNU General Public License for more details. A copy of the GNU General Public License v3 is    *
// available here:  <https:;www.gnu.org/licenses/>.                                                                           *
//*****************************************************************************************************************************


//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//Author information
//  Author name: Isaiah Vogt
//  Author email: ivogt@csu.fullerton.edu
//
//Program information
//  Program name: Triangle Trigonometry I/O
//  Programming languages: One modules in C, two modules in X86, and one in bash
//  Date program began: 2024-Feb-15
//  Date of last update: 2024-Feb-23
//  Date of reorganization of comments: 2024-Feb-23
//  Files in this program: manager.asm, isfloat1.1.asm, driver.c, r.sh
//  Status: Finished.  The program was tested extensively with no errors in 11.1.0ubuntu4.
//
//Purpose
// This program provides triangle trionometric information and demonstrates input validation for netaive and badly formatted inputted numbers.
//
//This file
//   File name: driver.c
//   Language: C
//   Max page width: 132 columns
//   Compile: gcc -m64 -no-pie -std=c2x -o driver.o -c driver.c
//   Link: gcc -m64 -no-pie -std=c2x -o trig.out isfloat.o driver.o mgr.o -lm
//   Optimal print specification: 132 columns width, 7 points, monospace, 8½x11 paper
//
//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//
//===== Begin code area ===========================================================================================================


#include <math.h> // cos
#include <stdio.h> //printf

extern double trigIO();

int main( int argc, const char * argv[] )
{
    printf(  "\nWelcome to Amazing Triangles programmed by Isaiah Vogt on February 24, 2024.\n");
    double num = 0.0;
    num = trigIO();
    printf( "\nThe driver received this number %1.6lf and will simply keep it.\n", num );
    printf( "\nAn integer zero will now be sent to the operating system. Bye.\n" );
    return 0;
}

//  End of the function main ====================================================================

