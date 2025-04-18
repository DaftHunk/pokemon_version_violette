UsedCut:
	xor a
	ld [wActionResultOrTookBattleTurn], a ; initialise to failure value
	
	;joenote - done with a function call to consolidate cuttable tiles to one spot
	call CheckCutTile
	jr nz, .nothingToCut
	jr .canCut	
	
;	ld a, [wCurMapTileset]
;	and a ; OVERWORLD
;	jr z, .overworld
;	cp GYM
;	jr nz, .nothingToCut
;	ld a, [wTileInFrontOfPlayer]
;	cp $50 ; gym cut tree
;	jr nz, .nothingToCut
;	jr .canCut
;.overworld
;	dec a
;	ld a, [wTileInFrontOfPlayer]
;	cp $3d ; cut tree
;	jr z, .canCut
;	cp $52 ; grass
;	jr z, .canCut
.nothingToCut
	ld hl, .NothingToCutText
	jp PrintText

.NothingToCutText
	TX_FAR _NothingToCutText
	db "@"

.canCut
;	ld [wCutTile], a
	ld a, 1
	ld [wActionResultOrTookBattleTurn], a ; used cut
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	ld hl, wd730
	set 6, [hl]
	call GBPalWhiteOutWithDelay3
	call ClearSprites
	call RestoreScreenTilesAndReloadTilePatterns
	ld a, SCREEN_HEIGHT_PIXELS
	ld [hWY], a
	call Delay3
	call LoadGBPal
	call LoadCurrentMapView
	call SaveScreenTilesToBuffer2
	call Delay3
	xor a
	ld [hWY], a
	ld hl, UsedCutText
	call PrintText
	call LoadScreenTilesFromBuffer2
	ld hl, wd730
	res 6, [hl]
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	call InitCutAnimOAM
	ld de, CutTreeBlockSwaps
	call ReplaceTreeTileBlock
	call RedrawMapView
	callba AnimCut
	ld a, $1
	ld [wUpdateSpritesEnabled], a
	ld a, SFX_CUT
	call PlaySound
	ld a, $90
	ld [hWY], a
	call UpdateSprites
	jp RedrawMapView

CheckCutTile:	;joenote - consolidate this into its own function
	ld a, [wCurMapTileset]
	cp OVERWORLD
	jr z, .overworld
	cp GYM
	jr z, .gym
	cp PLATEAU	;added plateau
	jr z, .plateau
	ret	;nz if not one of the listed tilesets
.gym
	ld a, [wTileInFrontOfPlayer]
	cp $50 ; gym cut tree
	jr z, .loadCutTile
	ret	;nz if not a cuttable tile
.plateau
	ld a, [wTileInFrontOfPlayer]
	cp $45 ; grass
	jr z, .loadCutTile
	ret	;nz if not a cuttable tile
.overworld
	ld a, [wTileInFrontOfPlayer]
	cp $3d ; cut tree
	jr z, .loadCutTile
	cp $52 ; grass
	jr z, .loadCutTile
	ret	;nz if not a cuttable tile
.loadCutTile
	ld [wCutTile], a
	ret	;z already set at this return

UsedCutText:
	TX_FAR _UsedCutText
	db "@"

InitCutAnimOAM:
	xor a
	ld [wWhichAnimationOffsets], a
	ld a, %11100100
	ld [rOBP1], a
	call UpdateGBCPal_OBP1
	ld a, [wCutTile]
	cp $52
	jr z, .grass
	cp $45	;joenote - added plateau grass
	jr z, .grass
; tree
	ld de, Overworld_GFX + $2d0 ; cuttable tree sprite top row
	ld hl, vChars1 + $7c0
	lb bc, BANK(Overworld_GFX), $02
	call CopyVideoData
	ld de, Overworld_GFX + $3d0 ; cuttable tree sprite bottom row
	ld hl, vChars1 + $7e0
	lb bc, BANK(Overworld_GFX), $02
	call CopyVideoData
	ld d, 4		;specify OB pal
	callba WriteCutOrBoulderDustAnimationOAMBlock
	ret	
.grass
	ld hl, vChars1 + $7c0
	call LoadCutGrassAnimationTilePattern
	ld hl, vChars1 + $7d0
	call LoadCutGrassAnimationTilePattern
	ld hl, vChars1 + $7e0
	call LoadCutGrassAnimationTilePattern
	ld hl, vChars1 + $7f0
	call LoadCutGrassAnimationTilePattern
	ld d, 4	;specify OB pal
	callba WriteCutOrBoulderDustAnimationOAMBlock
	ld hl, wOAMBuffer + $93
	ld de, 4

;	ld a, $30	;gbcnote - This is a bug. It overrides CutOrBoulderDustAnimationTilesAndAttributes and defaults to pal 0	
	ld a, [hl]
	and $0F
	or $30
	
	ld c, e
.loop
	ld [hl], a
	add hl, de
	xor $60
	dec c
	jr nz, .loop
	ret

LoadCutGrassAnimationTilePattern:
	ld de, AnimationTileset2 + $60 ; tile depicting a leaf
	lb bc, BANK(AnimationTileset2), $01
	jp CopyVideoData

ReplaceTreeTileBlock:
; Determine the address of the tile block that contains the tile in front of the
; player (i.e. where the tree is) and replace it with the corresponding tile
; block that doesn't have the tree.
	push de
	ld a, [wCurMapWidth]
	add 6
	ld c, a
	ld b, 0
	ld d, 0
	ld hl, wCurrentTileBlockMapViewPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, bc
	ld a, [wSpriteStateData1 + 9] ; player sprite's facing direction
	and a
	jr z, .down
	cp SPRITE_FACING_UP
	jr z, .up
	cp SPRITE_FACING_LEFT
	jr z, .left
; right
	ld a, [wXBlockCoord]
	and a
	jr z, .centerTileBlock
	jr .rightOfCenter
.down
	ld a, [wYBlockCoord]
	and a
	jr z, .centerTileBlock
	jr .belowCenter
.up
	ld a, [wYBlockCoord]
	and a
	jr z, .aboveCenter
	jr .centerTileBlock
.left
	ld a, [wXBlockCoord]
	and a
	jr z, .leftOfCenter
	jr .centerTileBlock
.belowCenter
	add hl, bc
.centerTileBlock
	add hl, bc
.aboveCenter
	ld e, $2
	add hl, de
	jr .next
.leftOfCenter
	ld e, $1
	add hl, bc
	add hl, de
	jr .next
.rightOfCenter
	ld e, $3
	add hl, bc
	add hl, de
.next
	pop de
	ld a, [hl]
	ld c, a
.loop ; find the matching tile block in the array
	ld a, [de]
	inc de
	inc de
	cp $ff
	ret z
	cp c
	jr nz, .loop
	dec de
	ld a, [de] ; replacement tile block from matching array entry
	ld [hl], a
	ret

CutTreeBlockSwaps:
; first byte = tileset block containing the cut tree
; second byte = corresponding tileset block after the cut animation happens
	db $32, $6D
	db $33, $6C
	db $34, $6F
	db $35, $4C
	db $60, $6E
	db $0B, $0A
	db $3C, $35
	db $3F, $35
	db $3D, $36
	db $40, $0A	;joenote - plateau grass
	db $FF ; list terminator
