.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    # Prologue
    li t0,1
    bge a1,t0,no_exception
    li a1,8
    j exit2
no_exception:
    addi sp,sp,-8
    sw ra,0(sp)
    sw s0,4(sp)
    mv t0,a1
    mv s0,a0
loop_start:
    lw t1,0(s0)
    bge t1,x0,loop_continue
    sw x0,0(s0)
loop_continue:
    addi s0,s0,4
    addi t0,t0,-1
    bne t0,x0,loop_start
loop_end:
    # Epilogue
    lw ra,0(sp)
    lw s0,4(sp)
    addi sp,sp,8
    
	ret