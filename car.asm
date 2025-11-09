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
	mov ax, [bp + 6]
	mov [car2XY], ax	;x
	mov ax, [bp + 4]
	mov [car2XY + 2], ax	;y

	;initialize attribute
	call setNextTrafficAttrib
	mov [car2attrib], ah


popa
pop bp
ret 4
;========= FUNCTION END: initCar2(x,y) =========




;=============== FUNCTION: drawCar1() ===============
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

	;ds:si to end of carDesign
	push cs 
	pop ds
	mov si, carDesign
	xor ax, ax
	mov al, [carHeight]
	mul byte [carWidth]
	shl ax, 1
	add si, ax
	sub si, 2

	;es:di to end (bottom right) of car location on screen
	add di, [carWidth]
	sub di, 2
	mov cx, [carHeight]

	;PRINT CAR FROM LABEL
	push di
		std
			car1PrintLoop:
				cmp di, 4000
				jae printCar1RowSkip

				push cx
				push di
					mov cx, [carWidth]
					car1PrintInner:
						;print 
						lodsw
						cmp ah, [defaultCarAttrib]	;change attribute
						jne color1ChangeSkip
							mov ah, [car1attrib]
						color1ChangeSkip:
						stosw
					loop car1PrintInner
				pop di
				pop cx

				;WEIRD AND FANCY STUFF HAPPENING HERE
				jmp NOprintCar1RowSkip	;if row IS printed, manual decrement of si not required, skip it
				printCar1RowSkip:	;if row is NOT printed, manual decrement of SI is required, DO ITTT!!!
				sub si, [carWidth]
				sub si, [carWidth]
				NOprintCar1RowSkip:
				sub di, 160
				js skipCar1Printing

			loop car1PrintLoop

		skipCar1Printing:
		cld
	pop di

	

pop ds
pop es
popa
pop bp
ret
;============== FUNCTION END: drawCar1() ===============



;=============== FUNCTION: drawCar2() ===============
;takes bottom left position of car
drawCar2:
push bp
mov bp, sp
pusha
push es
push ds

	call initVidSeg

	mov ax, [car2XY]	;x
	push ax
	mov ax, [car2XY + 2]	;y
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
			car2PrintLoop:
				cmp di, 4000
				jae printCar2RowSkip

				push cx
				push di
					mov cx, [carWidth]
					car2PrintInner:
						;print 
						lodsw
						cmp ah, [defaultCarAttrib]	;change attribute
						jne color2ChangeSkip
							mov ah, [car2attrib]
						color2ChangeSkip:
						stosw
					loop car2PrintInner
				pop di
				pop cx

				;WEIRD AND FANCY STUFF HAPPENING HERE
				jmp NOprintCar2RowSkip	;if row IS printed, manual decrement of si not required, skip it
				printCar2RowSkip:	;if row is NOT printed, manual decrement of SI is required, DO ITTT!!!
				sub si, [carWidth]
				sub si, [carWidth]
				NOprintCar2RowSkip:
				sub di, 160
				js skipCar2Printing

			loop car2PrintLoop

		skipCar2Printing:
		cld
	pop di

	

pop ds
pop es
popa
pop bp
ret
;============== FUNCTION END: drawCar2() ===============




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
