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

randomSeed: dw 0x1234

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
%endif
