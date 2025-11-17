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
%include "input.asm"
%include "intro.asm"
%include "pause.asm"
%include "exit.asm"

timerISR:
pusha 
push ds
	push cs
	pop ds
	call moveScreen
;	jmp gameLoop
;	timerRet:
	;send eoi
	mov al, 0x20
	out 0x20, al
pop ds
popa
iret

oldTimerISR: dw 0, 0

hookTimerISR:
pusha
	;store old isr
	xor ax, ax
	mov es, ax
	mov ax, [es:8*4]
	mov [oldTimerISR], ax
	mov ax, [es:8*4 + 2]
	mov [oldTimerISR + 2], ax

	;hook new isr
	cli 
	mov ax, timerISR
	mov word [es:8*4], timerISR
	mov word [es:8*4 + 2], cs
	sti
popa
ret

start:
	call hookISR
        call initRoadValues
restart:
	call clrscr
	push word 10 
	call delay		;slight delay to ignore .com launch input
	call printIntro
	call waitForStart

        call clrscr
        call initScene
	call saveScreenState
        call initPlayer
	call printInstructions
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


	;set game running flag
	mov byte [gameIsRunning], 1




	mov ax, 150
	push ax
	call delay

	;TESTTTTT
	call hookTimerISR

	gameLoop:
		
		cmp byte [gamePaused], 1 
		je gameLoop

		;scroll down + reprint animation
		;call moveScreen

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
			;increment score
			inc word [playerScore]
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
			;increment score
			inc word [playerScore]

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


		;quit if game ended
		cmp byte [gameIsRunning], 0
		je near gameOver


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
		call checkCar1Collision

		;check car 2 collision 
		call checkCar2Collision

		;check coin collision 
		call checkCoinCollision



	jmp gameLoop



        ;jmp gameOver




gameOver:
mov byte [gameEnded], 1
call printExitScreen
exitLoop:
	cmp byte [exitGame], 1 
	je terminate
	cmp byte [restartGame], 1
	jne exitLoop
		call resetFlags
		jmp restart
jmp exitLoop




terminate:
call unhookISR
call clrscr
mov ax, 0x4c00
int 0x21
