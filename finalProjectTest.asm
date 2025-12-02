
# Group Member: Camilo Hernandez, Ethan Caoile, Ryan Hoang
#Testing for the boarder, apple appearance, and head appearance and logic 
        .text
        .globl screenInitiation
        .globl drawHead
        .globl spawnApple
        .globl pixelGen

drawHead:
    # Compute pixel address: offset = (y*64 + x)*4
    sll $t1, $s5, 6        # y * 64
    add $t1, $t1, $s4      # + x
    sll $t1, $t1, 2        # * 4 bytes
    la  $t2, frameBuffer
    add $t1, $t1, $t2      # $t1 points to pixel

    lw  $t7, 0($t1)        # current color at that pixel

    # Compare with background
    lw  $t8, backgroundColor
    bne $t7, $t8, checkApple

   #draw head 
    sw  $s7, 0($t1)
    jr  $ra

checkApple:
    lw  $t9, appleColor
    bne $t7, $t9, quit     # if hit object end program

    # if apple hit grow
    sw  $s7, 0($t1)

    move $t0, $ra          # save return address
    jal  spawnApple
    move $ra, $t0          # restore return address

    jr  $ra

quit:
    li  $v0, 10
    syscall

#start to generate the screen 
screenInitiation:
    # Clear screen to background
    la $t0, frameBuffer
    li $t1, 8192
    lw $t2, backgroundColor
clearLoop:
    sw  $t2, 0($t0)
    addi $t0, $t0, 4
    addi $t1, $t1, -1
    bnez $t1, clearLoop

    # Top border (row 0)
    la  $t0, frameBuffer
    li  $t1, 64
    lw  $t2, borderColor
drawTopBorder:
    sw  $t2, 0($t0)
    addi $t0, $t0, 4
    addi $t1, $t1, -1
    bnez $t1, drawTopBorder

    # Bottom border (row 31)
    la  $t0, frameBuffer
    addi $t0, $t0, 7936       # 31 * 64 * 4
    li  $t1, 64
    lw  $t2, borderColor
drawBottomBorder:
    sw  $t2, 0($t0)
    addi $t0, $t0, 4
    addi $t1, $t1, -1
    bnez $t1, drawBottomBorder

    # Left border (col 0)
    la $t0, frameBuffer
    li $t1, 32
    lw $t2, borderColor
drawBorderLeft:
    sw $t2, 0($t0)
    addi $t0, $t0, 256        # next row (64 * 4)
    addi $t1, $t1, -1
    bnez $t1, drawBorderLeft

    # Right border (col 63)
    la $t0, frameBuffer
    addi $t0, $t0, 252        # 63 * 4
    li $t1, 32
    lw $t2, borderColor
drawBorderRight:
    sw $t2, 0($t0)
    addi $t0, $t0, 256
    addi $t1, $t1, -1
    bnez $t1, drawBorderRight

    jr $ra



#randomly spawns in the apple 
spawnApple:
    # Random X: 1 to 61 (inside borders)
    li  $v0, 42             # random int range
    li  $a1, 61
    syscall                 # result in $a0: 0..60
    addi $t3, $a0, 1        # 1..61

    # Random Y: 1 to 29 (inside borders)
    li  $v0, 42
    li  $a1, 29
    syscall                 # result in $a0: 0..28
    addi $t4, $a0, 1        # 1..29

    # Compute pixel address
    li  $t5, 64
    mul $t6, $t4, $t5       #  y * 64
    add $t6, $t6, $t3       # + x
    sll $t6, $t6, 2         # * 4 bytes
    la  $t7, frameBuffer
    add $t7, $t7, $t6

    lw  $t8, appleColor
    sw  $t8, 0($t7)
    jr  $ra

#pixel gen helper 
#helps allocate the memory in the buffer 
pixelGen:
    li  $t0, 64
    mul $t0, $a1, $t0       # y * 64
    add $t0, $t0, $a0       # + x
    sll $t0, $t0, 2         # * 4 bytes
    la  $t2, frameBuffer
    add $t0, $t0, $t2
    sw  $a2, 0($t0)
    jr  $ra
