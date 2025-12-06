# Group Members: Camilo Hernandez, Ethan Caoile, Ryan Hoang
# Testing for the border, apple appearance, and head appearance and logic 
        .text
        .globl screenInitiation
        .globl drawHead
        .globl spawnApple
        .globl pixelGen

drawHead:
    	# Compute pixel address: offset = (y*64 + x)*4
    	sll $t1, $s5, 6          # y * 64
    	add $t1, $t1, $s4        # + x
    	sll $t1, $t1, 2          # * 4 bytes
    	la  $t2, frameBuffer
    	add $t1, $t1, $t2        # $t1 points to pixel

    	lw  $t7, 0($t1)          # current color at that pixel

    	# Check for Apple Hit
    	lw  $t9, appleColor
    	beq $t7, $t9, hitApple   # If color is apple, handle it

    	# Check for Background Hit (Normal movement)
    	lw  $t8, backgroundColor
    	beq $t7, $t8, drawHeadAndReturn # If color is background, proceed

    	# If it's neither Apple nor Background, it must be a Border or the Snake's Body.
    	j quit                   # game over if it hit border or itself
drawHeadAndReturn:
    	# Draw head
    	sw  $s7, 0($t1)
    	jr  $ra
hitApple:
    	# Draw head (Apple is replaced by the head)
    	sw  $s7, 0($t1)

    	# Set grow flag
    	li $t8, 1
    	sw  $t8, growSnake

    	# Spawn new apple
    	move $t0, $ra            # save return address
    	jal  spawnApple
    	move $ra, $t0            # restore return address

    	jr  $ra
quit:
    	li  $v0, 10
    	syscall
# Generate the screen 
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
# spawnApple: apple will not spawn on snake body or borders
spawnApple:
    	# Save registers we'll use
    	addi $sp, $sp, -8
    	sw $s0, 0($sp)
    	sw $s1, 4($sp)
spawnLoop:
    	# Random X: 1 to 62
    	li $v0, 42
    	li $a1, 62          # 0..61
    	syscall
    	addi $t3, $a0, 1    # 1..62

    	# Random Y: 1 to 30 
    	li $v0, 42
    	li $a1, 30          # 0..29
    	syscall
    	addi $t4, $a0, 1    # 1..30

    	# Check if this position collides with the snake
    	li $t5, 0            # index = 0
    	lw $t6, snakeLength
checkCollision:
    	bge $t5, $t6, placeApple  # no collision, ready to place

    	sll $t7, $t5, 2
    	la $t8, snakeBodyX
    	add $t8, $t8, $t7
    	lw $t9, 0($t8)      # snakeX[i]
    	la $t8, snakeBodyY
    	add $t8, $t8, $t7
    	lw $s1, 0($t8)      # snakeY[i] - use $s1 instead of $s0

    	# Check if BOTH X AND Y match (same position)
    	bne $t3, $t9, notCollision   # X doesn't match, check next segment
    	beq $t4, $s1, spawnLoop      # X matches AND Y matches → retry
    
notCollision:
    	addi $t5, $t5, 1
    	j checkCollision
placeApple:
    	# Compute framebuffer address
    	li  $t5, 64
    	mul $t6, $t4, $t5       # y * 64
    	add $t6, $t6, $t3       # + x
    	sll $t6, $t6, 2         # *4 bytes
    	la  $t7, frameBuffer
    	add $t7, $t7, $t6

    	# Place apple
    	lw  $t8, appleColor
    	sw  $t8, 0($t7)
    
    	# Restore registers
    	lw $s0, 0($sp)
    	lw $s1, 4($sp)
    	addi $sp, $sp, 8
    
    	jr  $ra
#pixel gen helper: helps allocate the memory in the buffer 
pixelGen:
    	li  $t0, 64
    	mul $t0, $a1, $t0       # y * 64
    	add $t0, $t0, $a0       # + x
    	sll $t0, $t0, 2         # * 4 bytes
    	la  $t2, frameBuffer
    	add $t0, $t0, $t2
    	sw  $a2, 0($t0)
    	jr  $ra
# clear pixel to clear tail
clearPixel:
    	lw $a2, backgroundColor
    	j pixelGen
