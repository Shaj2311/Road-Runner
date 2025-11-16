%ifndef PAUSE_H
%define PAUSE_H

%include "utils.asm"
printPauseMenu:
pusha 
push ds

	;print game title
	call initVidSeg
	xor ax, ax
	mov al, 80
	sub al, [introWidth]
	mov di, ax
	add di, 320

	push cs
	pop ds
	mov si, introDesign

	mov ah, 0x07

	xor cx, cx
	mov cl, [introHeight]
	pausedTitleOuter:
	push cx
		push di

		mov cl, [introWidth]
		pausedTitleInner:
			lodsb
			stosw
		loop pausedTitleInner

		pop di
		add di, 160
	pop cx
	loop pausedTitleOuter


	;print paused message
	mov ah, 0x13
	mov al, 0
	xor bh, bh 
	mov bl, 0x07
	mov cx, [pausedMessageStrLen]
	mov dh, 14
	mov dl, 23
	push cs
	pop es 
	mov bp, pausedMessageStr 
	int 0x10
	
pop ds
popa
ret

%endif
