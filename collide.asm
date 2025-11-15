%ifndef COLLIDE_H
%define COLLIDE_H
%include "labels.asm"

;======== FUNCTION: checkCar1Collision() ============
;returns 1 or 0
checkCar1Collision:
push bp
mov bp, sp 
pusha
	;if car is higher than player, skip
	;(if playerY > carY, skip)
	mov ax, [playerY]
	cmp [car1XY + 2], ax
	jb car1CollRet

	;if car is below player, skip
	;(if carY > playerY, skip)
	add ax, [carHeight]	;add height of player car
	dec ax
	mov bx, [car1XY + 2]
	sub bx, [carHeight]	;bx = top left of car1
	inc bx
	cmp ax, bx
	jbe car1CollRet
	
	;check x position
	;if playerX == car1X, collision
	mov ax, [playerX]
	cmp ax, [car1XY]
	je collisionCar1

	;if playerX <= car1X and (playerX + playerWidth) >= car1X, collision
	;check playerX <= car1X
	mov ax, [playerX]
	cmp ax, [car1XY]
	jnb _car1_else_if_case2_
	;potential collision, check second condition

	;check playerX+playerWidth >= car1X
	add ax, [carWidth]
	cmp ax, [car1XY]
	jna _car1_else_if_case2_
	;collision happened
	jmp collisionCar1



	_car1_else_if_case2_:
	;if playerX >= car1X and (car1X + carWidth) >= playerX, collision

	;check playerX >= car1X
	mov ax, [playerX]
	cmp ax, [car1XY]
	jna car1CollRet
	;potential collision, check second condition

	;check car1X+carWidth >= playerX
	mov ax, [car1XY]
	add ax, [carWidth]
	cmp ax, [playerX]
	jna car1CollRet
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
checkCar2Collision:
push bp
mov bp, sp 
pusha
	;if car is higher than player, skip
	;(if playerY > carY, skip)
	mov ax, [playerY]
	cmp [car2XY + 2], ax
	jb car2CollRet

	;if car is below player, skip
	;(if carY > playerY, skip)
	add ax, [carHeight]	;add height of player car
	dec ax
	mov bx, [car2XY + 2]
	sub bx, [carHeight]	;bx = top left of car1
	inc bx
	cmp ax, bx
	jbe car1CollRet
	
	;check x position
	;if playerX == car2X, collision
	mov ax, [playerX]
	cmp ax, [car2XY]
	je collisionCar2

	;if playerX <= car2X and (playerX + playerWidth) >= car2X, collision
	;check playerX <= car2X
	mov ax, [playerX]
	cmp ax, [car2XY]
	jnb _car2_else_if_case2_
	;potential collision, check second condition

	;check playerX+playerWidth >= car2X
	add ax, [carWidth]
	cmp ax, [car2XY]
	jna _car2_else_if_case2_
	;collision happened
	jmp collisionCar2



	_car2_else_if_case2_:
	;if playerX >= car2X and (car2X + carWidth) >= playerX, collision

	;check playerX >= car2X
	mov ax, [playerX]
	cmp ax, [car2XY]
	jna car2CollRet
	;potential collision, check second condition

	;check car2X+carWidth >= playerX
	mov ax, [car2XY]
	add ax, [carWidth]
	cmp ax, [playerX]
	jna car2CollRet
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
	;if coin is higher than player, skip
	mov ax, [playerY]
	cmp [coinXY + 2], ax
	jb coinCollRet

	;if coin is below player, skip
	add ax, [carHeight]	;add height of player car
	mov bx, [coinXY + 2]
	sub bx, [carHeight]	;bx = top left of coin
	cmp ax, bx
	jb coinCollRet
	
	;check x position
	;if playerX <= coinX and (playerX + playerWidth) >= coinX, collision

	;check playerX <= coinX
	mov ax, [playerX]
	;inc ax
	cmp ax, [coinXY]
	jnb _coin_else_if_case2_
	;potential collision, check second condition

	;check playerX+playerWidth >= coinX
	add ax, [carWidth]
	cmp ax, [coinXY]
	jna _coin_else_if_case2_
	;collision happened
	jmp collisionCoin



	_coin_else_if_case2_:
	;if playerX >= coinX and (coinX + carWidth) >= playerX, collision

	;check playerX >= coinX
	mov ax, [playerX]
	cmp ax, [coinXY]
	jna coinCollRet
	;potential collision, check second condition

	;check coinX+coinWidth >= playerX
	mov ax, [coinXY]
	add ax, [coinWidth]
	cmp ax, [playerX]
	jna coinCollRet
	;collision happened




	collisionCoin:
	;if collision,
		;increment score
		cmp byte [drawCoinStatus], 1
		jne _skip_score_increment_
		add word [playerScore], 5
		_skip_score_increment_:
		;hide coin
		mov byte [drawCoinStatus], 0 

coinCollRet:
popa
pop bp
ret
;======== FUNCTION END: checkCoinCollision() ============
%endif
