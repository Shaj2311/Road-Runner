%ifndef UTILS_H
%define UTILS_H

;points es:di to start of video segment
;=========== FUNCTION: initVidSeg() ==============
initVidSeg:
push ax
mov ax, 0xb800
mov es, ax
mov di, 0
pop ax
ret

%endif
;=========== FUNCTION END: initVidSeg() ==============




;=========== FUNCTION: pointToXY(X,Y) ==============
pointToXY:
push bp
mov bp, sp
push ax
push bp
	;point di to x/y position
	mov ax, [bp + 4]	;y position
	mov di, 160
	mul di

	mov di, [bp + 6]	;x position
	shl di, 1
	add di, ax		;add y position
pop bp
pop ax
pop bp
ret 4
;=========== FUNCTION END: pointToXY(X,Y) ==============




;======== FUNCTION clrscr() =========
;clears the screen
clrscr:
pusha
        ;point es to video memory
        call initVidSeg


        mov ax, 0x0720  ;space with normal attribute
        mov cx, 2000    ;screen size counter
        ;draw ax to screen cx times
        rep stosw

popa
ret
;======== FUNCTION END: clrscr() =========




;=========== FUNCTION: delay(time) ==============
delay:
push bp
mov bp, sp
push cx
	mov cx, [bp + 4]

	delayOuter:
	push cx

		mov cx, 0xFFFF

		delayInner:
			loop delayInner

	pop cx
	loop delayOuter
pop cx
pop bp
ret 2
;=========== FUNCTION END: delay(time) ==============
