#Camilo Hernandez 
#Ethan Caoile
#Ryan Hoang
#Snake Game Porject

	.eqv bitmap,  0x10010000
	.eqv    Width,      32
        .eqv    Height,      32

        .eqv    BgColor,    0x00000000   
        .eqv    color, 0x00FF00FF  

        .eqv    Up,      0
        .eqv    Right,   1
        .eqv    Down,    2
        .eqv    Left,    3

        .eqv    MAX_LEN,     32    
.data
snake lenght: .word 5
snakeDirection: .word DIR_RIGHT

.text

main: 





	#exit call 
	li $v0, 10
	syscall
