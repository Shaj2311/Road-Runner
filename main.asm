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

;TODO: make player functions use this memory label instead of parameters
playerX: dw 0
playerY: dw 19
; According to these values, it appears as if
; the height of the car is lesser than the width.
; Visually, this is not the case, because 
; each video block is rectangular, not square
carWidth: dw 8
carHeight: dw 5
carRectWidth: dw 6
carRectHeight: dw 5


;state of road (under the car)
underCar: times 40 dw 0


start:
        call initRoadValues
        call clrscr
        call initScene
        call initPlayer


	mov ax, 100
	push ax
	call delay

	mov cx, 0xFFFF
	gameLoop:
		;update scene
		;TEST
		mov ax, [playerY]
		push ax
		mov ax, [playerX]
		push ax
		call erasePlayer

		call scrollDown

		;update player
		call initPlayer

		;frame delay
		mov ax, 20
		push ax
		call delay

	loop gameLoop

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
	mov [playerX], ax	;write x position of player
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


	;point di to player position
	mov ax, [bp + 4]	;x position
	sub ax, 2		;offset by 2 locations to center car
	push ax
	mov ax, [bp + 6]	;y position
	push ax
	call pointToXY




	;store state of road
	mov ax, 0		;recursive iteration number
	push ax 		
	mov ax, [carHeight]	;height (number of rows)
	push ax
	mov ax, [carWidth]	;width (number of columns)
	push ax
	mov ax, [bp + 4]	;x position
	push ax
	mov ax, [bp + 6]	;y position
	push ax
	call storeRoadState


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
ret 4


storeRoadState:
push bp
mov bp, sp 
pusha 
push es
push ds
	;check height (base case)
	mov ax, [bp + 10]
	cmp ax, 0 
	je storeRoadStateRet


	;point to position
	mov ax, [bp + 6]	;x 
	push ax 
	mov ax, [bp + 4]	;y 
	push ax
	call pointToXY


	;point ds:si to es:di 
	push es
	pop ds
	mov si, di 

	;point es:di to underCar label
	push cs
	pop es
	mov di, underCar
	;offset by number of iterations completed
	mov ax, [bp + 12]
	mov cx, [bp + 8]
	mul cx
	shl ax, 1 	;convert to word offset
	add di, ax


	;move one row 
	mov cx, [bp + 8]	;width of rectangle being stored
	rep movsw	;store row in label

	;repeat (recursive)
	mov ax, [bp + 12]
	inc ax 			;one more iteration done
	push ax
	mov ax, [bp + 10]
	dec ax 			;one less row 
	push ax 
	mov ax, [bp + 8]	;width is same
	push ax
	mov ax, [bp + 6]
	push ax 		;same x position 
	mov ax, [bp + 4]
	inc ax 			;increase y position (next row)
	push ax
	call storeRoadState

	

	storeRoadStateRet:
pop ds
pop es
popa 
pop bp
ret 10




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



;=========== FUNCTION: scrollDown() ==============
scrollDown:
;pusha
push ax
push cx
push si
push di 
push es
push ds

	;Source = last line 
	mov ax, 0xb800
	mov ds, ax
	mov ax, 4000
	mov si, ax

	;Destination = first line after end of video segment
	mov ax, 0xb800
	mov es, ax
	mov ax, 4000
	add ax, 160
	mov di, ax

	
	mov cx, 2000 	;entire screen

	std		;override from the bottom up
	rep movsw	;scroll down

	;FIXME
	;move scrolled line to top
	mov si, 4000
	mov di, 0
	mov cx, 80
	
	cld 
	rep movsw


pop ds
pop es
pop di 
pop si 
pop cx
pop ax
;popa
ret
;=========== FUNCTION: erasePlayer() ==============

erasePlayer:
push bp
mov bp, sp
pusha

	mov ax, 0xb800
	mov es, ax

	mov ax, [bp + 4]	;x position
	sub ax, 2		;offset by 2 locations to center erase grid
	push ax
	mov ax, [bp + 6]	;y position
	push ax
	call pointToXY

	;draw road (from underCar label)
	;actually, this draws a black rectangle
	mov ax, [carRectHeight]
	push ax
	mov ax, [carRectWidth]
	push ax
	mov ax, 0x0720
	push ax
	call drawRect

	;erase cool wheels
	push di
	mov cx, 0x0720
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
ret 4



;=========== FUNCTION END: erasePlayer() ==============



terminate:
mov ax, 0x4c00
int 0x21
