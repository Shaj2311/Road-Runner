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

	;Intro screen (press any key to continue)
	cmp byte [isIntro], 1
	jne _not_intro_
	;If key pressed at intro, start game
	mov byte [isIntro], 0
	jmp _isr_ret_
	_not_intro_:

;	;Pause screen (press y to quit, n to resume)
;	cmp byte [gamePaused], 1
;	jne _game_not_paused_
;		;quit if y
;		cmp al, 0x15
;		jne _pause_not_y_
;			mov byte [gameIsRunning], 0
;			mov byte [gamePaused], 0
;			call clrscr
;			jmp _isr_ret_
;		_pause_not_y_:
;
;		;resume if n
;		cmp al, 0x31
;		jne _isr_ret_
;			;rehook timer 
;			call hookTimerISR
;			;resume game
;			mov byte [gamePaused], 0
;			jmp _isr_ret_
;	_game_not_paused_:

	;Exit screen (press y to restart, n to exit)
	cmp byte [gameEnded], 1
	jne _game_not_ended_

		cmp al, 0x15
		jne _exit_not_y_
			;restart game
			mov byte [restartGame], 1
			jmp _isr_ret_
		_exit_not_y_:
		cmp al, 0x31
		jne _isr_ret_
			;exit game
			mov byte [exitGame], 1
			jmp _isr_ret_
	_game_not_ended_:



	;escape to pause
	cmp al, 0x01
	jne _not_esc_
		;pause game
		mov byte [gamePaused], 1
	;	;unhook timer (if hooked)
	;	cmp byte [timerHooked], 1
	;	jne _skip_unhooking_
		call unhookTimerISR
		_skip_unhooking_:
		;print pause menu
		call clrscr
		call printPauseMenu
		jmp _isr_ret_
	_not_esc_:

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
mov ax, 0x20
out 0x20, ax
popa
iret

%endif
