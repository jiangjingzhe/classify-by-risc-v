.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error checks
    li t0,1
    blt a1,t0,m0_error
    blt a2,t0,m0_error
    blt a4,t0,m1_error
    blt a5,t0,m1_error
    bne a2,a4,no_match

    # Prologue
    addi sp,sp,-8
    sw s0,0(sp)
    sw ra,4(sp)
    mv s0,a2
    mv t0,x0
   
    slli t2,a2,2
    mv s0,a6
outer_loop_start:


    mv t1,x0
    addi sp,sp,-4
    sw a3,0(sp)
inner_loop_start:
    addi sp,sp,-32
    sw a0,0(sp)
    sw a1,4(sp)
    sw a2,8(sp)
    sw a3,12(sp)
    sw a4,16(sp)
    sw t0,20(sp)
    sw t1,24(sp)
    sw t2,28(sp)

    mv a1,a3
    li a3,1
    mv a4,a5
    jal ra dot
    sw a0,0(s0)

    lw a0,0(sp)
    lw a1,4(sp)
    lw a2,8(sp)
    lw a3,12(sp)
    lw a4,16(sp)
    lw t0,20(sp)
    lw t1,24(sp)
    lw t2,28(sp)
    addi sp,sp,32

    addi t1,t1,1
    addi s0,s0,4
    addi a3,a3,4
    bne t1,a5,inner_loop_start
inner_loop_end:
    lw a3,0(sp)
    addi sp,sp,4
    addi t0,t0,1
    add a0,a0,t2
    bne t0,a1,outer_loop_start

outer_loop_end:


    # Epilogue
    lw s0,0(sp)
    lw ra,4(sp)
    addi sp,sp,8
    
    ret

m0_error:
    li a1,2
    j exit2
m1_error:
    li a1,3
    j exit2
no_match:
    li a1,4
    j exit2