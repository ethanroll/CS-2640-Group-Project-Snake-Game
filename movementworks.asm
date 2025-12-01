#Final Project: SNAKE GAME (MARS Keyboard Simulator Input)
#Group Member: Camilo Hernandez, Ethan Caoile, Ryan Hoang

.data
# Framebuffer: 512 × 256 pixels, 4 bytes per pixel = 0x80000 bytes (= 131072) 
frameBuffer: .space 0x80000

# Color Encoding (Flag | R | G | B)
borderColor:     .word 0x0000FF    # blue
appleColor:      .word 0xFF0000    # red
backgroundColor: .word 0xFFFFFF    # white

# Direction-encoded snake head/body colors:
snakeRight:      .word 0x0000FF00 # FLAG=00
snakeDown:       .word 0x0100FF00 # FLAG=01
snakeLeft:       .word 0x0200FF00 # FLAG=02
snakeUp:         .word 0x0300FF00 # FLAG=03

# State Variables
snakeHeadPos_x:  .word 16 # $s4 will hold X
snakeHeadPos_y:  .word 13 # $s5 will hold Y

.text
.globl main
.globl screenInitiation
.globl drawHead
.globl pixelGen
.globl spawnApple

# Registers:
# $s4 = Head X
# $s5 = Head Y
# $s7 = Snake color/direction

main:
    jal screenInitiation
    jal spawnApple
    
    # Load initial position
    lw $s4, snakeHeadPos_x
    lw $s5, snakeHeadPos_y
    
    # Start moving right
    j moveRight

###################################################
#                 MOVEMENT LOOPS                #
###################################################

moveRight:
    lw $s7, snakeRight
    jal drawHead
    addi $s4, $s4, 1    # Update X

    # Pause for frame
    li $a0, 100
    li $v0, 32
    syscall

    # Keyboard Simulator Input
    lw   $t0, 0xFFFF0004    # Control register
    beq  $t0, $zero, continueRight # No key pressed
    lb   $t2, 0xFFFF0000    # ASCII key
    li   $t3, 0
    sw   $t3, 0xFFFF0004     # Clear control register

    beq  $t2, 119, moveUp    # 'w'
    beq  $t2, 115, moveDown  # 's'
    # else continue right

continueRight:
    j moveRight

moveDown:
    lw $s7, snakeDown
    jal drawHead
    addi $s5, $s5, 1    # Update Y

    li $a0, 100
    li $v0, 32
    syscall

    lw   $t0, 0xFFFF0004
    beq  $t0, $zero, continueDown
    lb   $t2, 0xFFFF0000
    li   $t3, 0
    sw   $t3, 0xFFFF0004

    beq  $t2, 97, moveLeft   # 'a'
    beq  $t2, 100, moveRight # 'd'

continueDown:
    j moveDown

moveLeft:
    lw $s7, snakeLeft
    jal drawHead
    subi $s4, $s4, 1    # Update X

    li $a0, 100
    li $v0, 32
    syscall

    lw   $t0, 0xFFFF0004
    beq  $t0, $zero, continueLeft
    lb   $t2, 0xFFFF0000
    li   $t3, 0
    sw   $t3, 0xFFFF0004

    beq  $t2, 119, moveUp    # 'w'
    beq  $t2, 115, moveDown  # 's'

continueLeft:
    j moveLeft

moveUp:
    lw $s7, snakeUp
    jal drawHead
    subi $s5, $s5, 1    # Update Y

    li $a0, 100
    li $v0, 32
    syscall

    lw   $t0, 0xFFFF0004
    beq  $t0, $zero, continueUp
    lb   $t2, 0xFFFF0000
    li   $t3, 0
    sw   $t3, 0xFFFF0004

    beq  $t2, 97, moveLeft   # 'a'
    beq  $t2, 100, moveRight # 'd'

continueUp:
    j moveUp

###################################################
#                  DRAW HEAD                     #
###################################################

drawHead:
    # Compute pixel address: offset = (y*64 + x)*4
    sll $t1, $s5, 6
    add $t1, $t1, $s4
    sll $t1, $t1, 2
    la  $t2, frameBuffer
    add $t1, $t1, $t2

    lw  $t7, 0($t1)       # current color

    # Check for collision
    bne $t7, 0xFFFFFF, checkApple

    # Safe to move: draw head
    sw  $s7, 0($t1)
    jr  $ra

checkApple:
    beq $t7, 0xFF0000, growSnake
    j quit

growSnake:
    sw $s7, 0($t1)
    jal spawnApple
    jr $ra

quit:
    li $v0, 10
    syscall

###################################################
#               SCREEN INIT                      #
###################################################

screenInitiation:
    la $t0, frameBuffer
    li $t1, 8192
    lw $t2, backgroundColor
clearLoop:
    sw  $t2, 0($t0)
    addi $t0, $t0, 4
    addi $t1, $t1, -1
    bnez $t1, clearLoop

    # Top border
    la  $t0, frameBuffer
    li  $t1, 64
    lw  $t2, borderColor
drawTopBorder:
    sw  $t2, 0($t0)
    addi $t0, $t0, 4
    addi $t1, $t1, -1
    bnez $t1, drawTopBorder

    # Bottom border
    la  $t0, frameBuffer
    addi $t0, $t0, 7936
    li $t1, 64
    lw $t2, borderColor
drawBottomBorder:
    sw  $t2, 0($t0)
    addi $t0, $t0, 4
    addi $t1, $t1, -1
    bnez $t1, drawBottomBorder

    # Left border
    la $t0, frameBuffer
    li $t1, 32
    lw $t2, borderColor
drawBorderLeft:
    sw $t2, 0($t0)
    addi $t0, $t0, 256
    addi $t1, $t1, -1
    bnez $t1, drawBorderLeft

    # Right border
    la $t0, frameBuffer
    addi $t0, $t0, 252
    li $t1, 32
    lw $t2, borderColor
drawBorderRight:
    sw $t2, 0($t0)
    addi $t0, $t0, 256
    addi $t1, $t1, -1
    bnez $t1, drawBorderRight
    jr $ra

###################################################
#                  SPAWN APPLE                   #
###################################################

spawnApple:
    # Random X: 1 to 61
    li  $v0, 42
    li  $a1, 61
    syscall
    addi $t3, $a0, 1

    # Random Y: 1 to 29
    li  $v0, 42
    li  $a1, 29
    syscall
    addi $t4, $a0, 1

    # Compute pixel address
    li  $t5, 64
    mul $t6, $t4, $t5
    add $t6, $t6, $t3
    sll $t6, $t6, 2
    la  $t7, frameBuffer
    add $t7, $t7, $t6

    lw  $t8, appleColor
    sw  $t8, 0($t7)
    jr $ra

###################################################
#                  PIXEL GEN                      #
###################################################

pixelGen:
    # $a0 = x, $a1 = y, $a2 = color
    li $t0, 64
    mul $t0, $a1, $t0
    add $t0, $t0, $a0
    sll $t0, $t0, 2
    la  $t2, frameBuffer
    add $t0, $t0, $t2
    sw $a2, 0($t0)
    jr $ra
