RockTunnel1_h:
	db CAVERN ; tileset
	db ROCK_TUNNEL_1F_HEIGHT, ROCK_TUNNEL_1F_WIDTH ; dimensions (y, x)
	dw RockTunnel1Blocks, RockTunnel1TextPointers, RockTunnel1Script ; blocks, texts, scripts
	db 0 ; connections
	dw RockTunnel1Object ; objects
