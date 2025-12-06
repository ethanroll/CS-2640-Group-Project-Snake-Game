# mainRunF.asm
# Group Member: Camilo Hernandez, Ethan Caoile, Ryan Hoang
#main run code in assembly which has all import from joint files 
#contains hexadecimal valuse for color, movement, etc

.data
# Framebuffer: 512 × 256 pixels, 4 bytes per pixel = 0x80000 bytes (= 131072) 
frameBuffer: .space 0x80000

borderColor:     .word 0x0000FF    # blue
appleColor:      .word 0xFF0000    # red
backgroundColor: .word 0xFFFFFF    # white

snakeRight:      .word 0x0000FF00  # FLAG=00
snakeDown:       .word 0x0100FF00  # FLAG=01
snakeLeft:       .word 0x0200FF00  # FLAG=02
snakeUp:         .word 0x0300FF00  # FLAG=03

# State Variables
snakeHeadPosx:  .word 16          # $s4 will hold X
snakeHeadPosy:  .word 13          # $s5 will hold Y

# Initial tail same as head
snakeTailPosx:  .word 16          # $s2
snakeTailPosy:  .word 13          # $s3

# Snake body arrays
snakeBodyX: .space 400   # max 100 segments
snakeBodyY: .space 400
growSnake: 	.word 0
snakeLength:	.word 1

.text
.globl main
main:
    	# Initialize screen and apple
    	jal screenInitiation
    	jal spawnApple

    	# Load initial head position
    	lw $s4, snakeHeadPosx
    	lw $s5, snakeHeadPosy

    	# Load initial tail position
    	lw $s2, snakeTailPosx
    	lw $s3, snakeTailPosy

    	# --- Initialize snake body arrays with the head ---
    	la $t0, snakeBodyX
    	sw $s4, 0($t0)
    	la $t0, snakeBodyY
    	sw $s5, 0($t0)

    	# Draw head at start
    	lw $s7, snakeRight
    	jal drawHead

    	# Start moving right
    	j moveRight

		.include "movement.asm"
		.include "finalProjectTest.asm"
