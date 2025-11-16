%ifndef INTRO_H
%define INTRO_H

printIntro:
pusha
push ds
	mov byte [isIntro], 1

	call initVidSeg
	xor ax, ax
	mov al, 80
	sub al, [introWidth]
	mov di, ax

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
