#Final Project: SNAKE GAME
#Group Member: Camilo Hernandez, Ethan Caoile, Ryan Hoang

.data
# Framebuffer: 512 × 256 pixels, 4 bytes per pixel = 0x80000 bytes (= 131072) 
frameBuffer: .space 0x80000

borderColor:     .word 0x0000FF    # blue
snakeColor:      .word 0x00FF00    # green
appleColor:      .word 0xFF0000    # red
backgroundColor: .word 0xFFFFFF    # white

moveSnakeUp: .word 0x0300FF00 # 3 move right
moveSnakeDown: .word 0x0100FF00 # 1 move right
moveSnakeRight: .word 0x0000FF00 # 0 move right
moveSnakeLeft: .word 0x0200FF00 # 2 move left
snakeHeadPos_x:  .word 16
snakeHeadPos_y:  .word 13
moveDir:	 .word 2


.text

#.globl to be able to read and access from different file 
.globl screenInitiation
.globl headDrawing
.globl pixelGen
main:
	jal screenInitiation
	jal spawnApple
    	
    	# j initialMovement
	j mainLoop
    	#Clear screen
    	#la  $t0, frameBuffer        # pointer to framebuffer
    	#li  $t1, 2048               # number of tiles 64 * 32 = 2048 tiles
    	#lw  $t2, backgroundColor    # white color
    	
mainLoop:
# Movement loop
    # Draw snake head
    lw $t3, moveDir
    jal drawHead
    
    # Read user input
   # lw   $t2, 0xFFFF0004    # read keyboard register
    
     # rest so doesn't crash
    li $a0, 100
    li $v0, 32
    syscall
    
    lw $t0, 0xFFFF0004
   beq $t0, $zero, caseNoKey
    lb $t2, 0xFFFF0000
    beq  $t2, 119, moveUp   # 'w'
    beq  $t2, 115, moveDown # 's'
    beq  $t2, 97, moveLeft  # 'a'
    beq  $t2, 100, moveRight# 'd'
    beq  $t2, 0, moveRight # start game by moving right
    
    #li $v0, 12        # syscall 12 = read char
    #syscall
    #move $t2, $v0     # $t2 = input char

    # Update direction if key pressed
   # beq $t2, 119, moveUp    # 'w'
   # beq $t2, 115, moveDown  # 's'
   # beq $t2, 97, moveLeft   # 'a'
   # beq $t2, 100, moveRight # 'd'

caseNoKey:
    j snakeMove

# initialMovement:


# Movement Labels
moveUp:
    li $t3, 0
    sw $t3, moveDir
    j snakeMove

moveDown:
    li $t3, 1
    sw $t3, moveDir
    j snakeMove

moveLeft:
    li $t3, 3
    sw $t3, moveDir
    j snakeMove

moveRight:
    li $t3, 2
    sw $t3, moveDir
    j snakeMove


# Snake movement update
snakeMove:
    lw $s0, snakeHeadPos_x
    lw $s1, snakeHeadPos_y

    beq $t3, 0, moveUpAct
    beq $t3, 1, moveDownAct
    beq $t3, 3, moveLeftAct
    beq $t3, 2, moveRightAct

moveUpAct:
    addi $s1, $s1, -1
    sw $s0, snakeHeadPos_x
    sw $s1, snakeHeadPos_y
    j mainLoop

moveDownAct:
    addi $s1, $s1, 1
    sw $s0, snakeHeadPos_x
    sw $s1, snakeHeadPos_y
    j mainLoop

moveLeftAct:
    addi $s0, $s0, -1
    sw $s0, snakeHeadPos_x
    sw $s1, snakeHeadPos_y
    j mainLoop

moveRightAct:
    addi $s0, $s0, 1
    sw $s0, snakeHeadPos_x
    sw $s1, snakeHeadPos_y
    j mainLoop	
	   	   	
screenInitiation: 
	#Changes the color screen
	#draws the border lines 
	#Clear screen 8192 pixels 
	
	la $t0, frameBuffer
	li $t1, 8192
	lw $t2, backgroundColor
clearLoop:
    	sw  $t2, 0($t0)			# store white color value to the frame
    	addi $t0, $t0, 4		# move to next pixel
    	addi $t1, $t1, -1		# number of tile decrese 1 each time loop call
    	bnez $t1, clearLoop
    	
    	#Top wall
    	la  $t0, frameBuffer
    	li  $t1, 64				#save spot for 64 tiles
    	lw  $t2, borderColor	#load the border color to $t2
    	
drawTopBorder:
    	sw  $t2, 0($t0)			#store the borderColor to the frameBuffer		
    	addi $t0, $t0, 4
    	addi $t1, $t1, -1
    	bnez $t1, drawTopBorder
    	
    	#Bottom wall
    	la  $t0, frameBuffer
    	addi $t0, $t0, 7936      #start of bottom row: 31 x 64 x 4
    	li  $t1, 64
    	lw  $t2, borderColor
    	
drawBottomBorder:
   	sw  $t2, 0($t0)
    	addi $t0, $t0, 4
    	addi $t1, $t1, -1
    	bnez $t1, drawBottomBorder
    	
    	#Left wall
    	la $t0, frameBuffer		#start at column 0
    	li $t1, 32				#number of rows
    	lw $t2, borderColor
drawBorderLeft:
    	sw $t2, 0($t0)
    	addi $t0, $t0, 256		#add 256 to move to next row
    	addi $t1, $t1, -1
    	bnez $t1, drawBorderLeft
    	
    	#Right wall
	la $t0, frameBuffer	 	#start at column 63
	addi $t0, $t0, 252	 	#rightmost column 
	li $t1, 32		 		#number of rows
	lw $t2, borderColor
	
drawBorderRight:
    	sw $t2, 0($t0)
    	addi $t0, $t0, 256    # move down one row
    	addi $t1, $t1, -1
    	bnez $t1, drawBorderRight


spawnApple:
    	#Generate random X
    	li   $v0, 42          # syscall 42 = random int
    	li   $a1, 62          # range 0–61
    	syscall
    	addi $t3, $a0, 1      # x = random + 1

    	#Generate random Y
    	li   $v0, 42		  # syscall 42 = random int
    	li   $a1, 30          # range 0–29
    	syscall
    	addi $t4, $a0, 1      # y = random + 1

    	#Compute pixel address
    	#offset = (y * 64 + x) * 4
    	li   $t5, 64
   		mul  $t6, $t4, $t5
    	add  $t6, $t6, $t3 
    	mul $t6, $t6, 4

    	la   $t7, frameBuffer
    	add  $t7, $t7, $t6    # final framebuffer address

    	#Draw the apple
    	lw   $t8, appleColor
    	sw   $t8, 0($t7)

#update for middle placement
headDrawing:
    # Use $t9 as a simple "initialized" flag.

    beq $t9, $zero, initHead    # if first time, go set center
    j   drawHead   # otherwise just draw

initHead:
    li  $s0, 32     # center x on 64-wide field
    li  $s1, 16    # center y on 32-tall field
    li  $t9, 1     # mark as initialized

drawHead:
    # Will create and generate the pixel of snake head 
       lw $s0, snakeHeadPos_x
    lw $s1, snakeHeadPos_y
    move $a0, $s0               # x
    move $a1, $s1               # y

    lw   $a2, snakeColor        # color

    jal  pixelGen
    jr   $ra

	
pixelGen:
	#produces the pixil color using x, y, and color 
	li $t0 , 256
	mul $t0, $a1, $t0  #y * 256 
	
	# multiplies x by 4 
	sll $t1, $a0, 2
	
	add $t0, $t0, $t1  #total offset 
	
	la $t2, frameBuffer
	add $t0, $t0, $t2
	
	sw $a2, 0($t0)
	
	jr $ra 
	

	
