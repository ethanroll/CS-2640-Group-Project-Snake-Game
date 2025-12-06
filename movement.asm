# File that handles the movement of the snake 
# Logic and overall movement converting the keyboard keycaps into memory 

# Snake Movement File with Growth
# Handles snake movement, tail clearing, and growth
.text
.globl moveRight
.globl moveLeft
.globl moveUp
.globl moveDown

# Move Right
moveRight:
    	# Clear tail if not growing
    	lw $t0, growSnake
    	bne $t0, $0, skipTailRight

    	# clear tail
    	lw $t1, snakeLength
    	subi $t1, $t1, 1        # tail index
    
    	# Validate tail index
    	bltz $t1, skipTailRight
    
    	sll $t2, $t1, 2
    	la $t3, snakeBodyX
    	add $t3, $t3, $t2
    	lw $a0, 0($t3)
    	la $t3, snakeBodyY
    	add $t3, $t3, $t2
    	lw $a1, 0($t3)
    
    	# Validate coordinates are in playable area (not borders)
    	blez $a0, skipTailRight
    	bge $a0, 63, skipTailRight
    	blez $a1, skipTailRight
    	bge $a1, 31, skipTailRight
    
    	jal clearPixel
skipTailRight:
    	# Shift body array
    	lw $t0, snakeLength
    	subi $t1, $t0, 1
    	blez $t1, skipShiftRight
shiftLoopRight:
    	sll $t2, $t1, 2
    	sll $t3, $t1, 2
    	la $t4, snakeBodyX
    	la $t5, snakeBodyY
    	sub $t6, $t1, 1
    	sll $t6, $t6, 2
    	add $t7, $t4, $t6
    	lw $t8, 0($t7)
    	add $t9, $t4, $t2
    	sw $t8, 0($t9)
    	add $t7, $t5, $t6
    	lw $t8, 0($t7)
    	add $t9, $t5, $t2
    	sw $t8, 0($t9)
    	subi $t1, $t1, 1
    	bgez $t1, shiftLoopRight
skipShiftRight:
    	# New head
    	addi $s4, $s4, 1
    	la $t0, snakeBodyX
    	sw $s4, 0($t0)
    	la $t0, snakeBodyY
    	sw $s5, 0($t0)

    	lw $s7, snakeRight
    	jal drawHead

    	# Grow snake if apple eaten
    	lw $t0, growSnake
    	beq $t0, $0, skipGrowRight
    	lw $t1, snakeLength
    	addi $t1, $t1, 1
    	sw $t1, snakeLength
    	sw $0, growSnake
skipGrowRight:
    	# Pause frame
    	li $a0, 100
    	li $v0, 32
    	syscall

    	# Keyboard input
    	li $t6, 0xFFFF0000
    	li $t7, 0xFFFF0004
    	lw $t0, 0($t6)
    	beq $t0, $zero, continueRight
    	lb $t2, 0($t7)
    	beq $t2, 119, moveUp
    	beq $t2, 115, moveDown
continueRight:
    	j moveRight

# Move Left
moveLeft:
    	lw $t0, growSnake
    	bne $t0, $0, skipTailLeft
    
    	lw $t1, snakeLength
    	subi $t1, $t1, 1
    
    	# Validate tail index
    	bltz $t1, skipTailLeft
    
    	sll $t2, $t1, 2
    	la $t3, snakeBodyX
    	add $t3, $t3, $t2
    	lw $a0, 0($t3)
    	la $t3, snakeBodyY
    	add $t3, $t3, $t2
    	lw $a1, 0($t3)
    
    	# Validate coordinates
    	blez $a0, skipTailLeft
    	bge $a0, 63, skipTailLeft
    	blez $a1, skipTailLeft
    	bge $a1, 31, skipTailLeft
    
    	jal clearPixel
skipTailLeft:
    	lw $t0, snakeLength
    	subi $t1, $t0, 1
    	blez $t1, skipShiftLeft
shiftLoopLeft:
    	sll $t2, $t1, 2
    	sll $t3, $t1, 2
    	la $t4, snakeBodyX
    	la $t5, snakeBodyY
    	sub $t6, $t1, 1
    	sll $t6, $t6, 2
    	add $t7, $t4, $t6
    	lw $t8, 0($t7)
    	add $t9, $t4, $t2
    	sw $t8, 0($t9)
    	add $t7, $t5, $t6
    	lw $t8, 0($t7)
    	add $t9, $t5, $t2
    	sw $t8, 0($t9)
    	subi $t1, $t1, 1
    	bgez $t1, shiftLoopLeft
skipShiftLeft:
    	addi $s4, $s4, -1
    	la $t0, snakeBodyX
    	sw $s4, 0($t0)
    	la $t0, snakeBodyY
    	sw $s5, 0($t0)

    	lw $s7, snakeLeft
    	jal drawHead

    	lw $t0, growSnake
    	beq $t0, $0, skipGrowLeft
    	lw $t1, snakeLength
    	addi $t1, $t1, 1
    	sw $t1, snakeLength
    	sw $0, growSnake
skipGrowLeft:
    	li $a0, 100
    	li $v0, 32
    	syscall

    	li $t6, 0xFFFF0000
    	li $t7, 0xFFFF0004
    	lw $t0, 0($t6)
    	beq $t0, $zero, continueLeft
    	lb $t2, 0($t7)
    	beq $t2, 119, moveUp
    	beq $t2, 115, moveDown
continueLeft:
    	j moveLeft

# Move Down
moveDown:
    	lw $t0, growSnake
    	bne $t0, $0, skipTailDown
    
    	lw $t1, snakeLength
    	subi $t1, $t1, 1
    
    	# Validate tail index
    	bltz $t1, skipTailDown
    
    	sll $t2, $t1, 2
    	la $t3, snakeBodyX
    	add $t3, $t3, $t2
    	lw $a0, 0($t3)
    	la $t3, snakeBodyY
    	add $t3, $t3, $t2
    	lw $a1, 0($t3)
    
    	# Validate coordinates
    	blez $a0, skipTailDown
    	bge $a0, 63, skipTailDown
    	blez $a1, skipTailDown
    	bge $a1, 31, skipTailDown
    
    	jal clearPixel
skipTailDown:
    	lw $t0, snakeLength
    	subi $t1, $t0, 1
    	blez $t1, skipShiftDown
shiftLoopDown:
    	sll $t2, $t1, 2
    	sll $t3, $t1, 2
    	la $t4, snakeBodyX
    	la $t5, snakeBodyY
    	sub $t6, $t1, 1
    	sll $t6, $t6, 2
    	add $t7, $t4, $t6
    	lw $t8, 0($t7)
    	add $t9, $t4, $t2
    	sw $t8, 0($t9)
    	add $t7, $t5, $t6
    	lw $t8, 0($t7)
    	add $t9, $t5, $t2
    	sw $t8, 0($t9)
    	subi $t1, $t1, 1
    	bgez $t1, shiftLoopDown
skipShiftDown:
    	addi $s5, $s5, 1
    	la $t0, snakeBodyX
    	sw $s4, 0($t0)
    	la $t0, snakeBodyY
    	sw $s5, 0($t0)

    	lw $s7, snakeDown
    	jal drawHead

    	lw $t0, growSnake
    	beq $t0, $0, skipGrowDown
    	lw $t1, snakeLength
    	addi $t1, $t1, 1
    	sw $t1, snakeLength
    	sw $0, growSnake
skipGrowDown:
    	li $a0, 100
    	li $v0, 32
    	syscall

    	li $t6, 0xFFFF0000
    	li $t7, 0xFFFF0004
    	lw $t0, 0($t6)
    	beq $t0, $zero, continueDown
    	lb $t2, 0($t7)
    	beq $t2, 97, moveLeft
    	beq $t2, 100, moveRight
continueDown:
    	j moveDown

# Move Up
moveUp:
    	lw $t0, growSnake
    	bne $t0, $0, skipTailUp
    
    	lw $t1, snakeLength
    	subi $t1, $t1, 1
    
    	# Validate tail index
    	bltz $t1, skipTailUp
    
    	sll $t2, $t1, 2
    	la $t3, snakeBodyX
    	add $t3, $t3, $t2
    	lw $a0, 0($t3)
    	la $t3, snakeBodyY
    	add $t3, $t3, $t2
    	lw $a1, 0($t3)
    
    	# Validate coordinates
    	blez $a0, skipTailUp
    	bge $a0, 63, skipTailUp
    	blez $a1, skipTailUp
    	bge $a1, 31, skipTailUp
    
    	jal clearPixel
skipTailUp:
    	lw $t0, snakeLength
    	subi $t1, $t0, 1
    	blez $t1, skipShiftUp
shiftLoopUp:
    	sll $t2, $t1, 2
    	sll $t3, $t1, 2
    	la $t4, snakeBodyX
    	la $t5, snakeBodyY
    	sub $t6, $t1, 1
    	sll $t6, $t6, 2
    	add $t7, $t4, $t6
    	lw $t8, 0($t7)
    	add $t9, $t4, $t2
    	sw $t8, 0($t9)
    	add $t7, $t5, $t6
    	lw $t8, 0($t7)
    	add $t9, $t5, $t2
    	sw $t8, 0($t9)
    	subi $t1, $t1, 1
    	bgez $t1, shiftLoopUp
skipShiftUp:
    	addi $s5, $s5, -1
    	la $t0, snakeBodyX
    	sw $s4, 0($t0)
    	la $t0, snakeBodyY
    	sw $s5, 0($t0)

    	lw $s7, snakeUp
    	jal drawHead

    	lw $t0, growSnake
    	beq $t0, $0, skipGrowUp
    	lw $t1, snakeLength
    	addi $t1, $t1, 1
    	sw $t1, snakeLength
    	sw $0, growSnake
skipGrowUp:
    	li $a0, 100
    	li $v0, 32
	syscall

    	li $t6, 0xFFFF0000
    	li $t7, 0xFFFF0004
    	lw $t0, 0($t6)
    	beq $t0, $zero, continueUp
    	lb $t2, 0($t7)
    	beq $t2, 97, moveLeft
    	beq $t2, 100, moveRight
continueUp:
    	j moveUp
