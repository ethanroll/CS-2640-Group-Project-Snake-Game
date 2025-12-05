# file that handles the movement of the snake 
# Logic and overall movement converting the keyboard keycaps into memory 
.text
.globl moveRight 			# called in the main to start initilally moving right


# label for the snake to move right
moveRight: 
	# clear tail (previous position of tail)
	move $a0, $s2
	move $a1, $s3
	jal clearPixel
	
	# save old position of snake coords
	move $s2, $s4			# save x to $t3
	move $s3, $s5			# save y to $t4
	
	addi $s4, $s4, 1   		# updating x (move right)
	
	lw $s7, snakeRight
	jal drawHead			# draw the snake head
		
	# pausing for frame (to prevent crashes)
	li $a0, 100
	li $v0, 32
	syscall 
	
	#taking in keyboard input 
	li $t6, 0xFFFF0000   		# keyboard control 
	li $t7, 0xFFFF0004   		# keyboard data input
	
	lw $t0, 0($t6)  		# detect key being pressed key ready 
	beq $t0, $zero, continueRight   # case if no key is pressed 
	lb $t2, 0($t7)  		# ASCII  key 
	 
	beq $t2, 119, moveUp   		# user input 'w'
	beq $t2, 115, moveDown   	# user input 's' 

# label to keep snake moving right if no key is pressed
continueRight:
	j moveRight 


# label for the snake to move down
moveDown: 
	# clear tail
	move $a0, $s2
	move $a1, $s3
	jal clearPixel

	# save old position of snake coords
	move $s2, $s4			# save x to $t3
	move $s3, $s5			# save y to $t4
	
	addi $s5, $s5, 1           	# update y (move down)
	    
	lw  $s7, snakeDown
	jal drawHead			# draw the snake head

	# pausing for frame (to prevent crashes)
	li  $a0, 100
	li  $v0, 32
	syscall

	# taking in keyboard input
	li   $t6, 0xFFFF0000		# keyboard control
	li   $t7, 0xFFFF0004		# keyboard data input
	
	lw   $t0, 0($t6)		# detect key being pressed key ready 
	beq  $t0, $zero, continueDown	# case if no key is pressed
	lb   $t2, 0($t7)		# ASCII  key

	beq  $t2, 97,  moveLeft    	# user input 'a'
	beq  $t2, 100, moveRight   	# user input 'd' 
 
# label to keep the snake moving down if no key is pressed
continueDown:
	j moveDown


# label for the snake to move left	
 moveLeft:
 	# clear tail
	move $a0, $s2
	move $a1, $s3
	jal clearPixel
	
 	# save old position of snake coords
	move $s2, $s4			# save x to $t3
	move $s3, $s5			# save y to $t4
	
	addi $s4, $s4, -1         	# Update x (move left)
	
	lw  $s7, snakeLeft
	jal drawHead			# draw the snake head	

	# pausing for frame (to prevent crashes)
	li  $a0, 100
	li  $v0, 32
	syscall

	# taking in keyboard input
	li   $t6, 0xFFFF0000		# keyboard control	
	li   $t7, 0xFFFF0004		# keyboard data input
	
	lw   $t0, 0($t6)		# detect key being pressed key ready 
	beq  $t0, $zero, continueLeft	# case if no key is pressed
	lb   $t2, 0($t7)		# ASCII  key

	beq  $t2, 119, moveUp      	# user input 'w'
	beq  $t2, 115, moveDown    	# user input 's' 

# label to keep the snake moving left if no key is pressed
continueLeft:
	j moveLeft

  
# label for the snake to move up
moveUp:
	# clear tail
	move $a0, $s2
	move $a1, $s3
	jal clearPixel

	# save old position of snake coords
	move $s2, $s4			# save x to $t3
	move $s3, $s5			# save y to $t4
	
	addi $s5, $s5, -1          	# update y (move up)
	
	lw  $s7, snakeUp
	jal drawHead			# draw the snake head

	# taking in keyboard input
    	li  $a0, 100
    	li  $v0, 32
    	syscall

	# taking in keyboard input
    	li   $t6, 0xFFFF0000		# keyboard control 
    	li   $t7, 0xFFFF0004		# keyboard data input
    	
    	lw   $t0, 0($t6)		# case if no key is pressed
    	beq  $t0, $zero, continueUp	# case if no key is pressed
    	lb   $t2, 0($t7)		# ASCII  key

    	beq  $t2, 97,  moveLeft    	# user inpur 'a'
    	beq  $t2, 100, moveRight   	# user input 'd'
 
# label to keep the snake moving up if no key is pressed 
continueUp:
	j moveUp
	    

