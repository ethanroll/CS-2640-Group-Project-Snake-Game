#Camilo Hernandez 
#Ethan Caoile
#Ryan Hao
#Snake Game Porject

	.eqv BITMAP_BASE,  0x10010000
	.eqv    GRID_W,      32
        .eqv    GRID_H,      32

        .eqv    COLOR_BG,    0x00000000   
        .eqv    COLOR_SNAKE, 0x00FF00FF  

        .eqv    DIR_UP,      0
        .eqv    DIR_RIGHT,   1
        .eqv    DIR_DOWN,    2
        .eqv    DIR_LEFT,    3

        .eqv    MAX_LEN,     32    
.data
snake lenght: .word 5
snakeDirection: .word DIR_RIGHT

.text

main: 





	#exit call 
	li $v0, 10
	syscall
