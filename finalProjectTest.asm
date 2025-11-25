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
main:
    	#Clear screen
    	la  $t0, frameBuffer        # pointer to framebuffer
    	li  $t1, 2048               # number of tiles 64 * 32 = 2048 tiles
    	lw  $t2, backgroundColor    # white color
    	
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

exit:
    	# Exit program
   	li $v0, 10
    syscall
	
