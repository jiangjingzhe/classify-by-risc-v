.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>


    li t0,5
    bne a0,t0,input_error

    # prologue
    addi sp, sp, -48
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)

    mv s0,a1 #argc
    mv s1,a2 #argv
	# =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0
    lw a0,4(s0) #a0=argv[1]
    addi sp,sp,-4
    mv a2,sp
    addi sp,sp,-4
    mv a1,sp
    jal read_matrix
    mv s2,sp #s2->m0.rows,m0.cols
    mv s3,a0 #m0
    # Load pretrained m1
    lw a0,8(s0) #a0=argv[2]
    addi sp,sp,-4
    mv a2,sp
    addi sp,sp,-4
    mv a1,sp
    jal read_matrix
    mv s4,sp #s4->m1.rows,m1.cols
    mv s5,a0 #m1
    # Load input matrix
    lw a0,12(s0) #a0=argv[3]
    addi sp,sp,-4
    mv a2,sp
    addi sp,sp,-4
    mv a1,sp
    jal read_matrix
    mv s6,sp #s6->input.rows,input.cols
    mv s7,a0 #input
    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    #allocate memory for linear layer
    lw t0,0(s2) #m0.rows
    lw t1,4(s6) #input.cols
    mul a0,t0,t1
    slli a0,a0,2
    jal malloc
    beq a0,x0,malloc_error
    mv s8,a0 #linear layer
    #linear layer m0 * input
    mv a0,s3 #m0
    lw a1,0(s2)
    lw a2,4(s2)
    mv a3,s7 #input
    lw a4,0(s6)
    lw a5,4(s6)
    mv a6,s8
    jal matmul

    #relu
    lw t0,0(s2) #m0.rows
    lw t1,4(s6) #input.cols
    mul a1,t0,t1
    mv a0,s8
    jal relu

    #allocate memory for linear layer
    lw t0,0(s4) #m1.rows
    lw t1,4(s6) #input.cols
    mul a0,t0,t1
    slli a0,a0,2
    jal malloc
    beq a0,x0,malloc_error
    mv s9,a0 #linear layer
    #linear layer m1 * ReLU(m0 * input)
    mv a0,s5 #m1
    lw a1,0(s4)
    lw a2,4(s4)
    mv a3,s8
    lw a4,0(s2)
    lw a5,4(s6)
    mv a6,s9
    jal matmul
    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0,16(s0)
    mv a1,s9
    lw a2,0(s4)
    lw a3,4(s6)
    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0,s9
    li a1,10
    jal argmax
    mv s10,a0

    bne s1,x0,not_print
    # Print classification
    mv a1,s10
    jal print_int

    # Print newline afterwards for clarity
    li a1,'\n'
    jal print_char

not_print:
    addi sp,sp,24
    mv a0,s3
    jal free
    mv a0,s5
    jal free
    mv a0,s7
    jal free
    mv a0,s8
    jal free
    mv a0,s9
    jal free

    mv a0,s10

    # epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    addi sp, sp, 48


    ret

input_error:
    li a1,49
    j exit2
malloc_error:
    li a1,48
    j exit2