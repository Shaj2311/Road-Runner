%ifndef ANIMATE_H
%define ANIMATE_H


;=========== FUNCTION: moveScreen() ==============
moveScreen:
;pusha
push ax
push cx
push si
push di 
push es
push ds

	; get last saved screen state
	push cs
	pop ds
	mov si, screenState

	push word 0 
	push word 0 
	call pointToXY

	mov cx, 2000
	cld
	rep movsw




	;scroll down
	;Source = last line 
	mov ax, 0xb800
	mov ds, ax
	mov ax, 4000
	mov si, ax

	;Destination = first line after end of video segment
	mov ax, 0xb800
	mov es, ax
	mov ax, 4000
	add ax, 160
	mov di, ax

	
	mov cx, 2000 	;entire screen

	std		;override from the bottom up
	rep movsw	;scroll down

	;move scrolled line to top
	mov si, 4000
	mov di, 0
	mov cx, 80
	
	cld 
	rep movsw






	;save new screen state
	call saveScreenState


pop ds
pop es

	;reprint car
	call drawPlayer

	;draw traffic
	call drawCar1
	call drawCar2
	;update traffic for next iteration
	inc word [car1XY+2]
	inc word [car2XY+2]


	;TEST COIN PRINTING
	call drawCoin


pop di 
pop si 
pop cx
pop ax
;popa
ret
;=========== FUNCTION: saveScreenState() ==============


saveScreenState:
pusha
push ds
	push cs
	pop es
	mov di, screenState

	push word 0xb800
	pop ds
	mov si, 0 

	mov cx, 2000
	cld 
	rep movsw
pop ds
popa 
ret






;=========== FUNCTION END: saveScreenState() ==============



%endif
