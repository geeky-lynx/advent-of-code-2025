#!/bin/bash
# Compile with GCC
# gcc -c -o solution.o solution.S -Wall -Wextra -g
gcc -o run solution.S run.c -Wall -Wextra -g -O0
gcc -o run2 solution.S run.c -Wall -Wextra -g -O0 -DPART_2
