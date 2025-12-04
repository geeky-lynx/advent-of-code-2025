.section .data
direction: .byte 'n'
offset: .long 69420
cursor: .long 50
counter: .long 0
DIVISION_FACTOR: .long 100

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
        // offset % 100; counter += floor(offset / 100)
        cmpl $100, offset
        jle calculate
        xorl %edx, %edx
        movl offset, %eax
        idivl DIVISION_FACTOR
        #ifdef PART_2
        addl %eax, counter
        #endif
        movl %edx, offset
        
calculate:
        movl cursor, %ebx  // %ebx is what I'll use to check cursor
        cmpb $'L', direction
        je shall_reduce    // goto Subtract operation


        // Adding it is ('R')
        addl offset, %ebx

// jl - jump if less than op1
fix_overflow:
        cmpl $100, %ebx
        jl next_iteration  // goto ... if < 100
        subl $100, %ebx     // if >= 100: %ebx -= 100

        #ifdef PART_2
        incl counter
        jmp next_without_checking

        #else
        jmp next_iteration

        #endif



shall_reduce:
        // Subtracting it is ('L')
        #if defined(PART_2)
        testl %ebx, %ebx
        jz subtract_without_increment
        #endif
        subl offset, %ebx

fix_underflow:
        cmpl $0, %ebx

        #ifdef PART_2
        jg next_without_checking
        incl counter
        cmpl $0, %ebx
        jnl next_without_checking
        addl $100, %ebx
        jmp next_without_checking

        #else
        jge next_iteration  // goto ... if %ebx >= 0
        addl $100, %ebx     // if < 0: %ebx += 100
        // Fall through to next_iteration

        #endif
        


next_iteration:
        // Increment counter if cursor == 0
        #if !defined(PART_2)
        testl %ebx, %ebx
        jnz next_without_checking
        incl counter
        #endif
next_without_checking:
        movl %ebx, cursor
        jmp loop



// For special case where direction is 'L'
// and the cursor/dial is at 0
        #ifdef PART_2
subtract_without_increment:
        movl $100, %ebx
        subl offset, %ebx
        jmp next_without_checking
        #endif



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
