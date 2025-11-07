[org 0x100]
jmp start
%include "scene.asm"
%include "player.asm"
%include "utils.asm"
%include "animate.asm"

;THESE ARE POSITIONS AND SIZES, NOT OFFSETS
;MULTIPLY BY 2
roadStart: dw 20
roadWidth: dw 40
roadLane0: dw 0
roadLane1: dw 0
roadLane2: dw 0
roadEnd: dw 0

playerX: dw 0
playerY: dw 19
; According to these values, it appears as if
; the height of the car is lesser than the width.
; Visually, this is not the case, because 
; each video block is rectangular, not square
carWidth: dw 8
carHeight: dw 5
carRectWidth: dw 6
carRectHeight: dw 5


;screen state (without player car)
screenState: times 2000 dw 0


start:
        call initRoadValues
        call clrscr
        call initScene
	call saveScreenState
        call initPlayer




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





;FIXME
;=========== FUNCTION: movePlayer(isLeft) ==============
movePlayer:
;Under construction :)
;=========== FUNCTION: movePlayer(isLeft) ==============




terminate:
mov ax, 0x4c00
int 0x21
