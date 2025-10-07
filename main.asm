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
        
        ;loop counter
        mov cx, 1
        roadLoop:
                push cx                 ;line number
                call drawRoadColumn

                ;loop back
                inc cx
                cmp cx, 25
                jb roadLoop

popa
ret




drawRoadColumn:
push bp
mov bp, sp
push ax
push cx
push bx
push es
push di
push si
;TODO: FIX POPS
        mov si, 0
        ;store vertical offset in ax
        mov bx, [bp + 4]        ;dx = line number
        mov ax, 160
        mul bx
        

        ;add vertical offset to di
        add si, ax              

        ;add horizontal offset to di
        add si, [roadStart]

        ;SI NOW POINTS TO CORRECT DRAWING LOCATION
        ;DI POINTS TO FIRST LINE + HORIZONTAL OFFSET



        mov cx, [roadWidth]     ;loop counter
        mov di, [roadStart]     ;point di to start of road (first line)
        ;draw one column
        initRoadColumn:

                ; ||    |       |       ||
                ;

                ;load correct character in ax
                mov ax, 0x0720  ;space with normal attribute

                cmp di, [roadStart]     ;start of road: ||
                je setRoadSideChar

                cmp di, [roadLane0]       ;lane: |
                je setRoadLaneChar

                cmp di, [roadLane1]       ;lane: |
                je setRoadLaneChar

                cmp di, [roadLane2]       ;lane: |
                je setRoadLaneChar

                cmp di, [roadEnd]       ;end of road: ||
                je setRoadSideChar

                initRoadColumnRet:

                ;draw character to screen
                mov [es:si], ax
                add di, 2
                add si, 2
                ;loop back
        loop initRoadColumn
pop si
pop di
pop es
pop bx
pop cx
pop ax
pop bp
ret 2



setRoadSideChar:
        mov ah, 0x07    ;normal attribute
        mov al, 0xBA    ;||
jmp initRoadColumnRet
setRoadLaneChar:
        mov ah, 0x07    ;normal attribute
        mov al, 0x7C     ;|
jmp initRoadColumnRet
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
