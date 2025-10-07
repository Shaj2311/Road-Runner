[org 0x100]
jmp start

sceneInitTest: db "Scene initialized"
playerInitTest: db "Player initialized"
sceneStrLength: dw 17
playerStrLength: dw 18

start:
        call clrscr
        call initScene
        call initPlayer
        jmp terminate



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









;=========== FUNCTION: initScene() HELPERS: initRoad(), setRoadSideChar(), setRoadMidChar() ==============
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
        add di, 60      ;move di to column (half - 10 (40 - 10))
        roadLoopOuter:
                mov cx, 20      ;20 columns wide road
                ;draw one column
                initRoadColumn:
                        ; ||          |          ||
                        ;if(cx == 20) character = ||
                        ;if(cx == 10) character = |
                        ;if(cx == 0)  character = ||

                        ;load correct character in ax
                        mov ax, 0x0720  ;space with normal attribute
                        cmp cx, 20
                        je setRoadSideChar
                        cmp cx, 10
                        je setRoadMidChar
                        cmp cx, 1
                        je setRoadSideChar
                        initRoadColumnRet:

                        ;draw character to screen
                        mov [es:di], ax
                        add di, 2
                        ;loop back
                loop initRoadColumn

                ;loop back






popa
ret


setRoadSideChar:
        mov ah, 0x07    ;normal attribute
        mov al, 0xBA    ;||
jmp initRoadColumnRet
setRoadMidChar:
        mov ah, 0x07    ;normal attribute
        mov al, 0x7C     ;|
jmp initRoadColumnRet
;=========== FUNCTION END: initScene() HELPERS: initRoad(), setRoadSideChar(), setRoadMidChar() ==============






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
