%include "utils.asm"

%ifndef CAR_H
%define CAR_H

;========= FUNCTION: initCar1(x,y) =========
initCar1:
push bp
mov bp, sp
pusha

	;store x,y position (bottom left corner)
	mov ax, [bp + 6]
	mov [car1XY], ax	;x
	mov ax, [bp + 4]
	mov [car1XY + 2], ax	;y

	;initialize attribute
	call setNextTrafficAttrib
	mov [car1attrib], ah


popa
pop bp
ret 4
;========= FUNCTION END: initCar1(x,y) =========




;========= FUNCTION: initCar2(x,y) =========
initCar2:
push bp
mov bp, sp
pusha

	;store x,y position (bottom left corner)
	mov ax, [bp + 4]
	mov [car2XY], ax	;x
	mov ax, [bp + 2]
	mov [car2XY + 2], ax	;y

	;initialize attribute
	call setNextTrafficAttrib
	mov [car2attrib], ah


popa
pop bp
ret 4
;========= FUNCTION END: initCar2(x,y) =========




;=============== FUNCTION: drawCar(x,y) ===============
;takes bottom left position of car
drawCar1:
push bp
mov bp, sp
pusha
push es
push ds

	call initVidSeg

	mov ax, [car1XY]	;x
	push ax
	mov ax, [car1XY + 2]	;y
	push ax
	call pointToXY

	;PRINT CAR FROM LABEL
	;ds:si to end of carDesign
	push di
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
					push cx
						carPrintInner:
							;print 
							lodsw
							cmp ah, [defaultCarAttrib]
							jne colorChangeSkip
								mov ah, [car1attrib]
							colorChangeSkip:
							stosw
						loop carPrintInner
					pop cx
				pop di
				pop cx
			sub di, 160
			js skipCarPrinting
			loop carPrintLoop
		skipCarPrinting:
		cld
	pop di

	

pop ds
pop es
popa
pop bp
ret
;============== FUNCTION END: drawCar(x,y) ===============



;========= FUNCTION: setNextTrafficAttrib() =========
;moves next traffic color attribute to ah, updates current attribute index 
setNextTrafficAttrib:
push bx
	;move address of next attribute in bx
	mov bx, trafficAttribs
	add bx, [trafficAttribIndex]
	;apply attribute
	mov ah, [bx]

	;update index 

	inc byte [trafficAttribIndex]	;increment

	mov bx, trafficAttribIndex	;wrap back around to zero if needed
	sub bx, trafficAttribs
	cmp [trafficAttribIndex], bx
	jnae wrapAroundSkip		;if less than total number of attributes, skip

		mov byte [trafficAttribIndex], 0

	wrapAroundSkip:
pop bx
ret
;========= FUNCTION END: setNextTrafficAttrib() =========








%endif
