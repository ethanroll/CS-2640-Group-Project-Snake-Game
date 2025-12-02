

#movment of the snake 
#Logic and overall movement converting the keyboard keycaps into memory 
.text
.globl moveRight 

moveRight: 
	lw $s7, snakeRight
	jal drawHead
	addi $s4, $s4, 1   #updating when x 
	
	#pausing for frame
	li $a0, 100
	li $v0, 32
	syscall 
	
	#taking in keyboard input 
	li $t6, 0xFFFF0000   #keyboard control 
	li $t7, 0xFFFF0004   #keyboard data input
	
	 lw $t0, 0($t6)  #detect key being pressed key ready 
	 beq $t0, $zero, continueRight  #if no key is pressed 
	 lb $t2, 0($t7)  #ASCII  key 
	 
	  beq $t2, 119, moveUp   # using w
	  beq $t2, 115, moveDown   #using s 

continueRight:
	j moveRight 

moveDown: 
    lw  $s7, snakeDown
    jal drawHead
    addi $s5, $s5, 1           # Update Y (move down)

    li  $a0, 100
    li  $v0, 32
    syscall

    li   $t6, 0xFFFF0000
    li   $t7, 0xFFFF0004
    lw   $t0, 0($t6)
    beq  $t0, $zero, continueDown
    lb   $t2, 0($t7)

    beq  $t2, 97,  moveLeft    # Using a 
    beq  $t2, 100, moveRight   # Using b 
 
 continueDown:
 	j moveDown
 	
 moveLeft:
 	lw  $s7, snakeLeft
    jal drawHead
    addi $s4, $s4, -1          # Update X (move left)

    li  $a0, 100
    li  $v0, 32
    syscall

    li   $t6, 0xFFFF0000
    li   $t7, 0xFFFF0004
    lw   $t0, 0($t6)
    beq  $t0, $zero, continueLeft
    lb   $t2, 0($t7)

    beq  $t2, 119, moveUp      # Using w 
    beq  $t2, 115, moveDown    # Using s 
 
 continueLeft:
 j moveLeft
    
moveUp:
    lw  $s7, snakeUp
    jal drawHead
    addi $s5, $s5, -1          # Update Y (move up)

    li  $a0, 100
    li  $v0, 32
    syscall

    li   $t6, 0xFFFF0000
    li   $t7, 0xFFFF0004
    lw   $t0, 0($t6)
    beq  $t0, $zero, continueUp
    lb   $t2, 0($t7)

    beq  $t2, 97,  moveLeft    # Using a 
    beq  $t2, 100, moveRight   # Using d 
   
continueUp:
	j moveUp
	    


