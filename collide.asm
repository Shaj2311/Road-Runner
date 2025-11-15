%ifndef COLLIDE_H
%define COLLIDE_H
%include "labels.asm"

;======== FUNCTION: checkCar1Collision() ============
;returns 1 or 0
checkCar1Collision:
;push bp
;mov bp, sp 
;pusha
;	mov ax, [playerY]
;	cmp [car1XY + 2], ax
;	jae collide1
;		;if no collision,
;		;return 0
;		mov word [bp + 4], 0 
;		jmp car1CollRet
;	collide1:
;	;if collision,
;		;hide car 
;		mov word [drawCar1Status], 0 
;		;return 1 
;		mov word [bp + 4], 1
;
;car1CollRet:
;popa
;pop bp
;ret
push bp
mov bp, sp 
pusha
	;if car is higher than player, skip
	mov ax, [playerY]
	cmp [car1XY + 2], ax
	jb car1CollRet

	;if car is below player, skip
	add ax, [carHeight]	;add height of player car
	mov bx, [car1XY + 2]
	sub bx, [carHeight]	;bx = top left of car1
	cmp ax, bx
	jb car1CollRet
	
	;check x position
	;if playerX <= car1X and (playerX + playerWidth) >= car1X, collision

	;check playerX <= car1X
	mov ax, [playerX]
	inc ax
	cmp ax, [car1XY]
	jnbe _car1_else_if_case2_
	;potential collision, check second condition

	;check playerX+playerWidth >= car1X
	add ax, [carWidth]
	cmp ax, [car1XY]
	jnae _car1_else_if_case2_
	;collision happened
	jmp collisionCar1



	_car1_else_if_case2_:
	;if playerX >= car1X and (car1X + carWidth) >= playerX, collision

	;check playerX >= car1X
	mov ax, [playerX]
	cmp ax, [car1XY]
	jnae car1CollRet
	;potential collision, check second condition

	;check car1X+carWidth >= playerX
	mov ax, [car1XY]
	add ax, [carWidth]
	cmp ax, [playerX]
	jnae car1CollRet
	;collision happened


	collisionCar1:
	;if collision,
		;terminate program
		mov byte [gameIsRunning], 0

car1CollRet:
popa
pop bp
ret
;======== FUNCTION END: checkCar1Collision() ============







;======== FUNCTION: checkCar2Collision() ============
;returns 1 or 0
checkCar2Collision:
push bp
mov bp, sp 
pusha
	;if car is higher than player, skip
	mov ax, [playerY]
	cmp [car2XY + 2], ax
	jb car2CollRet

	;if car is below player, skip
	add ax, [carHeight]	;add height of player car
	mov bx, [car2XY + 2]
	sub bx, [carHeight]	;bx = top left of car2
	cmp ax, bx
	jb car2CollRet
	
	;check x position
	;if playerX <= car2X and (playerX + playerWidth) >= car2X, collision

	;check playerX <= car2X
	mov ax, [playerX]
	inc ax
	cmp ax, [car2XY]
	jnbe _car2_else_if_case2_
	;potential collision, check second condition

	;check playerX+playerWidth >= car2X
	add ax, [carWidth]
	cmp ax, [car2XY]
	jnae _car2_else_if_case2_
	;collision happened
	jmp collisionCar2



	_car2_else_if_case2_:
	;if playerX >= car2X and (car2X + carWidth) >= playerX, collision

	;check playerX >= car2X
	mov ax, [playerX]
	cmp ax, [car2XY]
	jnae car2CollRet
	;potential collision, check second condition

	;check car2X+carWidth >= playerX
	mov ax, [car2XY]
	add ax, [carWidth]
	cmp ax, [playerX]
	jnae car2CollRet
	;collision happened



	collisionCar2:
	;if collision,
		;terminate program
		mov byte [gameIsRunning], 0

car2CollRet:
popa
pop bp
ret
;======== FUNCTION END: checkCar2Collision() ============




;======== FUNCTION: checkCoinCollision() ============
checkCoinCollision:
push bp
mov bp, sp 
pusha
	;if car is higher than player, skip
	mov ax, [playerY]
	cmp [coinXY + 2], ax
	jb coinCollRet

	;if car is below player, skip
	add ax, [carHeight]	;add height of player car
	mov bx, [coinXY + 2]
	sub bx, [carHeight]	;bx = top left of coin
	cmp ax, bx
	jb coinCollRet
	
	;check x position
	;if playerX <= coinX and (playerX + playerWidth) >= coinX, collision

	;check playerX <= coinX
	mov ax, [playerX]
	inc ax
	cmp ax, [coinXY]
	jnbe _coin_else_if_case2_
	;potential collision, check second condition

	;check playerX+playerWidth >= coinX
	add ax, [carWidth]
	cmp ax, [coinXY]
	jnae _coin_else_if_case2_
	;collision happened
	jmp collisionCoin



	_coin_else_if_case2_:
	;if playerX >= coinX and (coinX + carWidth) >= playerX, collision

	;check playerX >= coinX
	mov ax, [playerX]
	cmp ax, [coinXY]
	jnae coinCollRet
	;potential collision, check second condition

	;check coinX+coinWidth >= playerX
	mov ax, [coinXY]
	add ax, [coinWidth]
	cmp ax, [playerX]
	jnae coinCollRet
	;collision happened




	collisionCoin:
	;if collision,
		;increment score
		cmp byte [drawCoinStatus], 1
		jne _skip_score_increment_
		inc word [playerScore]
		_skip_score_increment_:
		;hide coin
		mov byte [drawCoinStatus], 0 

coinCollRet:
popa
pop bp
ret
;======== FUNCTION END: checkCoinCollision() ============
%endif
