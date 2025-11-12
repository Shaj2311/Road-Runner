[org 0x100]
jmp start
%include "car.asm"
%include "scene.asm"
%include "player.asm"
%include "utils.asm"
%include "animate.asm"
%include "labels.asm"
%include "coin.asm"
%include "random.asm"
%include "collide.asm"


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
	mov byte [drawCar2Status], 0	;hide car 2 for first iteration

	sub sp, 2
	call getRandomLaneX	;x
	push word 0		;y
	call initCoin
	mov byte [drawCoinStatus], 0	;hide coin for first iteration




	mov ax, 100
	push ax
	call delay

	gameLoop:

		;scroll down + reprint animation
		call moveScreen

		mov cl, [car1SpawnElapsed]
		cmp cl, [carSpawnInterval]
		jb car1PrintSkip

			;reprint car 1
			sub sp, 2
			call getRandomLaneX	;x
			push word 0		;y
			call initCar1
			;reset elapsed timer
			mov byte [car1SpawnElapsed], 0
		car1PrintSkip:

		;handle initial 15 frame delay before printing car 2
		mov cl, [car2InitialDelay]
		cmp cl, 0
		je printCar2
		dec byte [car2InitialDelay]
		jmp car2PrintSkip

		printCar2:
		mov cl, [car2SpawnElapsed]
		cmp cl, [carSpawnInterval]
		jb car2PrintSkip

			;reprint car 2
			sub sp, 2
			call getRandomLaneX	;x
			push word 0		;y
			call initCar2

			;reset elapsed timer
			mov byte [car2SpawnElapsed], 0
		car2PrintSkip:


		;handle initial 7 frame delay before printing coin
		mov cl, [coinInitialDelay]
		cmp cl, 0
		je printCoin
		dec byte [coinInitialDelay]
		jmp coinPrintSkip

		printCoin:
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
		inc byte [car1SpawnElapsed]
		inc byte [car2SpawnElapsed]
		inc byte [coinSpawnElapsed]

		;CHECK COLLISIONS
		;check car 1 collision 
		sub sp, 2
		call checkCar1Collision
		pop ax
		;exit if collision
		cmp ax, 1
		je terminate

		;check car 2 collision 
		sub sp, 2
		call checkCar2Collision
		pop ax
		;exit if collision
		cmp ax, 1
		je terminate

		;check coin collision 
		call checkCoinCollision



	jmp gameLoop



        jmp terminate




terminate:
mov ax, 0x4c00
int 0x21
