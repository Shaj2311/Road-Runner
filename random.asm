%ifndef RANDOM_H
%define RANDOM_H

%include "labels.asm"
;======= FUNCTION: getRandomNumber(upperBound) ========
;returns a number 0 < number <= upperBound
getRandomNumber:
push bp
mov bp, sp
push ax
push bx
push dx

	xor dx, dx

	;load seed
	mov ax, [randomSeed]

	;PURE PANDEMONIUM
	mov bx, [randomSeed]
	rol bx, 15
	xor ax, bx

	mov bx, [randomSeed]
	shr bx, 7
	and ax, bx

	mov bx, [randomSeed]
	shl bx, 2
	xor ax, bx

	;update seed
	inc ax
	mov [randomSeed], ax
	
	;get and apply upper bound
	mov bx, [bp + 4]
	div bx
	inc dx

	;store random value
	mov [bp + 6], dx

pop dx
pop bx
pop ax
pop bp
ret 2
;======= FUNCTION END: getRandomNumber(upperBound) ========



;======= FUNCTION: getRandomLaneX() ========
getRandomLaneX:
push bp
mov bp, sp
push ax
	;get random lane number
	sub sp, 2
	push word 3
	call getRandomNumber
	pop ax

	cmp ax, 1
	jne _else_if_1_
		mov ax, [roadLane0]
		add ax, [roadLane1]
		jmp _break_

	_else_if_1_:
	cmp ax, 2
	jne _else_if_2_
		mov ax, [roadLane1]
		add ax, [roadLane2]
		jmp _break_

	_else_if_2_:
	cmp ax, 3
	jne _break_
		mov ax, [roadLane2]
		add ax, [roadEnd]
		jmp _break_

	_break_:
	shr ax, 1
	inc ax
	mov[bp + 4], ax
pop ax
pop bp
ret
;======= FUNCTION END: getRandomLaneX() ========
%endif
