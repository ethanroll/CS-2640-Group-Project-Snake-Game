

#main fil to run Snake Game 


.include "finalProjectTest.asm"
.include "movement.asm"

.text
.globl main

main: 
	jal startMovement 
	
exit call:
 	li $v0, 10
 	syscall 