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
	jbe _no_collide_1_

	;if car is below player, skip
	add ax, [carHeight]	;add height of player car
	mov bx, [car1XY]
	sub bx, [carHeight]	;bx = top left of car1
	cmp ax, bx
	jbe _no_collide_1_
	
	;check x position
	;if playerX <= car1X and (playerX + playerWidth) >= car1X, collision

	;check playerX <= car1X
	mov ax, [playerX]
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
	jnae _no_collide_1_
	;potential collision, check second condition

	;check car1X+carWidth >= playerX
	mov ax, [car1XY]
	add ax, [carWidth]
	cmp ax, [playerX]
	jnae _no_collide_1_
	;collision happened


	_no_collide_1_:
	;return 0
	mov word [bp + 4], 0
	jmp car1CollRet


	collisionCar1:
	;if collision,
		;hide car 
		mov word [drawCar1Status], 0 
		;return 1 
		mov word [bp + 4], 1

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
	jbe _no_collide_2_

	;if car is below player, skip
	add ax, [carHeight]	;add height of player car
	mov bx, [car2XY]
	sub bx, [carHeight]	;bx = top left of car2
	cmp ax, bx
	jbe _no_collide_2_
	
	;check x position
	;if playerX <= car2X and (playerX + playerWidth) >= car2X, collision

	;check playerX <= car2X
	mov ax, [playerX]
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
	jnae _no_collide_2_
	;potential collision, check second condition

	;check car2X+carWidth >= playerX
	mov ax, [car2XY]
	add ax, [carWidth]
	cmp ax, [playerX]
	jnae _no_collide_2_
	;collision happened


	_no_collide_2_:
	;return 0
	mov word [bp + 4], 0
	jmp car2CollRet


	collisionCar2:
	;if collision,
		;hide car 
		mov word [drawCar2Status], 0 
		;return 2 
		mov word [bp + 4], 1

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
	jbe _no_collide_

	;if car is below player, skip
	add ax, [carHeight]	;add height of player car
	mov bx, [coinXY]
	sub bx, [carHeight]	;bx = top left of coin
	cmp ax, bx
	jbe _no_collide_
	
	;check x position
	;if playerX <= coinX and (playerX + playerWidth) >= coinX, collision

	;check playerX <= coinX
	mov ax, [playerX]
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
	jnae _no_collide_
	;potential collision, check second condition

	;check coinX+carWidth >= playerX
	mov ax, [coinXY]
	add ax, [carWidth]
	cmp ax, [playerX]
	jnae _no_collide_
	;collision happened


	_no_collide_:
	;return 0
	mov word [bp + 4], 0
	jmp coinCollRet


	collisionCoin:
	;if collision,
		;hide car 
		mov word [drawCoinStatus], 0 
		;return 2 
		mov word [bp + 4], 1

coinCollRet:
popa
pop bp
ret
;======== FUNCTION END: checkCoinCollision() ============
%endif
