.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

    # Prologue
	addi sp,sp,-32
    sw ra,0(sp)
    sw s0,4(sp)
    sw s1,8(sp)
    sw s2,12(sp)
    sw s3,16(sp)
    sw s4,20(sp)
    sw s5,24(sp)
    sw s6,28(sp)

    mv s0,a0
    mv s1,a1
    mv s2,a2
    #open film
    mv a1,a0
    mv a2,x0
    jal ra,fopen
    li t0,-1
    beq t0,a0,fopen_error
    mv s3,a0 #file descriptor
    #read rows
    mv a1,s3
    mv a2,s1
    li a3,4
    jal ra,fread
    li t0,4
    bne t0,a0,fread_error
    lw s1,0(s1) #rows
    #read columns
    mv a1,s3
    mv a2,s2
    li a3,4
    jal ra,fread
    li t0,4
    bne t0,a0,fread_error
    lw s2,0(s2) #columns
    #malloc
    mul a0,s1,s2
    slli a0,a0,2
    jal ra,malloc
    beq x0,a0,malloc_error
    
    #read matrix
    mv s4,a0 #pointer
    mul s5,s1,s2 #total number
    mv t1,x0 # i=0
    mv s6,s4
loop_begin:
    mv a1,s3
    mv a2,s4
    li a3,4
    jal ra fread
    li t0,4
    bne t0,a0,fread_error
    addi t1,t1,1
    addi s4,s4,4
    bne t1,s5,loop_begin
    #close film
    mv a1,s3
    jal ra,fclose
    bne a0,x0,close_error

    mv a0,s6
    # Epilogue
    lw ra,0(sp)
    lw s0,4(sp)
    lw s1,8(sp)
    lw s2,12(sp)
    lw s3,16(sp)
    lw s4,20(sp)
    lw s5,24(sp)
    lw s6,28(sp)
    addi sp,sp,32

    ret


fopen_error:
    li a1,50
    j exit2

fread_error:
    li a1,51
    j exit2
malloc_error:
    li a1,53
    j exit2
close_error:
    li a1,52
    j exit2