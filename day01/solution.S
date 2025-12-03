.section .data
direction: .byte 'n'
offset: .long 69420
cursor: .long 50
counter: .long 0

.global get_passwd
.global read_from_file

.section .text

get_passwd:
        // Set up the stack:
        pushq %rbp
        movq %rsp, %rbp

loop:
        movl $offset, %esi
        movl $direction, %edi
        call read_from_file

        cmpl $0, %eax
        jle success        // Stop the loop

loop_body:
        movl cursor, %ebx  // %ebx is what I'll use to check cursor
        cmpb $'L', direction
        je shall_reduce    // goto Subtract operation

        // Adding it is ('R')
        addl offset, %ebx
        cmpl $100, %ebx
        // jl - jump if less than op1
        jl is_zero_for_inc  // goto ... if < 100
        subl $100, %ebx     // if >= 100: %ebx -= 100
        jmp is_zero_for_inc

shall_reduce:
        // Subtracting it is ('L')
        subl offset, %ebx
        cmpl $0, %ebx
        jge is_zero_for_inc // goto ... if %ebx >= 0
        addl $100, %ebx     // if < 0: %ebx += 100
        

is_zero_for_inc:
        // Increment counter if cursor == 0
        testl %ebx, %ebx
        jnz no_hit_zero
        incl counter
        // incl %ebx
        // movl %ebx, cursor
no_hit_zero:
        movl %ebx, cursor
        jmp loop



success:
        // Godbolt reference for fclose call
        // movq $file, %rdi
        // call fclose
        movl counter, %eax
        popq %rbp
        ret



failure_nofile:
        movl $-1, %eax
        popq %rbp
        ret
