[org 0x100]
jmp start
%include "scene.asm"
%include "player.asm"
%include "utils.asm"
%include "animate.asm"
%include "labels.asm"
%include "car.asm"
%include "coin.asm"
%include "random.asm"


start:
        call initRoadValues
        call clrscr
        call initScene
	call saveScreenState
        call initPlayer


	sub sp, 2	
	call getRandomLaneX	;x
	push word 0		;y
	call initCar1

	sub sp, 2
	call getRandomLaneX	;x
	push word 0		;y
	call initCar2

	sub sp, 2
	call getRandomLaneX	;x
	push word 0		;y
	call initCoin




	mov ax, 100
	push ax
	call delay

	gameLoop:

		;scroll down + reprint animation
		call moveScreen

		mov cl, [carSpawnElapsed]
		cmp cl, [carSpawnInterval]
		jb carPrintSkip

			;reprint car 1
			sub sp, 2
			call getRandomLaneX	;x
			push word 0		;y
			call initCar1
			;reset elapsed timer

			;reprint car 2
			sub sp, 2
			call getRandomLaneX	;x
			push word 0		;y
			call initCar2

			;reset elapsed timer
			mov byte [carSpawnElapsed], 0
		carPrintSkip:




		mov cl, [coinSpawnElapsed]
		cmp cl, [coinSpawnInterval]
		jb coinPrintSkip

			;redraw coin
			sub sp, 2
			call getRandomLaneX	;x
			push word 0		;y
			call initCoin
			;reset elapsed timer
			mov byte [coinSpawnElapsed], 0

		coinPrintSkip:


		;frame delay
		mov ax, 5
		push ax
		call delay

		;increment elapsed timers
		inc byte [carSpawnElapsed]
		inc byte [coinSpawnElapsed]


	jmp gameLoop



        jmp terminate




terminate:
mov ax, 0x4c00
int 0x21
