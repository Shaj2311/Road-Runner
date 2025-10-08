[org 0x100]
jmp start

roadStart: dw 40
roadWidth: dw 80
roadLane0: dw 0
roadLane1: dw 0
roadLane2: dw 0
roadEnd: dw 0

sceneInitTest: db "Scene initialized"
playerInitTest: db "Player initialized"
sceneStrLength: dw 17
playerStrLength: dw 18

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









;=========== FUNCTION: initScene() HELPERS: initRoad(), drawRoadColumn(), setRoadSideChar(), setRoadLaneChar() ==============
;draws background for the first time
initScene:
pusha


        ;initialize es and di
        call initVidSeg

        call initRoad

        ;print scene



popa
ret


;prints road for the first time (assumes initVidSeg called by parent function)
initRoad:
pusha
        
	;push params
	push word [roadStart]	;x position
	push 0x07BA		;character
	call drawVertLine

	push word [roadLane1]	;x position
	push 0x077C		;character
	call drawVertLine

	push word [roadLane2]	;x position
	push 0x077C		;character
	call drawVertLine
	
	push word [roadEnd]	;x position
	push 0x07BA		;character
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




;=========== FUNCTION END: initScene() HELPERS: initRoad(), drawRoadColumn(), setRoadSideChar(), setRoadLaneChar() ==============






;=========== FUNCTION: initPlayer() ==============
;draws background for the first time
initPlayer:
pusha


        ;initialize es and di
        call initVidSeg

        ;print player


popa
ret
;=========== FUNCTION END: initPlayer() ==============



terminate:
mov ax, 0x4c00
int 0x21



;points es:di to start of video segment
initVidSeg:
push ax
mov ax, 0xb800
mov es, ax
mov di, 0
pop ax
ret
