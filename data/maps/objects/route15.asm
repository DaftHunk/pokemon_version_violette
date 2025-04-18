Route15Object:
	db $43 ; border block

	db 4 ; warps
	warp 7, 8, 0, ROUTE_15_GATE_1F
	warp 7, 9, 1, ROUTE_15_GATE_1F
	warp 14, 8, 2, ROUTE_15_GATE_1F
	warp 14, 9, 3, ROUTE_15_GATE_1F

	db 1 ; signs
	sign 39, 9, 12 ; Route15Text12

	db 11 ; objects
	object SPRITE_LASS, 41, 11, STAY, DOWN, 1, OPP_JR_TRAINER_F, 16
	object SPRITE_LASS, 53, 10, STAY, LEFT, 2, OPP_JR_TRAINER_F, 17
	object SPRITE_BLACK_HAIR_BOY_1, 31, 13, STAY, UP, 3, OPP_BIRD_KEEPER, 10
	object SPRITE_BLACK_HAIR_BOY_1, 35, 13, STAY, UP, 4, OPP_BIRD_KEEPER, 11
	object SPRITE_FOULARD_WOMAN, 53, 11, STAY, DOWN, 5, OPP_BEAUTY, 6
	object SPRITE_FOULARD_WOMAN, 41, 10, STAY, RIGHT, 6, OPP_BEAUTY, 7
	object SPRITE_BIKER, 48, 10, STAY, DOWN, 7, OPP_BIKER, 6
	object SPRITE_BIKER, 46, 10, STAY, DOWN, 8, OPP_BIKER, 7
	object SPRITE_LASS, 37, 5, STAY, RIGHT, 9, OPP_JR_TRAINER_F, 18
	object SPRITE_LASS, 18, 13, STAY, UP, 10, OPP_JR_TRAINER_F, 19
	object SPRITE_BALL, 18, 5, STAY, NONE, 11, TM20_RAGE

	; warp-to
	warp_to 7, 8, ROUTE_15_WIDTH ; ROUTE_15_GATE_1F
	warp_to 7, 9, ROUTE_15_WIDTH ; ROUTE_15_GATE_1F
	warp_to 14, 8, ROUTE_15_WIDTH ; ROUTE_15_GATE_1F
	warp_to 14, 9, ROUTE_15_WIDTH ; ROUTE_15_GATE_1F
