CeladonMart3_h:
	db LOBBY ; tileset
	db CELADON_MART_3F_HEIGHT, CELADON_MART_3F_WIDTH ; dimensions (y, x)
	dw CeladonMart3Blocks, CeladonMart3TextPointers, CeladonMart3Script ; blocks, texts, scripts
	db 0 ; connections
	dw CeladonMart3Object ; objects
