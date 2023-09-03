.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
    li t0,1
    bge a2,t0,length_no_exception
    li a1,5
    j exit2
length_no_exception:
    bge a3,t0,stridev0_no_exception
    li a1,6
    j exit2
stridev0_no_exception:
    bge a4,t0,stridev1_no_exception
    li a1,6
    j exit2
stridev1_no_exception:
    # Prologue
    addi sp,sp,-16
    sw ra,0(sp)
    sw s0,4(sp)
    sw s1,8(sp)
    sw s2,12(sp)
    slli s1,a3,2
    slli s2,a4,2
    mv s0,x0
    mv t0,x0
loop_start:
    lw t0,0(a0)
    lw t1,0(a1)
    mul t2,t0,t1
    add s0,s0,t2
    add a0,a0,s1
    add a1,a1,s2
    addi a2,a2,-1
    bne a2,x0,loop_start
loop_end:
    mv a0,s0
    # Epilogue
    lw ra,0(sp)
    lw s0,4(sp)
    lw s1,8(sp)
    lw s2,12(sp)
    addi sp,sp,16
    
    ret