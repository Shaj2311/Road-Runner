%ifndef SCENE_H
%define SCENE_H


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

;=========== FUNCTION END: initScene() HELPERS: initVidSeg(), initBG, initTrees(), drawTree(), initRoad(), drawVertLine(), drawLane()  ==============



;=========== FUNCTION: printInstructions() ==============
printInstructions:
pusha 
	;print instructions
	mov ah, 0x13
	xor al, al
	xor bh, bh
	mov bl, 0x07
	mov cx, [instructionStr1Len]
	mov dh, 15
	mov dl, 27
	push cs
	pop es
	mov bp, instructionStr1
	int 0x10

	;print instructions
	mov ah, 0x13
	xor al, al
	xor bh, bh
	mov bl, 0x07
	mov cx, [instructionStr2Len]
	mov dh, 16
	mov dl, 31
	push cs
	pop es
	mov bp, instructionStr2
	int 0x10
popa 
ret
;=========== FUNCTION END: printInstructions() ==============

%endif
