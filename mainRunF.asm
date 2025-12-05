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

# Add these new initializers for the tail
snakeTailPosx:  .word 16      # $s2 will hold Tail X
snakeTailPosy:  .word 13      # $s3 will hold Tail Y

.text
 .globl main
 
main:
    # Initialize screen and apple
    jal screenInitiation
    jal spawnApple

    # Load initial position
    lw $s4, snakeHeadPosx
    lw $s5, snakeHeadPosy
    
    # load initial tail pos
    lw $s2, snakeTailPosx
    lw $s3, snakeTailPosy
    
    # draw head at start before loop start
    lw $s7, snakeRight
    jal drawHead

    # Start moving right
    j moveRight

        .include "movement.asm"
        .include "finalProjectTest.asm"
