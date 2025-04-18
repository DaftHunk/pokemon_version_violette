FuchsiaHouse3Script:
	jp EnableAutoTextBoxDrawing

FuchsiaHouse3TextPointers:
	dw FuchsiaHouse3Text1

FuchsiaHouse3Text1:
	TX_ASM
	ld a, [wd728]
	bit 5, a
	jr nz, .after

	ld hl, FuchsiaHouse3Text_561bd
	call PrintText

	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .refused

	;joenote - swap super and good rod locations
	lb bc, SUPER_ROD, 1
	call GiveItem
	jr nc, .full

	ld hl, wd728
	set 5, [hl]

	ld hl, FuchsiaHouse3Text_561c2
	jr .talk

.full
	ld hl, FuchsiaHouse3Text_5621c
	jr .talk

.refused
	ld hl, FuchsiaHouse3Text_56212
	jr .talk

.after
	ld hl, FuchsiaHouse3Text_56217

.talk
	call PrintText
	jp TextScriptEnd

FuchsiaHouse3Text_561bd:
	TX_FAR _FuchsiaHouse3Text_561bd
	db "@"

FuchsiaHouse3Text_561c2:
	TX_FAR _FuchsiaHouse3Text_561c2
	TX_SFX_ITEM_1
	db "@"

FuchsiaHouse3Text_56212:
	TX_FAR _FuchsiaHouse3Text_56212
	db "@"

FuchsiaHouse3Text_56217:
	TX_FAR _FuchsiaHouse3Text_56217
	db "@"

FuchsiaHouse3Text_5621c:
	TX_FAR _FuchsiaHouse3Text_5621c
	db "@"
