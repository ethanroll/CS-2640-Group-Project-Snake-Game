# **Snake Game**

## INTRO:
This is the classic snake game. Our group used MIPS assembly to create this game.
There are a total of 3 files.

## FEATURE:
* SNAKE MOVEMENT
* Food generated randomly
* Snake body growth
* Wall and self collision
* Bitmap display

## HOW TO PLAY THE GAME:

1. Open the required tools
   * Open Bitmap Display
   * Open Keyboard and Display MMIO Simulator
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
4. . Game Description
    * Control the snake to eat as much food as possible.
    * Game Over if the snake hits the wall border or bites itself.

## LICENSE

This project is released for educational use only. Modify freely.

