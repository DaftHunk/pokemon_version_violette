RockTunnel1Object:
	db $3 ; border block

	db 8 ; warps
	warp 15, 3, 1, -1
	warp 15, 0, 1, -1
	warp 15, 33, 2, -1
	warp 15, 35, 2, -1
	warp 37, 3, 0, ROCK_TUNNEL_B1F
	warp 5, 3, 1, ROCK_TUNNEL_B1F
	warp 17, 11, 2, ROCK_TUNNEL_B1F
	warp 37, 17, 3, ROCK_TUNNEL_B1F

	db 1 ; signs
	sign 11, 29, 8 ; RockTunnel1Text8

	db 7 ; objects
	object SPRITE_HIKER, 7, 5, STAY, DOWN, 1, OPP_HIKER, 8
	object SPRITE_HIKER, 5, 16, STAY, DOWN, 2, OPP_HIKER, 9
	object SPRITE_HIKER, 17, 15, STAY, LEFT, 3, OPP_HIKER, 10
	object SPRITE_BLACK_HAIR_BOY_2, 23, 8, STAY, LEFT, 4, OPP_POKEMANIAC, 1
	object SPRITE_LASS, 37, 21, STAY, LEFT, 5, OPP_JR_TRAINER_F, 6
	object SPRITE_LASS, 22, 24, STAY, DOWN, 6, OPP_JR_TRAINER_F, 7
	object SPRITE_LASS, 32, 24, STAY, RIGHT, 7, OPP_JR_TRAINER_F, 8

	; warp-to
	warp_to 15, 3, ROCK_TUNNEL_1F_WIDTH
	warp_to 15, 0, ROCK_TUNNEL_1F_WIDTH
	warp_to 15, 33, ROCK_TUNNEL_1F_WIDTH
	warp_to 15, 35, ROCK_TUNNEL_1F_WIDTH
	warp_to 37, 3, ROCK_TUNNEL_1F_WIDTH ; ROCK_TUNNEL_B1F
	warp_to 5, 3, ROCK_TUNNEL_1F_WIDTH ; ROCK_TUNNEL_B1F
	warp_to 17, 11, ROCK_TUNNEL_1F_WIDTH ; ROCK_TUNNEL_B1F
	warp_to 37, 17, ROCK_TUNNEL_1F_WIDTH ; ROCK_TUNNEL_B1F
