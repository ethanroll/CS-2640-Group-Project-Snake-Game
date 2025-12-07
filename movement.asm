# File that handles the movement of the snake using array shifting
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
    	bne $t0, $0, skipTailRight	#If growSnake is not equal 0, then the snake does not grows 

    	# clear tail
    	lw $t1, snakeLength	
    	subi $t1, $t1, 1        # get tail index 
    
    	# Validate tail index
    	bltz $t1, skipTailRight
    
    	sll $t2, $t1, 2		#index * 4 (a word is 4 bytes)
    	la $t3, snakeBodyX
    	add $t3, $t3, $t2
    	lw $a0, 0($t3)		#tail x coordinate
    	
    	la $t3, snakeBodyY
    	add $t3, $t3, $t2
    	lw $a1, 0($t3)		#tail y coordinate
    
    	# Validate coordinates are in playable area (not borders)
    	blez $a0, skipTailRight
    	bge $a0, 63, skipTailRight
    	blez $a1, skipTailRight
    	bge $a1, 31, skipTailRight
    
    	jal clearPixel
skipTailRight:
    	# Shift body array
    	lw $t0, snakeLength
    	subi $t1, $t0, 1		#get tail index
    	blez $t1, skipShiftRight # if the index value is < 0  then skipShift
shiftLoopRight:
    	sll $t2, $t1, 2		#$t2 = current index * 4
    	sll $t3, $t1, 2		#$t3 = current index * 4
    	la $t4, snakeBodyX
    	la $t5, snakeBodyY
    	
    	sub $t6, $t1, 1		#$t6 = index - 1
    	sll  $t6, $t6, 2		#$t6 * 4 (1 word = 4 bytes)
    	#copy x coordinate
    	add $t7, $t4, $t6
    	lw $t8, 0($t7)
    	add $t9, $t4, $t2
    	sw $t8, 0($t9)
    	#copy y coordinate
    	add $t7, $t5, $t6
    	lw $t8, 0($t7)
    	add $t9, $t5, $t2
    	sw $t8, 0($t9)
    	#loop
    	subi $t1, $t1, 1		#index = index - 1
    	bgez $t1, shiftLoopRight	#loop condition while index >= 0
skipShiftRight:
    	# New head location in array
    	addi $s4, $s4, 1		#move head x coordinateto right by adding 1
    	#store new head x into snakeBodyx
    	la $t0, snakeBodyX
    	sw $s4, 0($t0)
    	#store new head y into snakeBodyy
    	la $t0, snakeBodyY
    	sw $s5, 0($t0)
	#load current direction
    	lw $s7, snakeRight
    	
    	jal drawHead

    	# Grow snake if apple is eaten
    	lw $t0, growSnake	#check flag
    	beq $t0, $0, skipGrowRight	#skip if the flag = 0
    	lw $t1, snakeLength	#load the snakeLegth to $t1
    	addi $t1, $t1, 1		#snakeLength++
    	sw $t1, snakeLength	#store snakeLength
    	sw $0, growSnake		#reset flag
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
    	beq $t2, 119, moveUp	#'w'
    	beq $t2, 115, moveDown	#'s'
continueRight:
    	j moveRight

# Move Left
moveLeft:
    	# Clear tail if not growing
    	lw $t0, growSnake
    	bne $t0, $0, skipTailLeft	#If growSnake is not equal 0, then the snake does not grows jump to skipTailLeft

    	# clear tail
    	lw $t1, snakeLength	
    	subi $t1, $t1, 1        # get tail index 
    
    	# Validate tail index
    	bltz $t1, skipTailLeft
    
    	sll $t2, $t1, 2		#index * 4 (a word is 4 bytes)
    	la $t3, snakeBodyX
    	add $t3, $t3, $t2
    	lw $a0, 0($t3)		#tail x coordinate
    	
    	la $t3, snakeBodyY
    	add $t3, $t3, $t2
    	lw $a1, 0($t3)		#tail y coordinate
    
    	# Validate coordinates are in playable area (not borders)
    	blez $a0, skipTailLeft
    	bge $a0, 63, skipTailLeft
    	blez $a1, skipTailLeft
    	bge $a1, 31, skipTailLeft
    
    	jal clearPixel
skipTailLeft:
    	# Shift body array
    	lw $t0, snakeLength
    	subi $t1, $t0, 1		#get tail index
    	blez $t1, skipShiftLeft # if the index value is < 0  then skipShift
shiftLoopLeft:
    	sll $t2, $t1, 2		#$t2 = current index * 4
    	sll $t3, $t1, 2		#$t3 = current index * 4
    	la $t4, snakeBodyX
    	la $t5, snakeBodyY
    	
    	sub $t6, $t1, 1		#$t6 = index - 1
    	sll  $t6, $t6, 2		#$t6 * 4 (1 word = 4 bytes)
    	#copy x coordinate
    	add $t7, $t4, $t6
    	lw $t8, 0($t7)
    	add $t9, $t4, $t2
    	sw $t8, 0($t9)
    	#copy y coordinate
    	add $t7, $t5, $t6
    	lw $t8, 0($t7)
    	add $t9, $t5, $t2
    	sw $t8, 0($t9)
    	#loop
    	subi $t1, $t1, 1		#index = index - 1
    	bgez $t1, shiftLoopLeft	#loop condition while index >= 0
skipShiftLeft:
    	# New head location in array
    	addi $s4, $s4, -1		#move head x coordinateto left by subtracting 1
    	#store new head x into snakeBodyx
    	la $t0, snakeBodyX
    	sw $s4, 0($t0)
    	#store new head y into snakeBodyy
    	la $t0, snakeBodyY
    	sw $s5, 0($t0)
	#load current direction
    	lw $s7, snakeLeft
    	
    	jal drawHead

    	# Grow snake if apple is eaten
    	lw $t0, growSnake	#check flag
    	beq $t0, $0, skipGrowLeft	#skip if the flag = 0
    	lw $t1, snakeLength	#load the snakeLegth to $t1
    	addi $t1, $t1, 1		#snakeLength++
    	sw $t1, snakeLength	#store snakeLength
    	sw $0, growSnake		#reset flag
skipGrowLeft:
    	# Pause frame
    	li $a0, 100
    	li $v0, 32
    	syscall

    	# Keyboard input
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
    	# Clear tail if not growing
    	lw $t0, growSnake
    	bne $t0, $0, skipTailDown	#If growSnake is not equal 0, then the snake does not grows 

    	# clear tail
    	lw $t1, snakeLength	
    	subi $t1, $t1, 1        # get tail index 
    
    	# Validate tail index
    	bltz $t1, skipTailDown
    
    	mul $t2, $t1, 4		#index * 4 (a word is 4 bytes)
    	la $t3, snakeBodyX
    	add $t3, $t3, $t2
    	lw $a0, 0($t3)		#tail x coordinate
    	
    	la $t3, snakeBodyY
    	add $t3, $t3, $t2
    	lw $a1, 0($t3)		#tail y coordinate
    
    	# Validate coordinates are in playable area (not borders)
    	blez $a0, skipTailDown
    	bge $a0, 63, skipTailDown
    	blez $a1, skipTailDown
    	bge $a1, 31, skipTailDown
    
    	jal clearPixel
skipTailDown:
    	# Shift body array
    	lw $t0, snakeLength
    	subi $t1, $t0, 1		#get tail index
    	blez $t1, skipShiftDown # if the index value is < 0  then skipShift
shiftLoopDown:
    	sll $t2, $t1, 2		#$t2 = current index * 4
    	sll $t3, $t1, 2		#$t3 = current index * 4
    	la $t4, snakeBodyX
    	la $t5, snakeBodyY
    	
    	sub $t6, $t1, 1		#$t6 = index - 1
    	sll  $t6, $t6, 2		#$t6 * 4 (1 word = 4 bytes)
    	#copy x coordinate
    	add $t7, $t4, $t6
    	lw $t8, 0($t7)
    	add $t9, $t4, $t2
    	sw $t8, 0($t9)
    	#copy y coordinate
    	add $t7, $t5, $t6
    	lw $t8, 0($t7)
    	add $t9, $t5, $t2
    	sw $t8, 0($t9)
    	#loop
    	subi $t1, $t1, 1		#index = index - 1
    	bgez $t1, shiftLoopDown	#loop condition while index >= 0
skipShiftDown:
    	# New head location in array
    	addi $s5, $s5, 1		#move head y coordinate down by adding 1
    	#store new head x into snakeBodyX
    	la $t0, snakeBodyX
    	sw $s4, 0($t0)
    	#store new head y into snakeBodyY
    	la $t0, snakeBodyY
    	sw $s5, 0($t0)
	#load current direction
    	lw $s7, snakeDown
    	
    	jal drawHead

    	# Grow snake if apple is eaten
    	lw $t0, growSnake
    	beq $t0, $0, skipGrowDown
    	lw $t1, snakeLength
    	addi $t1, $t1, 1	
    	sw $t1, snakeLength	
    	sw $0, growSnake		
skipGrowDown:
    	# Pause frame
    	li $a0, 100
    	li $v0, 32
    	syscall

    	# Keyboard input
    	li $t6, 0xFFFF0000
    	li $t7, 0xFFFF0004
    	lw $t0, 0($t6)
    	beq $t0, $zero, continueDown
    	lb $t2, 0($t7)
    	beq $t2, 97, moveLeft
    	beq $t2, 100, moveRight
continueDown:
    	j moveDown

moveUp:
    	# Clear tail if not growing
    	lw $t0, growSnake
    	bne $t0, $0, skipTailUp	#If growSnake is not equal 0, then the snake does not grows 

    	# clear tail
    	lw $t1, snakeLength	
    	subi $t1, $t1, 1        # get tail index 
    
    	# Validate tail index
    	bltz $t1, skipTailUp
    
    	mul $t2, $t1, 4		#index * 4 (a word is 4 bytes)
    	la $t3, snakeBodyX
    	add $t3, $t3, $t2
    	lw $a0, 0($t3)		#tail x coordinate
    	
    	la $t3, snakeBodyY
    	add $t3, $t3, $t2
    	lw $a1, 0($t3)		#tail y coordinate
    
    	# Validate coordinates are in playable area (not borders)
    	blez $a0, skipTailUp
    	bge $a0, 63, skipTailUp
    	blez $a1, skipTailUp
    	bge $a1, 31, skipTailUp
    
    	jal clearPixel
skipTailUp:
    	# Shift body array
    	lw $t0, snakeLength
    	subi $t1, $t0, 1		#get tail index
    	blez $t1, skipShiftUp # if the index value is < 0  then skipShift
shiftLoopUp:
    	sll $t2, $t1, 2		#$t2 = current index * 4
    	sll $t3, $t1, 2		#$t3 = current index * 4
    	la $t4, snakeBodyX
    	la $t5, snakeBodyY
    	
    	sub $t6, $t1, 1		#$t6 = index - 1
    	sll $t6, $t6, 2		#$t6 * 4 (1 word = 4 bytes)
    	#copy x coordinate
    	add $t7, $t4, $t6
    	lw $t8, 0($t7)
    	add $t9, $t4, $t2
    	sw $t8, 0($t9)
    	#copy y coordinate
    	add $t7, $t5, $t6
    	lw $t8, 0($t7)
    	add $t9, $t5, $t2
    	sw $t8, 0($t9)
    	#loop
    	subi $t1, $t1, 1	
    	bgez $t1, shiftLoopUp
skipShiftUp:
    	# New head location in array
    	addi $s5, $s5, -1	
    	#store new head x into snakeBodyX
    	la $t0, snakeBodyX
    	sw $s4, 0($t0)
    	#store new head y into snakeBodyY
    	la $t0, snakeBodyY
    	sw $s5, 0($t0)
	#load current direction
    	lw $s7, snakeUp
    	
    	jal drawHead

    	# Grow snake if apple is eaten
    	lw $t0, growSnake
    	beq $t0, $0, skipGrowUp	
    	lw $t1, snakeLength	
    	addi $t1, $t1, 1		
    	sw $t1, snakeLength	
    	sw $0, growSnake		
skipGrowUp:
    	# Pause frame
    	li $a0, 100
    	li $v0, 32
	syscall

    	# Keyboard input
    	li $t6, 0xFFFF0000
    	li $t7, 0xFFFF0004
    	lw $t0, 0($t6)
    	beq $t0, $zero, continueUp
    	lb $t2, 0($t7)
    	beq $t2, 97, moveLeft
    	beq $t2, 100, moveRight
continueUp:
    	j moveUp

