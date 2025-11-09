%ifndef RANDOM_H
%define RANDOM_H

%include "labels.asm"
;======= FUNCTION: getRandomNumber(upperBound) ========
;returns a number 0 < number <= upperBound
getRandomNumber:
push bp
mov bp, sp
pusha
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

popa
pop bp
ret 2
;======= FUNCTION END: getRandomNumber(upperBound) ========
%endif
