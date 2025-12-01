.section .data
filename: .ascii "input.txt\0"
filemode: .ascii "r\0"
format: .ascii "%c%d\n\0"
file: .quad 0
direction: .byte 'R'
offset: .long 0
cursor: .long 50
counter: .long 0

.global get_passwd

.section .text

get_passwd:
        // Set up the stack:
        // pushl %ebp
        // movl %esp, %ebp

        // Godbolt reference for fopen call
        // file = fopen(filename, filemode) orelse return -1
        movq $filemode, %rsi
        movq $filename, %rdi
        call fopen
        testl %eax, %eax
        jz failure_nofile
        movl %eax, file



loop:
        // Godbolt reference for fscanf call
        // res_eax = fscanf(file, format, &direction, &offset) orelse goto success
        cmpl $0, %eax
        jbe success

loop_body:
        // Increment counter if cursor == 0
        testl cursor, cursor
        caddzl $1, counter // doesn't exist
        
        jmp loop


success:
        // Godbolt reference for fclose call
        movq $file, %rdi
        call fclose
        movl $counter, %eax
        ret



failure_nofile:
        movl $-1, %eax
        ret
