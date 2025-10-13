[org 0x100]
jmp start

;THESE ARE POSITIONS AND SIZES, NOT OFFSETS
;MULTIPLY BY 2
roadStart: dw 20
roadWidth: dw 40
roadLane0: dw 0
roadLane1: dw 0
roadLane2: dw 0
roadEnd: dw 0

playerY: dw 19
carWidth: dw 5
carHeight: dw 6


start:
        call initRoadValues
        call clrscr
        call initScene
        call initPlayer
        jmp terminate




;======== FUNCTION initRoadValues() =========
initRoadValues:
pusha

        ;divide roadwidth by 3, store lane width in ax
        xor dx, dx
        mov ax, [roadWidth]
        mov bx, 3
        div bx


        ;store positions of each lane
        mov dx, [roadStart]

        ;lane 0 position
        add [roadLane0], dx

        ;lane 1 position
        add [roadLane1], dx     ;add roadstart
        add [roadLane1], ax     ;add lane width
        
        ;lane 2 position
        add [roadLane2], dx     ;add roadstart
        add [roadLane2], ax     ;add lane width
        add [roadLane2], ax     ;add lane width

        ;end of road
        add [roadEnd], dx       ;add roadstart
        mov cx, [roadWidth]
        add [roadEnd], cx       ;add roadwidth

popa
ret
;======== FUNCTION END: initRoadValues() =========






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









;=========== FUNCTION: initScene() HELPERS: initVidSeg(), initBG, initTrees(), drawTree(), initRoad(), drawVertLine(), drawLane()  ==============
;draws background for the first time
initScene:
pusha


        ;initialize es and di
        call initVidSeg
	
	call initBG

	call initTrees

        call initRoad

        ;print scene



popa
ret


;prints plain background for the first time (assumes initVidSeg called by parent function)
initBG:
pusha

	;print left side
	mov dx, 0		;segment offset
	leftLoop:
		push dx 	;x position
		mov ax, 0x2020	;character
		push ax
		call drawVertLine
	inc dx
	cmp dx, [roadStart]
	jb leftLoop

	;print right side
	mov dx, [roadEnd]
	rightLoop:
		push dx 	;x position
		mov ax, 0x2020	;character
		push ax
		call drawVertLine
	inc dx
	cmp dx, 80
	jb rightLoop

		
popa
ret



;Assumes initVidSeg called by parent function
initTrees:
	;left side
	push 6		;x position
	push 4		;y position
	call drawTree

	push 2
	push 11
	call drawTree

	push 9
	push 19
	call drawTree


	;right side
	push 74
	push 8
	call drawTree

	push 68
	push 17
	call drawTree
ret



drawTree:
push bp
mov bp, sp

pusha
	;point di to x/y position
	mov ax, [bp + 6]	;x position
	push ax
	mov ax, [bp + 4]	;y position
	push ax
	call pointToXY

	;load attribute
	mov ah, 0x28	;green background, high intensity green foreground

	;print tree
	mov al, '<'
	mov [es:di], ax
	add di, 2

	mov al, '^'
	mov [es:di], ax
	add di, 2

	mov al, '>'
	mov [es:di], ax
	
	sub di, 2
	add di, 160
	mov al, '|'
	mov [es:di], ax


popa
pop bp
ret 4
	




;prints road for the first time (assumes initVidSeg called by parent function)
initRoad:
pusha
        
	;push params
	push word [roadStart]	;x position
	push 0x06BA		;character
	call drawVertLine

	push word [roadLane1]	;x position
	push 0x077C		;character
	call drawLane

	push word [roadLane2]	;x position
	push 0x077C		;character
	call drawLane
	
	push word [roadEnd]	;x position
	push 0x06BA		;character
	call drawVertLine

popa
ret



drawVertLine:
push bp
mov bp, sp
pusha
	;copy character to ax
	mov ax, [bp + 4]

	;move di to x location, top row
	mov di, [bp + 6]
	shl di, 1			;multiply by 2 to convert to segment offset

	;25 row loop
	mov cx, 25

	vertLineLoop:
		;print to screen
		mov [es:di], ax
		;move di to next row
		add di, 160
	;loop back
	loop vertLineLoop

	

popa
pop bp
ret 4


drawLane:
push bp
mov bp, sp
pusha
	;copy character to ax
	mov ax, [bp + 4]

	;move di to x location, top row
	mov di, [bp + 6]
	shl di, 1			;multiply by 2 to convert to segment offset

	;25 row loop
	mov cx, 25
	mov dx, 0
	
	laneLoop:
		
		cmp dx, 3
		jne skipReset

		;skip drawing
		mov dx, 0
		add di, 160
		dec cx
		jmp laneLoop

		;draw character
		skipReset:
		mov [es:di], ax
		add di, 160
		inc dx

		
		loop laneLoop
	


popa
pop bp
ret 4


;points es:di to start of video segment
initVidSeg:
push ax
mov ax, 0xb800
mov es, ax
mov di, 0
pop ax
ret

;=========== FUNCTION END: initScene() HELPERS: initVidSeg(), initBG, initTrees(), drawTree(), initRoad(), drawVertLine(), drawLane()  ==============






;=========== FUNCTION: initPlayer() HELPERS: drawPlayer(X,Y) ==============
;draws background for the first time
initPlayer:
pusha


        ;initialize es and di
        call initVidSeg

        ;print player
	mov ax, [playerY]	;y position
	push ax
	;calculate x position
	mov ax, [roadLane1]	;x position
	add ax, [roadLane2]
	shr ax, 1	;divide by 2 (average)
	push ax
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

	mov ax, [bp + 4]	;x position
	sub ax, 2		;offset by 2 locations to center car
	push ax
	mov ax, [bp + 6]	;y position
	push ax
	call pointToXY








	;draw car rectangle
	mov ax, [carHeight]
	push ax
	mov ax, [carWidth]
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
	;push di
	add di, 160
	add di, 2
	mov ax, [carHeight]
	sub ax, 2
	push ax
	mov ax, [carWidth]
	sub ax, 2
	push ax
	mov ah, 0x04
	mov al, ' '
	push ax
	call drawRect
	;pop di




popa
pop bp
ret 4



;drawRect(width, height)
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


;FIXME
;=========== FUNCTION: movePlayer(isLeft) ==============
movePlayer:
;Under construction :)
;=========== FUNCTION: movePlayer(isLeft) ==============




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



terminate:
mov ax, 0x4c00
int 0x21
