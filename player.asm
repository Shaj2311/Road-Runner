%ifndef PLAYER_H
%define PLAYER_H


;=========== FUNCTION: initPlayer() HELPERS: drawPlayer(X,Y) ==============
;draws background for the first time
initPlayer:
pusha


        ;initialize es and di
        call initVidSeg

	;calculate x position
	mov ax, [roadLane1]	;x position
	add ax, [roadLane2]
	shr ax, 1	;divide by 2 (average)
	mov [playerX], ax	;write x position of player


        ;print player
	call drawPlayer
	
popa
ret


;takes x and y as parameters, prints car such that MIDDLE of front bumper touches (x,y)
drawPlayer:
push bp
mov bp, sp
pusha

	mov ax, 0xb800
	mov es, ax


	;point di to player position
	mov ax, [playerX]	;x position
	sub ax, 2		;offset by 2 locations to center car
	push ax
	mov ax, [playerY]	;y position
	push ax
	call pointToXY



	;draw car from memory
	;draw car rectangle
	mov ax, [carRectHeight]
	push ax
	mov ax, [carRectWidth]
	push ax
	mov ax, 0x4020
	push ax
	call drawRect

	;print cool stuff
	mov ah, 0x04
	mov al, '/'
	mov [es:di], ax
	mov [es:di + 160*(5 - 1) + (12 - 2)], ax	;(height-1) spaces down, (width-1) spaces across
	
	mov al, '\'
	mov [es:di + (12 - 2)], ax
	mov [es:di + 160*(5 - 1)], ax			;(height-1) spaces down

	

	;draw cool smol rectangle
	push di
		add di, 160
		add di, 160
		add di, 2
		add di, 2
		mov ax, [carRectHeight]
		sub ax, 4
		push ax
		mov ax, [carRectWidth]
		sub ax, 4
		push ax
		mov ah, 0x04
		mov al, ' '
		push ax
		call drawRect
	pop di

	;draw cool wheels
	push di
	mov cx, 0x08DB
	mov [es:di + 160 - 2], cx

	push di
		mov ax, [carRectWidth]	;get width of car
		shl ax, 1		;multiply by 2 (convert to byte offset)
		add di, ax
		mov [es:di + 160], cx
	pop di

	push di
		mov ax, [carRectHeight]	;get height of car
		sub ax, 2		;both bumpers
		mov bx, 160		;multiply by 160
		mul bx
		add di, ax
		mov [es:di - 2], cx
		mov ax, [carRectWidth]
		shl ax, 1
		add di, ax
		mov [es:di], cx
	pop di
	;mov [es:di + 160 + 2*4] dx
	pop di





popa
pop bp
ret






;drawRect(height, width)
drawRect:
push bp
mov bp, sp
pusha
	
	;print rectangle
	mov ax, [bp + 4]
	mov cx, [bp + 6]
	rectOuter:
	push cx
		mov cx, [bp + 8]
		push di
		rectInner:
			mov [es:di], ax
			add di, 160
		loop rectInner
		pop di
	add di, 2
	pop cx
	loop rectOuter
popa
pop bp
ret 6
;=========== FUNCTION END: initPlayer() HELPERS: drawPlayer(X,Y) ==============


%endif
