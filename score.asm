%ifndef SCORE_H
%define SCORE_H

scoreStr: db 'Score: '
scoreAmountStr: dw 0
scoreStrSize: db scoreStrSize - scoreStr

printScore:
pusha
push es

;update score value string
mov ax, [playerScore]

;push number ascii on stack
xor cx, cx
nextDigit:
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
mov bl, 00100000b	;black on green
;bh = page number
xor bh, bh		;page 0
;dh,dl = row, column
mov dh, 1 		;row 1
mov dl, 0		;column 0
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
ret

%endif
