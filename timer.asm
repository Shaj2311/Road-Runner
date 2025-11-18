%ifndef TIMER_H
%define TIMER_H

%include "labels.asm"

timerISR:
pusha 
push ds
	push cs
	pop ds

cmp byte [timerToggle], 1 
jne _skip_timer_
	call moveScreen

_skip_timer_:
inc byte [timerToggle]
cmp byte [timerToggle], 1 
jna _skip_timer_toggle_reset_

mov byte [timerToggle], 0

_skip_timer_toggle_reset_:

	;send eoi
	mov al, 0x20
	out 0x20, al

pop ds
popa
iret

unhookTimerISR:
pusha
push es

	xor ax, ax
	mov es, ax

	cli
		mov ax, [cs:oldTimerISR]
		mov [es:8*4], ax
		mov ax, [cs:oldTimerISR + 2]
		mov [es:8*4 + 2], ax
	sti
	

pop es
popa
ret



hookTimerISR:
pusha
push es

	;store old timer isr
	xor ax, ax
	mov es, ax
	mov ax, [es:8*4]
	mov [oldTimerISR], ax
	mov ax, [es:8*4 + 2]
	mov [oldTimerISR + 2], ax

	;hook new isr
	cli 
	mov ax, timerISR
	mov word [es:8*4], timerISR
	mov word [es:8*4 + 2], cs
	sti
pop es
popa
ret
%endif
