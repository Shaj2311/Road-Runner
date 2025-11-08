%include "utils.asm"

%ifndef CAR_H
%define CAR_H

;========= FUNCTION: drawCar(x,y) =========
;takes bottom left position of car
drawCar:
push bp
mov bp, sp
pusha
push es
push ds

	call initVidSeg

	mov ax, [bp + 6]	;x
	push ax
	mov ax, [bp + 4]	;y
	push ax
	call pointToXY

	;PRINT CAR FROM LABEL
	;ds:si to end of carDesign
	push cs 
	pop ds
	mov si, carDesign
	sub si, 2
	;es:di to end (bottom right) of car location on screen
	add si, 80
	add di, [carWidth]
	sub di, 2
	mov cx, [carHeight]
	;print
	std
	carPrintLoop:
		push cx
		push di
			mov cx, [carWidth]
			rep movsw
		pop di
		pop cx
	sub di, 160
	loop carPrintLoop
 	cld

	

pop ds
pop es
popa
pop bp
ret 4
;========= FUNCTION END: drawCar(x,y) =========








%endif
