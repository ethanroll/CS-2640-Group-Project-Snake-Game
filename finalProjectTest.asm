#Final Project: SNAKE GAME
#Group Member: Camilo Hernandez, Ethan Caoile, Ryan Hoang

.data
# Framebuffer: 512 × 256 pixels, 4 bytes per pixel = 0x80000 bytes (= 131072) 
frameBuffer: .space 0x80000

borderColor:     .word 0x0000FF    # blue
snakeColor:      .word 0x00FF00    # green
appleColor:      .word 0xFF0000    # red
backgroundColor: .word 0xFFFFFF    # white

.text

#.globl to be able to read and access from different file 
.globl screenInitiation
.globl headDrawing
.globl pixelGen
#main:
    	#Clear screen
    	#la  $t0, frameBuffer        # pointer to framebuffer
    	#li  $t1, 2048               # number of tiles 64 * 32 = 2048 tiles
    	#lw  $t2, backgroundColor    # white color
    	
    	
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
headDrawing: 
	#Will create and generate the pixel of the snake head 
	move $a0 , $s0
	move $a1, $s1
	lw $a2 snakeColor 
	
	jal setPixel 
	jr $ra 
	
pixelGen:
	#produces the pixil color using x, y, and color 
	li $t0 , 256
	mul $t0, $a1, $t0  #y * 256 
	
	# multiplies x by 4 
	sll $t1, $a0, 2
	
	add $t0, $t0, $t1  #total offset 
	
	la $t2, frameBuffer
	add $t0, $t0, $t2, 
	
	sw $a2, 0($t0)
	
	jr $ra 

	
