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
push es
push ds


	;point es:di to player position
	mov ax, 0xb800
	mov es, ax
	mov ax, [playerX]	;x position
	sub ax, 3		;offset by 3 locations to center car
	push ax
	mov ax, [playerY]	;y position
	push ax
	call pointToXY


	;point ds:si to car design label
	push cs
	pop ds
	mov si, carDesign

	;print player 
	mov cx, [carHeight]
	printPlayerLoopOuter:
	push di
	push cx
		;draw a row
		mov cx, [carWidth]
		rep movsw
	pop cx
	pop di 
	add di, 160
	loop printPlayerLoopOuter

	

pop ds
pop es
popa
pop bp
ret




;=========== FUNCTION END: initPlayer() HELPERS: drawPlayer(X,Y) ==============


%endif
