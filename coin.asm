%ifndef COIN_H
%define COIN_H

%include "utils.asm"

;=========== FUNCTION: initCoin(X,Y) ==============
initCoin:
push bp
mov bp, sp
push ax

	;store x,y position
	mov ax, [bp + 6]
	mov [coinXY], ax
	mov ax, [bp + 4]
	mov [coinXY + 2], ax

pop ax
pop bp
ret 4
;=========== FUNCTION END: initCoin(X,Y) ==============


drawCoin:
push bp
mov bp, sp 
pusha
push es
push ds
	;ds:si -> coin (end)
	push cs
	pop ds
	mov si, coin
	xor ax, ax
	mov al, [coinWidth]
	mul byte [coinHeight]
	shl ax, 1
	add si, ax
	sub si, 2
	
	;es:di -> video x,y (bottom right end)
	call initVidSeg
	push word [coinXY]
	push word [coinXY+2]
	call pointToXY
	

	;print coin from label
	push di
		std
			mov cx, [coinHeight]
			coinPrintLoop:
				cmp di, 4000
				jae printCoinRowSkip

				push cx
				push di
					mov cx, [coinWidth]
					rep movsw
				pop di
				pop cx

				;WEIRD AND FANCY STUFF HAPPENING HERE
				jmp NOprintCoinRowSkip	;if row IS printed, manual decrement of si not required, skip it
				printCoinRowSkip:	;if row is NOT printed, manual decrement of SI is required, DO ITTT!!!
				sub si, [coinWidth]
				sub si, [coinWidth]
				NOprintCoinRowSkip:
				sub di, 160
				js skipCoinPrinting

			loop coinPrintLoop

		skipCoinPrinting:
		cld
	pop di

	
pop ds
pop es
popa
pop bp
ret

	


%endif
