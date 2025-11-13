%ifndef INPUT_H
%define INPUT_H

%include "labels.asm"

hookISR:
pusha
push es
	;point es to IVT
	xor ax, ax
	mov es, ax

	;store old isr
	mov ax, [es:9*4]
	mov [oldKBisr], ax
	mov ax, [es:9*4 + 2]
	mov [oldKBisr + 2], ax

	;hook interrupt
	cli
	mov word [es:9*4], kbISR
	mov word [es:9*4 + 2], cs
	sti
pop es
popa
ret

unhookISR:
pusha
push es 
	;point es to IVT
	xor ax, ax
	mov es, ax

	;hook old ISR
	cli
	mov ax, [oldKBisr]
	mov word [es:9*4], ax
	mov ax, [oldKBisr + 2]
	mov word [es:9*4 + 2], ax
	sti


pop es 
popa 
ret


kbISR:
pusha
	;get input scan code
	in al, 0x60

	;;escape to quit
	;cmp al, 0x01
	;jne _not_esc_
	;	;terminate program
	;	jmp _isr_ret_
	;_not_esc_:

	;left arrow
	cmp al, 0x4b
	jne _not_left_
		;move left if allowed
		mov ax, [playerX]
		mov bx, [roadLane0]
		inc bx
		cmp ax, bx
		jna _move_left_skip_
			dec word [playerX]
		_move_left_skip_:
		jmp _isr_ret_
	_not_left_:

	;right arrow
	cmp al, 0x4d
	jne _not_d_
		mov ax, [playerX]
		add ax, [carWidth]
		mov bx, [roadEnd]
		cmp ax, bx
		jnb _move_right_skip_
		inc word [playerX]
		_move_right_skip_:
		jmp _isr_ret_
	_not_d_:

	

_isr_ret_:
	;return EOI signal to port 0x20
;	mov ax, 0x20
;	out 0x20, ax
popa
jmp far [cs:oldKBisr]
;iret

%endif
