# **Snake Game**

##INTRO:
This is the classic snake game. Our group used MIPS assembly to create this game.

## FEATURE:
* SNAKE MOVEMENT
* Food generate randomly
* Snake body growth
* Wall and self-body collision
* Bitmap display

## HOW TO PLAY THE GAME:

1. In Tools look at for "Bitmap Display" and "Keyboard and Display MMIO Simulator"
2.  Connect to Bitmap:
    * Unit Width in pixels: 8
    * Unit Heigh in Pixels: 8
    * Display Width in Pixels: 512
    * Display Height in Pixels: 256
    * Base address for display 0x10010000 (static data)
3. Connect to Keyboard and Display MMIO Simulator:
    * a: move left
    * d: move right
    * w: move up
    * s: move down
4.  Now player can control the snake to eat as much food as possible. 
5.  Game over if the snake hits the wall boarder or it bites itself.

## LICENSE

This project is released for educational use only. Modify freely.

