%ifndef LABELS_H
%define LABELS_H

;THESE ARE POSITIONS AND SIZES, NOT OFFSETS
;MULTIPLY BY 2
roadStart: dw 20
roadWidth: dw 40
roadLane0: dw 0
roadLane1: dw 0
roadLane2: dw 0
roadEnd: dw 0

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

playerScore: dw 0

;screen state (without player car)
screenState: times 2000 dw 0

;X,Y position of 2 oncoming cars
car1XY: dw 0,0
car2XY: dw 0,0


carDesign: 
dw 0x0000, 0x042f, 0x04DB, 0x04DB, 0x04DB, 0x04DB, 0x045c, 0x0000, 
dw 0x08DB, 0x04DB, 0x04DB, 0x04DB, 0x04DB, 0x04DB, 0x04DB, 0x08DB,
dw 0x0000, 0x04DB, 0x04DB, 0x0000, 0x0000, 0x04DB, 0x04DB, 0x0000,
dw 0x08DB, 0x04DB, 0x04DB, 0x04DB, 0x04DB, 0x04DB, 0x04DB, 0x08DB,
dw 0x0000, 0x045c, 0x04DB, 0x04DB, 0x04DB, 0x04DB, 0x042f, 0x0000, 

defaultCarAttrib: db 0x04

trafficAttribs: db 0x01, 0x02, 0x06, 0x05
trafficAttribIndex: dw 0
car1attrib: db 0
car2attrib: db 0

coin:
dw 0x0eda, 0x0edc, 0x0edc, 0x0edc, 0x0ebf,
dw 0x0ede, 0x6e00, 0x6e24, 0x6e00, 0x0edd,
dw 0x0ec0, 0x0edf, 0x0edf, 0x0edf, 0x0ed9

coinXY: dw 0,0		;bottom right corner of coin

coinWidth: dw 5
coinHeight: dw 3

randomSeed: dw 0xBEEF

;spawn intervals in frames
carSpawnInterval: db 30
coinSpawnInterval: db 60

;counters for spawn interval checking
car1SpawnElapsed: db 0
car2SpawnElapsed: db 15		;15 frame offset so both cars are printed with a distance of 15 frames
coinSpawnElapsed: db 7		;similar thing for coin

car2InitialDelay: db 15
coinInitialDelay: db 7

;boolean values
drawCar1Status: db 0
drawCar2Status: db 0
drawCoinStatus: db 0

oldKBisr: dw 0,0

gameIsRunning: db 0

scoreStr: db 'Score: '
scoreAmountStr: dw 0, 0, 0, 0, 0
scoreStrSize: dw scoreStrSize - scoreStr

isIntro: db 0

introWidth: db 70
introHeight: db 6
introDesign:
db " _____   ____          _____  _____  _    _ _   _ _   _ ______ _____  ",
db "|  __ \ / __ \   /\   |  __ \|  __ \| |  | | \ | | \ | |  ____|  __ \ ",
db "| |__) | |  | | /  \  | |  | | |__) | |  | |  \| |  \| | |__  | |__) |",
db "|  _  /| |  | |/ /\ \ | |  | |  _  /| |  | | . ` | . ` |  __| |  _  / ",
db "| | \ \| |__| / ____ \| |__| | | \ \| |__| | |\  | |\  | |____| | \ \ ",
db "|_|  \_\\____/_/    \_\_____/|_|  \_\\____/|_| \_|_| \_|______|_|  \_\ "
nameStr:	db "Name: Haider Ali"
nameStrLen: 	dw nameStrLen - nameStr
rollNoStr:	db "Roll Number: 24L-0882"
rollNoStrLen: 	dw rollNoStrLen - rollNoStr
sectionStr:	db "Section: BCS-5A"
sectionStrLen: 	dw sectionStrLen - sectionStr
introPromptStr: db "Press Any Key To Continue"
introPromptStrLen: dw introPromptStrLen - introPromptStr

instructionStr1: db "ARROW KEYS: MOVE LEFT/RIGHT"
instructionStr1Len: dw instructionStr1Len - instructionStr1
instructionStr2: db "ESCAPE: PAUSE/QUIT"
instructionStr2Len: dw instructionStr2Len - instructionStr2

gamePaused: db 0

pausedMessageStr: 	db "Are you sure you want to quit? (Y/N)"
pausedMessageStrLen: 	dw pausedMessageStrLen - pausedMessageStr

exitMessageStr: db "GAME OVER"
exitMessageStrLen: dw exitMessageStrLen - exitMessageStr
exitScoreStr: db "Your Score: "
exitScoreStrLen: dw exitScoreStrLen - exitScoreStr
exitPromptStr: db "Play Again? (Y/N)"
exitPromptStrLen: dw exitPromptStrLen - exitPromptStr

gameEnded: db 0
exitGame: db 0
restartGame: db 0


resetFlags:
push ax
	;reset score
	mov word [playerScore], 0

	;reset score string
	mov word [scoreAmountStr], 0
	mov word [scoreAmountStr + 2], 0
	mov word [scoreAmountStr + 4], 0
	mov word [scoreAmountStr + 6], 0
	mov word [scoreAmountStr + 8], 0
	xor ax, ax
	mov ax, scoreStrSize
	sub ax, scoreStr
	mov [scoreStrSize], ax
	
	;spawn timers
	mov byte [car1SpawnElapsed], 0
	mov byte [car2SpawnElapsed], 15
	mov byte [coinSpawnElapsed], 7

	mov byte [drawCar1Status], 0
	mov byte [drawCar2Status], 0
	mov byte [drawCoinStatus], 0

	mov byte [gameIsRunning], 0
	mov byte [isIntro], 0
	mov byte [gamePaused], 0
	mov byte [gameEnded], 0 

	mov byte [exitGame], 0
	mov byte [restartGame], 0
pop ax
ret

%endif
