.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "inputs/test_read_matrix/test_input.bin"

.text
main:
    # Read matrix into memory
    la a0,file_path
    addi sp,sp,-4
    mv a1,sp
    addi sp,sp,-4
    mv a2,sp
    addi sp,sp,-8
    sw a1,0(sp)
    sw a2,4(sp)
    jal ra,read_matrix
   
    lw a1,0(sp)
    lw a2,4(sp)
    addi sp,sp,8

    # Print out elements of matrix
    lw a1,0(a1)
    lw a2,0(a2)
    jal ra print_int_array


    # Terminate the program
    addi sp,sp,8
    j exit