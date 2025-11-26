# file for handling the movement for the snake game

.data
snakeHeadPos_x: .word 16	# snake x starting position
snakeHeadPos_y: .word 13	# snake y starting position
moveDir: .word 2	# initially start moving to the right when the program starts: 0 move up, 1 move down, 2 move right, 3 move left


.text
startMovement:
	lw $s0, snakeHeadPos_x		# start position of x
	lw $s1, snakeHeadPos_y		# start position of y
	
	# start moving toward the right
	li $s2, 2	
	
	j mainLoop

mainLoop:
	# call draw head label
	jal drawHead
	

	# check the user inout
	li $v0, 12
	syscall
	move $t2, $v0			# $t2 store user movement input
	
	# check what the user input is
	beq $t2, 119, moveUp		# case 'w'
	beq $t2, 115, moveDown		# case 's'
	beq $t2, 97, moveLeft		# case 'a'
	beq $t2, 100, moveRight		# case 'd'
	j snakeMove			# continue moving even if no key is inputted
	
	# snake speed, to ensure it does not move too fast or too slow
 	li $a0, 100			# 100 milliseconds
 	li $v0, 32			# sleep syscall
	syscall
	
	j mainLoop
	
# if 'w'
moveUp:
	li $t3, 0
	sw $t3, moveDir			# update moveDir to value 0 (moving up)
	j snakeMove
		
# if 's'
moveDown:
	li $t3, 1
	sw $t3, moveDir			# update moveDir to value 1 (moving down)			
	j snakeMove	
	
# if 'a'
moveLeft:
	li $t3, 3
	sw $t3, moveDir			# update moveDir to value 3 (moving left)
	j snakeMove
	
# if 'd'
moveRight:
	li $t3, 2
	sw $t3, moveDir			# update moveDir to value 2 (moving right)
	j snakeMove
	
snakeMove:
	# load direction and snake positions
	lw $t4, moveDir
	lw $t5, snakeHeadPos_x
	lw $t6, snakeHeadPos_y
	
	# check which direction the snake would move
	beq $t4, 0, moveUpAct
	beq $t4, 1, moveDownAct
	beq $t4, 3, moveLeftAct
	beq $t4, 2, moveRightAct

	
# if up
moveUpAct:
	addi $s1, $s1, -1    		# subtract one from the y position to move up
    	j mainLoop

# if down
moveDownAct:
	addi $s1, $s1, 1    		# add one from the y position to move down
    	j mainLoop

# if left
moveLeftAct:
	addi $s0, $s0, -1    		# subtract one from the x position to move right
 	j mainLoop


# if right
moveRightAct:
	addi $s0, $s0, 1    		# add one from the x position to move left
 	j mainLoop

	



