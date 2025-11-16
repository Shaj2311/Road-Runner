%ifndef SCORE_H
%define SCORE_H

%include "labels.asm"

printScore:
push bp
mov bp, sp
pusha
push es

;update score value string
mov ax, [playerScore]

;push number ascii on stack
xor cx, cx
nextDigit:
	xor dx, dx
	mov bx, 10
	div bx
	add dl, 0x30
	push dx
	inc cx
	cmp ax, 0 
jne nextDigit

;pop and append to string
xor bx, bx

popNextDigit:
	pop ax 
	mov [scoreAmountStr + bx], al
	inc bx
loop popNextDigit





;PRINT STRING

;al = mode
mov al, 00b		;do not move cursor, no alternating attributes
;bl = attribute
mov bl, [bp + 8]	;attribute
;bh = page number
xor bh, bh		;page 0
;dh,dl = row, column
mov dh, [bp + 4] 		;row
mov dl, [bp + 6]		;column
;cx = string length
xor ch, ch
mov cl, [scoreStrSize]
;es:bp = start of string
push cs
pop es
mov bp, scoreStr

;print string
mov ah, 0x13
int 0x10


pop es
popa
pop bp
ret 6

%endif
