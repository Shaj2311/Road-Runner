%ifndef INPUT_H
%define INPUT_H

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

	;a key to move left
	cmp al, 0x1e
	jne _not_a_
		dec word [playerX]
		jmp _isr_ret_
	_not_a_:

	;d key to move right
	cmp al, 0x20
	jne _not_right_
		inc word [playerX]
		jmp _isr_ret_
	_not_right_:

_isr_ret_:
	;return EOI signal to port 0x20
	mov ax, 0x20
	out 0x20, ax
popa
iret

%endif
