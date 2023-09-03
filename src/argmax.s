.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:

    # Prologue
    li t0,1
    bge a1,t0,no_exception
    li a1,7
    j exit2
no_exception:
    addi sp,sp,-8
    sw s0,0(sp)
    sw s1,4(sp)
    lw t0,0(a0)
    mv s0,x0
    mv s1,x0
loop_start:
    lw t1,0(a0)
    bge t0,t1,loop_continue
    mv t0,t1
    mv s0,s1
loop_continue:
    addi s1,s1,1
    addi a0,a0,4
    addi a1,a1,-1
    bne a1,x0,loop_start
loop_end:
    mv a0,s0
    # Epilogue
    lw s0,0(sp)
    lw s1,4(sp)
    addi sp,sp,8

    ret