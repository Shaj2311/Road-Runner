%ifndef INTRO_H
%define INTRO_H
%include "utils.asm"

printIntro:
pusha
push ds
	mov byte [isIntro], 1

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
	introOuter:
	push cx
		push di

		mov cl, [introWidth]
		introInner:
			lodsb
			stosw
		loop introInner

		pop di
		add di, 160
	pop cx
	loop introOuter

	
	;print name
	mov ah, 0x13
	mov al, 0
	xor bh, bh 
	mov bl, 0x07
	mov cx, [nameStrLen]
	mov dh, 13
	mov dl, 32
	push cs
	pop es 
	mov bp, nameStr
	int 0x10

	;print roll number
	mov ah, 0x13
	mov al, 0
	xor bh, bh 
	mov bl, 0x07
	mov cx, [rollNoStrLen]
	mov dh, 14
	mov dl, 29
	push cs
	pop es 
	mov bp, rollNoStr
	int 0x10

	;print section
	mov ah, 0x13
	mov al, 0
	xor bh, bh 
	mov bl, 0x07
	mov cx, [sectionStrLen]
	mov dh, 15
	mov dl, 32
	push cs
	pop es 
	mov bp, sectionStr
	int 0x10

	;print prompt
	mov ah, 0x13
	mov al, 0
	xor bh, bh 
	mov bl, 0x87
	mov cx, [introPromptStrLen]
	mov dh, 17
	mov dl, 27
	push cs
	pop es 
	mov bp, introPromptStr
	int 0x10
	
pop ds
popa
ret

waitForStart:
pusha
	waitForStartInputLoop:
		cmp byte [isIntro], 1
	je waitForStartInputLoop
popa
ret

%endif
