.section .data
direction: .byte 'n'
offset: .long 69420
cursor: .long 50
counter: .long 0

.global get_passwd

.section .text

get_passwd:
        // Set up the stack:
        // pushl %ebp
        // movl %esp, %ebp

loop:
        // Godbolt reference for fscanf call
        // res_eax = fscanf(file, format, &direction, &offset) orelse goto success
        // it aint working :skull:
        // movl $offset, %ecx
        // movl $direction, %edx
        // movl format, %esi
        // movq file(%rip), %rdi
        // movl $0, %eax // idk why does it compile with it
        // call __isoc99_fscanf
        // movl %eax, %return_val

        movl $offset, %esi
        movl $direction, %edi
        call read_from_file

        // Is it the end?
        cmpl $0, %eax
        jbe success

loop_body:
        movl $cursor, %ebx
        // What kind of operand?
        cmpb $'L', direction
        je shall_reduce

        // Adding it is ('R')
        addl $offset, %ebx
        cmpl $100, %ebx
        jle is_zero_for_inc // goto ... if > 100
        subl $100, %ebx
        jmp is_zero_for_inc

shall_reduce:
        // Subtracting it is ('L')
        subl $offset, %ebx
        cmpl $0, %ebx
        jg is_zero_for_inc
        addl $100, %ebx
        

is_zero_for_inc:
        // Increment counter if cursor == 0
        testl %ebx, %ebx
        jnz no_hit_zero
        incl counter
no_hit_zero:
        movl %ebx, cursor
        jmp loop



success:
        // Godbolt reference for fclose call
        // movq $file, %rdi
        // call fclose
        movl $counter, %eax
        ret



failure_nofile:
        movl $-1, %eax
        ret
