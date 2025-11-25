.data
# Framebuffer: 512 × 256 pixels, 4 bytes per pixel = 0x80000 bytes
frameBuffer: .space 0x80000
borderThickness: .word 4
borderColor:     .word 0x0000FF    # blue
snakeColor:      .word 0x00FF00    # green
appleColor:      .word 0xFF0000    # red
backgroundColor: .word 0xFFFFFF    # white

.text
main:
    	#Clear screen
    	la  $t0, frameBuffer        # pointer to framebuffer
    	li  $t1, 8192             # number of pixels (512 × 256)
    	lw  $t2, backgroundColor    # white (0xFFFFFF)
    	
clear_loop:
    	sw  $t2, 0($t0)             # write pixel
    	addi $t0, $t0, 4            # move to next pixel
    	addi $t1, $t1, -1
    	bnez $t1, clear_loop
    	
    	#Top wall
    	la  $t0, frameBuffer
    	li  $t1, 64                # 64 pixels across
    	lw  $t2, borderColor
    	
drawTopBorder:
    	sw  $t2, 0($t0)
    	addi $t0, $t0, 4
    	addi $t1, $t1, -1
    	bnez $t1, drawTopBorder
    	
    	#Bottom wall
    	la  $t0, frameBuffer
    	addi $t0, $t0, 7936      # bottom row start (255 * 2048)
    	li  $t1, 64
    	lw  $t2, borderColor
    	
drawBottomBorder:
   	sw  $t2, 0($t0)
    	addi $t0, $t0, 4
    	addi $t1, $t1, -1
    	bnez $t1, drawBottomBorder
    	
    	#left wall
    	la $t0, frameBuffer
    	li $t1, 256
    	lw $t2, borderColor
drawBorderLeft:
    	sw $t2, 0($t0)
    	addi $t0, $t0, 256
    	addi $t1, $t1, -1
    	bnez $t1,drawBorderLeft
    	
    	#right wall
	la $t0, frameBuffer
	addi $t0, $t0, 508        # start of last column
	li $t1, 255                 # number of rows
	lw $t2, borderColor
drawBorderRight:
    	sw $t2, 0($t0)
    	addi $t0, $t0, 256    # move down one row
    	addi $t1, $t1, -1
    	bnez $t1, drawBorderRight

borders_done:
    	# Exit program
   	li $v0, 10
    	syscall
	
