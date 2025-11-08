[org 0x100]
jmp start
%include "scene.asm"
%include "player.asm"
%include "utils.asm"
%include "animate.asm"
%include "labels.asm"
%include "car.asm"


start:
        call initRoadValues
        call clrscr
        call initScene
	call saveScreenState
        call initPlayer


	;initialize traffic cars
	mov ax, [roadLane0]
	add ax, [roadLane1]
	shr ax, 1
	inc ax
	push ax			;x
	push word 0		;y
	call initCar1

	mov ax, [roadLane2]
	add ax, [roadEnd]
	shr ax, 1
	inc ax
	push ax			;x
	push word 0		;y
	call initCar2




	mov ax, 100
	push ax
	call delay

	gameLoop:
	mov cx, 1

		;scroll down + reprint animation
		call moveScreen


		;frame delay
		mov ax, 5
		push ax
		call delay

	inc cx
	loop gameLoop

        jmp terminate




terminate:
mov ax, 0x4c00
int 0x21
