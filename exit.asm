%ifndef EXIT_H 
%define EXIT_H 
%include "utils.asm"
%include "score.asm"

printExitScreen:
pusha
	call clrscr
	
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
	exitTitleOuter:
	push cx
		push di

		mov cl, [introWidth]
		exitTitleInner:
			lodsb
			stosw
		loop exitTitleInner

		pop di
		add di, 160
	pop cx
	loop exitTitleOuter


	;print exit message
	mov ah, 0x13
	mov al, 0
	xor bh, bh 
	mov bl, 0x07
	mov cx, [exitMessageStrLen]
	mov dh, 14
	mov dl, 35
	push cs
	pop es 
	mov bp, exitMessageStr 
	int 0x10


	;print score
	push word 0x07 	;normal attribute
	push word 35
	push word 15
	call printScore

	;print exit prompt
	mov ah, 0x13
	mov al, 0
	xor bh, bh 
	mov bl, 0x87
	mov cx, [exitPromptStrLen]
	mov dh, 17
	mov dl, 31
	push cs
	pop es 
	mov bp, exitPromptStr
	int 0x10


popa 
ret
%endif
