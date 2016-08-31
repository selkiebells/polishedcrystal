String_89116:
	db "-----@"

String_89153: ; 89153
	db   "メッセージは ありません@"    ; No message
; 89160

OpenSRAMBank4: ; 89160
	push af
	ld a, $4
	call GetSRAMBank
	pop af
	ret
; 89168

Function89168: ; 89168 (22:5168)
	ld hl, GameTimerPause
	set 7, [hl]
	ret

Function89185: ; 89185 (22:5185)
; Compares c bytes starting at de and hl and incrementing together until a match is found.
	push de
	push hl
.loop
	ld a, [de]
	inc de
	cp [hl]
	jr nz, .done
	inc hl
	dec c
	jr nz, .loop
.done
	pop hl
	pop de
	ret

Function89193: ; 89193
; Copies c bytes from hl to de.
	push de
	push hl
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	pop hl
	pop de
	ret
; 8919e

Function891ab: ; 891ab
	call Function89240
	callba ReloadMapPart
	call Function8923c
	ret
; 891b8

Function891b8: ; 891b8
	call Function8923c
	hlcoord 0, 0
	ld a, " "
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	call ByteFill
	call DelayFrame
	ret
; 891ca

Function891de: ; 891de
	call Function8923c
	call ClearPalettes
	hlcoord 0, 0, AttrMap
	ld a, $7
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	call ByteFill
	hlcoord 0, 0
	ld a, " "
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	call ByteFill
	call Function891ab
	ret
; 891fe

Function891fe: ; 891fe
	push bc
	call Function891de
	ld c, $10
	call DelayFrames
	pop bc
	ret
; 89209

Function89209: ; 89209
	ld a, 1
	ld [wSpriteUpdatesEnabled], a
	ret
; 8920f

Function8920f: ; 8920f
	ld a, 0
	ld [wSpriteUpdatesEnabled], a
	ret
; 89215

Function89215: ; 89215
	push hl
	push bc
	ld bc, AttrMap - TileMap
	add hl, bc
	ld [hl], a
	pop bc
	pop hl
	ret
; 8921f

Function89235: ; 89235 (22:5235)
	call JoyWaitAorB
	call PlayClickSFX
	ret

Function8923c: ; 8923c
	xor a
	ld [hBGMapMode], a
	ret
; 89240

Function89240: ; 89240
	ld a, $1
	ld [hBGMapMode], a
	ret
; 89245


Function89245: ; 89245 (22:5245)
	callba TryLoadSaveFile
	ret c
	callba _LoadData
	and a
	ret

Function89259: ; 89259
	ld bc, $0e07
	jr Function89261

Function8925e: ; 8925e
	ld bc, $0e0c

Function89261: ; 89261
	push af
	push bc
	ld hl, MenuDataHeader_0x892a3
	call CopyMenuDataHeader
	pop bc
	ld hl, wMenuBorderTopCoord
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	ld a, c
	add $4
	ld [hli], a
	ld a, b
	add $5
	ld [hl], a
	pop af
	ld [wMenuCursorBuffer], a
	call PushWindow
	call Function8923c
	call Function89209
	call VerticalMenu
	push af
	ld c, $a
	call DelayFrames
	call CloseWindow
	call Function8920f
	pop af
	jr c, .done
	ld a, [wMenuCursorY]
	cp $2
	jr z, .done
	and a
	ret

.done
	scf
	ret
; 892a3

MenuDataHeader_0x892a3: ; 0x892a3
	db $40 ; flags
	db 05, 10 ; start coords
	db 09, 15 ; end coords
	dw MenuData2_0x892ab
	db 1 ; default option
; 0x892ab

MenuData2_0x892ab: ; 0x892ab
	db $c0 ; flags
	db 2 ; items
	db "はい@"
	db "いいえ@"
; 0x892b4

Function892b4: ; 892b4 (22:52b4)
	call Function8931b

Function892b7: ; 892b7
	ld d, b
	ld e, c
	ld hl, 0
	add hl, bc
	ld a, "@"
	ld bc, 6
	call ByteFill
	ld b, d
	ld c, e
	ld hl, 6
	add hl, bc
	ld a, "@"
	ld bc, 6
	call ByteFill
	ld b, d
	ld c, e
	ld hl, 12
	add hl, bc
	xor a
	ld [hli], a
	ld [hl], a
	ld hl, 14
	add hl, bc
	ld [hli], a
	ld [hl], a
	ld hl, 16
	add hl, bc
	ld [hl], a
	ld hl, 17
	add hl, bc
	ld a, -1
	ld bc, 8
	call ByteFill
	ld b, d
	ld c, e
	ld e, 6
	ld hl, 25
	add hl, bc
.loop
	ld a, -1
	ld [hli], a
	ld a, -1
	ld [hli], a
	dec e
	jr nz, .loop
	ret
; 89305


Function89305: ; 89305 (22:5305)
	xor a
	ld [MenuSelection], a
	ld c, 40
.loop
	ld a, [MenuSelection]
	inc a
	ld [MenuSelection], a
	push bc
	call Function892b4
	pop bc
	dec c
	jr nz, .loop
	ret

Function8931b: ; 8931b
	push hl
	ld hl, $a03b
	ld a, [MenuSelection]
	dec a
	ld bc, $0025
	call AddNTimes
	ld b, h
	ld c, l
	pop hl
	ret
; 8932d

Function8932d: ; 8932d
	ld hl, 0
	add hl, bc

Function89331: ; 89331
; Scans up to 5 characters starting at hl, looking for a nonspace character up to the next terminator.  Sets carry if it does not find a nonspace character.  Returns the location of the following character in hl.
	push bc
	ld c, 5
.loop
	ld a, [hli]
	cp "@"
	jr z, .terminator
	cp " "
	jr nz, .nonspace
	dec c
	jr nz, .loop

.terminator
	scf
	jr .done

.nonspace
	and a

.done
	pop bc
	ret
; 89346


Function89346: ; 89346 (22:5346)
	ld h, b
	ld l, c
	jr _incave

Function8934a: ; 8934a
	ld hl, 6
	add hl, bc
_incave:
; Scans up to 5 characters starting at hl, looking for a nonspace character up to the next terminator.  Sets carry if it does not find a nonspace character.  Returns the location of the following character in hl.
	push bc
	ld c, 5
.loop
	ld a, [hli]
	cp "@"
	jr z, .terminator
	cp " "
	jr nz, .nonspace
	dec c
	jr nz, .loop

.terminator
	scf
	jr .done

.nonspace
	and a

.done
	pop bc
	ret
; 89363

Function89363: ; 89363
; Scans six byte pairs starting at bc to find $ff.  Sets carry if it does not find a $ff.  Returns the location of the byte after the first $ff found in hl.
	ld h, b
	ld l, c
	jr ._incave

	ld hl, 25
	add hl, bc

._incave
	push de
	ld e, 6
.loop
	ld a, [hli]
	cp -1
	jr nz, .ok
	ld a, [hli]
	cp -1
	jr nz, .ok
	dec e
	jr nz, .loop
	scf
	jr .done

.ok
	and a

.done
	pop de
	ret
; 89381

Function89381: ; 89381
	push bc
	push de
	call Function89b45
	jr c, .ok
	push hl
	ld a, -1
	ld bc, 8
	call ByteFill
	pop hl

.ok
	pop de
	ld c, 8
	call Function89193
	pop bc
	ret
; 8939a

Function8939a: ; 8939a
	push bc
	ld hl, 0
	add hl, bc
	ld de, wd002
	ld c, 6
	call Function89193
	pop bc
	ld hl, 17
	add hl, bc
	ld de, wd008
	call Function89381
	ret
; 893b3


Function893b3: ; 893b3 (22:53b3)
	call DisableLCD
	call ClearSprites
	call LoadStandardFont
	call LoadFontsExtra
	call Function893ef
	call Function8942b
	call Function89455
	call EnableLCD
	ret

Function893cc: ; 893cc
	call DisableLCD
	call ClearSprites
	call LoadStandardFont
	call LoadFontsExtra
	call Function893ef
	call Function89464
	call EnableLCD
	ret
; 893e2


Function893e2: ; 893e2 (22:53e2)
	call Function89b1e
	call Function893b3
	call Function8a5b6
	call Function8949c
	ret

Function893ef: ; 893ef
	ld de, VTiles0
	ld hl, GFX_8940b
	ld bc, $20
	ld a, BANK(GFX_8940b)
	call FarCopyBytes
	ret
; 893fe

GFX_8940b: ; 8940b
INCBIN "gfx/unknown/08940b.2bpp"
; 8942b

Function8942b: ; 8942b (22:542b)
	ld de, VTiles0 tile $02
	ld hl, MobileAdapterGFX + $7d0
	ld bc, $80
	ld a, BANK(MobileAdapterGFX)
	call FarCopyBytes
	ld de, VTiles0 tile $0a
	ld hl, MobileAdapterGFX + $c60
	ld bc, $40
	ld a, BANK(MobileAdapterGFX)
	call FarCopyBytes
	ret

Function89448: ; 89448 (22:5448)
; Clears the Sprites array
	push af
	ld hl, Sprites
	ld d, $10 * 6
	xor a
.loop
	ld [hli], a
	dec d
	jr nz, .loop
	pop af
	ret

Function89455: ; 89455 (22:5455)
	ld hl, MobileAdapterGFX + $7d0
	ld de, VTiles2 tile $0c
	ld bc, $490
	ld a, BANK(MobileAdapterGFX)
	call FarCopyBytes
	ret

Function89464: ; 89464
	ld hl, MobileAdapterGFX
	ld de, VTiles2
	ld bc, $200
	ld a, BANK(MobileAdapterGFX)
	call FarCopyBytes
	ld hl, MobileAdapterGFX + $660
	ld de, VTiles2 tile $20
	ld bc, $170
	ld a, BANK(MobileAdapterGFX)
	call FarCopyBytes
	ret
; 89481

Function89481: ; 89481
	ld d, 2
	call Function8934a
	ret c
	ld d, 0
	ld hl, 16
	add hl, bc
	bit 0, [hl]
	ret z
	inc d
	ret
; 89492


Function89492: ; 89492 (22:5492)
	ld d, 0
	ld a, [PlayerGender]
	bit 0, a
	ret z
	inc d
	ret

Function8949c: ; 8949c
	ld a, [rSVBK]
	push af
	ld a, 5
	ld [rSVBK], a
	ld hl, Palette_894b3
	ld de, UnknBGPals + 8 * 7
	ld bc, 8
	call CopyBytes
	pop af
	ld [rSVBK], a
	ret
; 894b3

Palette_894b3: ; 894b3
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 00, 00, 00
; 894bb

Function894bb: ; 894bb
	call Function894dc
	push bc
	call Function8956f
	call Function8949c
	call Function8a60d
	pop bc
	ret
; 894ca


Function894ca: ; 894ca (22:54ca)
	push bc
	call Function894dc
	call Function895c7
	call Function8949c
	call Function8a60d
	call SetPalettes
	pop bc
	ret

Function894dc: ; 894dc
	push bc
	ld a, [rSVBK]
	push af
	ld a, 5
	ld [rSVBK], a

	ld c, d
	ld b, 0
	ld hl, .PalettePointers
rept 2
	add hl, bc
endr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, UnknBGPals
	ld bc, 3 palettes
	call CopyBytes
	ld hl, .Pals345
	ld de, UnknBGPals + 3 palettes
	ld bc, 3 palettes
	call CopyBytes

	pop af
	ld [rSVBK], a
	pop bc
	ret
; 89509

.PalettePointers: ; 89509
	dw .Pals012a
	dw .Pals012b
	dw .Pals012c
; 8950f

.Pals012a: ; 8950f
	RGB 31, 31, 31
	RGB 10, 17, 13
	RGB 10, 08, 22
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 16, 20, 31
	RGB 10, 08, 22
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 16, 20, 31
	RGB 10, 17, 13
	RGB 00, 00, 00

.Pals012b: ; 89527
	RGB 31, 31, 31
	RGB 30, 22, 11
	RGB 31, 08, 15
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 16, 20, 31
	RGB 31, 08, 15
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 16, 20, 31
	RGB 30, 22, 11
	RGB 00, 00, 00

.Pals012c: ; 8953f
	RGB 31, 31, 31
	RGB 15, 20, 26
	RGB 25, 07, 20
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 16, 20, 31
	RGB 25, 07, 20
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 16, 20, 31
	RGB 15, 20, 26
	RGB 00, 00, 00

.Pals345: ; 89557
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 13, 00
	RGB 14, 08, 00

	RGB 31, 31, 31
	RGB 16, 16, 31
	RGB 00, 00, 31
	RGB 00, 00, 00

	RGB 19, 31, 11
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00
; 8956f

Function8956f: ; 8956f
	push bc
	ld hl, 16
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $000c
	add hl, bc
	ld b, h
	ld c, l
	callba Function4e929
	ld a, c
	ld [TrainerClass], a
	ld a, [rSVBK]
	push af
	ld a, 5
	ld [rSVBK], a
	ld hl, wd030
	ld a, -1
	ld [hli], a
	ld a, " "
	ld [hl], a
	pop af
	ld [rSVBK], a
	ld a, [TrainerClass]
	ld h, 0
	ld l, a
rept 2
	add hl, hl
endr
	ld de, TrainerPalettes
	add hl, de
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld de, wd032
	ld c, 4
.loop
	ld a, BANK(TrainerPalettes)
	call GetFarByte
	ld [de], a
	inc de
	inc hl
	dec c
	jr nz, .loop
	ld hl, wd036
	xor a
	ld [hli], a
	ld [hl], a
	pop af
	ld [rSVBK], a
	pop bc
	ret
; 895c7


Function895c7: ; 895c7 (22:55c7)
	ld a, [rSVBK]
	push af
	ld a, 5
	ld [rSVBK], a
	ld hl, Palette_895de
	ld de, wd030
	ld bc, 8
	call CopyBytes
	pop af
	ld [rSVBK], a
	ret
; 895de (22:55de)

Palette_895de: ; 895de
	RGB 31, 31, 31
	RGB 07, 07, 06
	RGB 07, 07, 06
	RGB 00, 00, 00
; 895e6

Function895f2: ; 895f2
	push bc
	xor a
	hlcoord 0, 0, AttrMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	call ByteFill
	call Function89605
	call Function89655
	pop bc
	ret
; 89605

Function89605: ; 89605
	hlcoord 19, 2, AttrMap
	ld a, 1
	ld de, SCREEN_WIDTH
	ld c, 14
.loop
	ld [hl], a
	dec c
	jr z, .done
	add hl, de
	inc a
	ld [hl], a
	dec a
	add hl, de
	dec c
	jr nz, .loop

.done
	hlcoord 0, 16, AttrMap
	ld c, 10
	ld a, 2
.loop2
	ld [hli], a
	dec a
	ld [hli], a
	inc a
	dec c
	jr nz, .loop2
	hlcoord 1, 11, AttrMap
	ld a, 4
	ld bc, 4
	call ByteFill
	ld a, 5
	ld bc, 14
	call ByteFill
	ret
; 8963d

Function8963d: ; 8963d
	hlcoord 12, 3, AttrMap
	ld a, 6
	ld de, SCREEN_WIDTH
	lb bc, 7, 7
.loop
	push hl
	ld c, 7
.next
	ld [hli], a
	dec c
	jr nz, .next
	pop hl
	add hl, de
	dec b
	jr nz, .loop
	ret
; 89655

Function89655: ; 89655
	hlcoord 1, 12, AttrMap
	ld de, SCREEN_WIDTH
	ld a, 5
	ld b, 4
.loop
	ld c, 18
	push hl
.next
	ld [hli], a
	dec c
	jr nz, .next
	pop hl
	add hl, de
	dec b
	jr nz, .loop
	ret
; 8966c

Function8966c: ; 8966c
	push bc
	call Function89688
	hlcoord 4, 0
	ld c, 8
	call Function896f5
	pop bc
	ret
; 8967a


Function8967a: ; 8967a (22:567a)
	push bc
	call Function89688
	hlcoord 2, 0
	ld c, 12
	call Function896f5
	pop bc
	ret

Function89688: ; 89688
	hlcoord 0, 0
	ld a, 1
	ld e, SCREEN_WIDTH
	call Function896e1
	ld a, 2
	ld e, SCREEN_WIDTH
	call Function896eb
	ld a, 3
	ld [hli], a
	ld a, 4
	ld e, SCREEN_HEIGHT
	call Function896e1
	ld a, 6
	ld [hli], a
	push bc
	ld c, 13
.loop
	call Function896cb
	dec c
	jr z, .done
	call Function896d6
	dec c
	jr nz, .loop

.done
	pop bc
	ld a, 25
	ld [hli], a
	ld a, 26
	ld e, SCREEN_HEIGHT
	call Function896e1
	ld a, 28
	ld [hli], a
	ld a, 2
	ld e, SCREEN_WIDTH
	call Function896eb
	ret
; 896cb

Function896cb: ; 896cb
	ld de, SCREEN_WIDTH - 1
	ld a, 7
	ld [hl], a
	add hl, de
	ld a, 9
	ld [hli], a
	ret
; 896d6

Function896d6: ; 896d6
	ld de, SCREEN_WIDTH - 1
	ld a, 10
	ld [hl], a
	add hl, de
	ld a, 11
	ld [hli], a
	ret
; 896e1

Function896e1: ; 896e1
.loop
	ld [hli], a
	inc a
	dec e
	ret z
	ld [hli], a
	dec a
	dec e
	jr nz, .loop
	ret
; 896eb

Function896eb: ; 896eb
.loop
	ld [hli], a
	dec a
	dec e
	ret z
	ld [hli], a
	inc a
	dec e
	jr nz, .loop
	ret
; 896f5

Function896f5: ; 896f5
	call Function8971f
	call Function89736
rept 2
	inc hl
endr
	ld b, 2
	ld a, " " ; blank tile
	ld de, 20 ; screen width
.loop
	push bc
	push hl
.innerLoop
	ld [hli], a
	dec c
	jr nz, .innerLoop
	pop hl
	pop bc
	add hl, de
	dec b
	jr nz, .loop

	dec hl
rept 2
	inc c
endr
.asm_89713
	ld a, $36
	ld [hli], a
	dec c
	ret z
	ld a, $18
	ld [hli], a
	dec c
	jr nz, .asm_89713 ; 0x8971c $f5
	ret
; 0x8971f

Function8971f: ; 8971f
	ld a, $2c
	ld [hli], a
	ld a, $2d
	ld [hld], a
	push hl
	ld de, SCREEN_WIDTH
	add hl, de
	ld a, $31
	ld [hli], a
	ld a, $32
	ld [hld], a
	add hl, de
	ld a, $35
	ld [hl], a
	pop hl
	ret
; 89736

Function89736: ; 89736
	push hl
rept 2
	inc hl
endr
	ld e, c
	ld d, $0
	add hl, de
	ld a, $2f
	ld [hli], a
	ld a, $30
	ld [hld], a
	ld de, SCREEN_WIDTH
	add hl, de
	ld a, $33
	ld [hli], a
	ld a, $34
	ld [hl], a
	add hl, de
	ld a, $1f
	ld [hl], a
	pop hl
	ret
; 89753

Function89753: ; 89753
	ld a, $c
	ld [hl], a
	xor a
	call Function89215
	ret
; 8975b

Function8975b: ; 8975b
	ld a, $1d
	ld [hli], a
	inc a
	ld [hli], a
	ld a, $d
	ld [hl], a
rept 2
	dec hl
endr
	ld a, $4
	ld e, $3
.asm_89769
	call Function89215
	inc hl
	dec e
	jr nz, .asm_89769
	ret
; 89771

Function89771: ; 89771
	ld a, $12
	ld [hl], a
	ld a, $3
	call Function89215
	ret
; 8977a

Function8977a: ; 8977a
	ld e, $4
	ld d, $13
.asm_8977e
	ld a, d
	ld [hl], a
	ld a, $4
	call Function89215
	inc hl
	inc d
	dec e
	jr nz, .asm_8977e
	ld e, $e
.asm_8978c
	ld a, d
	ld [hl], a
	xor a
	call Function89215
	inc hl
	dec e
	jr nz, .asm_8978c
	ret
; 89797

Function89797: ; 89797
	push bc
	ld a, $e
	ld [hl], a
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld a, $11
	ld [hli], a
	ld a, $10
	ld c, $8
.asm_897a6
	ld [hli], a
	dec c
	jr nz, .asm_897a6
	ld a, $f
	ld [hl], a
	pop bc
	ret
; 897af

Function897af: ; 897af
	push bc
	ld hl, $0010
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $000c
	add hl, bc
	ld b, h
	ld c, l
	callba Function4e929
	ld a, c
	ld [TrainerClass], a
	xor a
	ld [CurPartySpecies], a
	ld de, VTiles2 tile $37
	callba GetTrainerPic
	pop bc
	ret
; 897d5

Function897d5: ; 897d5
	push bc
	call Function8934a
	jr nc, .asm_897f3
	hlcoord 12, 3, AttrMap
	xor a
	ld de, SCREEN_WIDTH
	lb bc, 7, 7
.asm_897e5
	push hl
	ld c, $7
.asm_897e8
	ld [hli], a
	dec c
	jr nz, .asm_897e8
	pop hl
	add hl, de
	dec b
	jr nz, .asm_897e5
	pop bc
	ret

.asm_897f3
	ld a, $37
	ld [hGraphicStartTile], a
	hlcoord 12, 3
	lb bc, 7, 7
	predef PlaceGraphic
	call Function8963d
	pop bc
	ret
; 89807


Function89807: ; 89807 (22:5807)
	ld hl, MobileAdapterGFX + $200
	ld a, [PlayerGender]
	bit 0, a
	jr z, .asm_89814
	ld hl, MobileAdapterGFX + $200 + $230
.asm_89814
	call DisableLCD
	ld de, VTiles2 tile $37
	ld bc, $230
	ld a, BANK(MobileAdapterGFX)
	call FarCopyBytes
	call EnableLCD
	call DelayFrame
	ret

Function89829: ; 89829 (22:5829)
	push bc
	ld bc, $705
	ld de, $14
	ld a, $37
.asm_89832
	push bc
	push hl
.asm_89834
	ld [hli], a
	inc a
	dec c
	jr nz, .asm_89834
	pop hl
	add hl, de
	pop bc
	dec b
	jr nz, .asm_89832
	call Function8963d
	pop bc
	ret

Function89844: ; 89844
	call Function89481
	call Function894bb
	call Function897af
	push bc
	call WaitBGMap2
	call SetPalettes
	pop bc
	ret
; 89856

Function89856: ; 89856
	push bc
	call Function891b8
	pop bc
	call Function895f2
	call Function8966c
	call Function899d3
	call Function898aa
	call Function898be
	call Function898dc
	call Function898f3
	push bc
	ld bc, wd008
	hlcoord 2, 10
	call Function89975
	pop bc
	call Function897d5
	ret
; 8987f


Function8987f: ; 8987f (22:587f)
	call Function891b8
	call Function895f2
	call Function8967a
	call Function899d3
	hlcoord 5, 1
	call Function8999c
	hlcoord 13, 3
	call Function89829
	call Function899b2
	hlcoord 5, 5
	call Function899c9
	ld bc, wd008
	hlcoord 2, 10
	call Function89975
	ret

Function898aa: ; 898aa
	ld a, [MenuSelection]
	and a
	ret z
	push bc
	hlcoord 6, 1
	ld de, MenuSelection
	lb bc, PRINTNUM_LEADINGZEROS | 1, 2
	call PrintNum
	pop bc
	ret
; 898be

Function898be: ; 898be
	push bc
	ld de, wd002
	ld hl, wd002
	call Function89331
	jr nc, .asm_898cd
	ld de, String_89116

.asm_898cd
	hlcoord 9, 1
	ld a, [MenuSelection]
	and a
	jr nz, .asm_898d7
	dec hl

.asm_898d7
	call PlaceString
	pop bc
	ret
; 898dc

Function898dc: ; 898dc
	ld hl, $0006
	add hl, bc
	push bc
	ld d, h
	ld e, l
	call Function8934a
	jr nc, .asm_898eb
	ld de, String_89116

.asm_898eb
	hlcoord 6, 4
	call PlaceString
	pop bc
	ret
; 898f3

Function898f3: ; 898f3
	push bc
	ld hl, $000c
	add hl, bc
	ld d, h
	ld e, l
	call Function8934a
	jr c, .asm_8990a
	hlcoord 5, 5
	lb bc, PRINTNUM_LEADINGZEROS | 2, 5
	call PrintNum
	jr .asm_89913

.asm_8990a
	hlcoord 5, 5
	ld de, String_89116
	call PlaceString

.asm_89913
	pop bc
	ret
; 89915

Function89915: ; 89915
	push bc
	push hl
	ld de, Unknown_89942
	ld c, $8
.asm_8991c
	ld a, [de]
	ld [hl], a
	ld a, $4
	call Function89215
	inc hl
	inc de
	dec c
	jr nz, .asm_8991c
	pop hl
	ld b, $4
	ld c, $2b
	ld a, $8
	ld de, Unknown_8994a
.asm_89932
	push af
	ld a, [de]
	cp [hl]
	jr nz, .asm_8993b
	call Function8994e
	inc de

.asm_8993b
	inc hl
	pop af
	dec a
	jr nz, .asm_89932
	pop bc
	ret
; 89942

Unknown_89942: ; 89942
	db $24, $25, $26, " ", $27, $28, $29, $2a
Unknown_8994a: ; 8994a
	db $24, $27, $29, $ff
; 8994e

Function8994e: ; 8994e
	push hl
	push de
	ld de, SCREEN_WIDTH
	ld a, l
	sub e
	ld l, a
	ld a, h
	sbc d
	ld h, a
	ld a, c
	ld [hl], a
	ld a, b
	call Function89215
	pop de
	pop hl
	ret
; 89962

Function89962: ; 89962
	push bc
	ld c, $4
	ld b, $20
.asm_89967
	ld a, b
	ld [hl], a
	ld a, $4
	call Function89215
	inc hl
	inc b
	dec c
	jr nz, .asm_89967
	pop bc
	ret
; 89975

Function89975: ; 89975
	push bc
	ld e, $8
.asm_89978
	ld a, [bc]
	ld d, a
	call Function8998b
	swap d
	inc hl
	ld a, d
	call Function8998b
	inc bc
	inc hl
	dec e
	jr nz, .asm_89978
	pop bc
	ret
; 8998b

Function8998b: ; 8998b
	push bc
	and $f
	cp $a
	jr nc, .asm_89997
	ld c, $f6
	add c
	jr .asm_89999

.asm_89997
	ld a, $7f

.asm_89999
	ld [hl], a
	pop bc
	ret
; 8999c


Function8999c: ; 8999c (22:599c)
	ld de, PlayerName
	call PlaceString
	inc bc
	ld h, b
	ld l, c
	ld de, String_899ac
	call PlaceString
	ret
; 899ac (22:59ac)

String_899ac: ; 899ac
	db "の めいし@"
; 899b2

Function899b2: ; 899b2 (22:59b2)
	ld bc, PlayerName
	call Function89346
	jr c, .asm_899bf
	ld de, PlayerName
	jr .asm_899c2
.asm_899bf
	ld de, String_89116
.asm_899c2
	hlcoord 6, 4
	call PlaceString
	ret

Function899c9: ; 899c9 (22:59c9)
	ld de, PlayerID
	lb bc, PRINTNUM_LEADINGZEROS | 2, 5
	call PrintNum
	ret

Function899d3: ; 899d3
	hlcoord 1, 4
	call Function89753
	hlcoord 2, 5
	call Function8975b
	hlcoord 1, 9
	call Function89771
	hlcoord 1, 11
	call Function8977a
	hlcoord 1, 5
	call Function89797
	hlcoord 2, 4
	call Function89962
	hlcoord 2, 9
	call Function89915
	ret
; 899fe

Function899fe: ; 899fe
	push bc
	push hl
	ld hl, $0019
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	call Function89a0c
	pop bc
	ret
; 89a0c

Function89a0c: ; 89a0c
	push hl
	call Function89363
	pop hl
	jr c, .asm_89a1c
	ld d, h
	ld e, l
	callba Function11c08f
	ret

.asm_89a1c
	ld de, String_89153
	call PlaceString
	ret
; 89a23

Function89a57: ; 89a57
	call Function354b
	bit 6, c
	jr nz, .asm_89a78
	bit 7, c
	jr nz, .asm_89a81
	bit 0, c
	jr nz, .asm_89a70
	bit 1, c
	jr nz, .asm_89a70
	bit 3, c
	jr nz, .asm_89a74
	scf
	ret

.asm_89a70
	ld a, $1
	and a
	ret

.asm_89a74
	ld a, $2
	and a
	ret

.asm_89a78
	call Function89a9b
	call nc, Function89a8a
	ld a, $0
	ret

.asm_89a81
	call Function89a93
	call nc, Function89a8a
	ld a, $0
	ret
; 89a8a

Function89a8a: ; 89a8a
	push af
	ld de, SFX_SWITCH_POCKETS
	call PlaySFX
	pop af
	ret
; 89a93

Function89a93: ; 89a93
	ld d, $28
	ld e, $1
	call Function89aa3
	ret
; 89a9b

Function89a9b: ; 89a9b
	ld d, $1
	ld e, $ff
	call Function89aa3
	ret
; 89aa3

Function89aa3: ; 89aa3
	ld a, [MenuSelection]
	ld c, a
	push bc
.asm_89aa8
	ld a, [MenuSelection]
	cp d
	jr z, .asm_89ac0
	add e
	jr nz, .asm_89ab2
	inc a

.asm_89ab2
	ld [MenuSelection], a
	call Function89ac7
	jr nc, .asm_89aa8
	call Function89ae6
	pop bc
	and a
	ret

.asm_89ac0
	pop bc
	ld a, c
	ld [MenuSelection], a
	scf
	ret
; 89ac7

Function89ac7: ; 89ac7
	call OpenSRAMBank4
	call Function8931b
	call Function89ad4
	call CloseSRAM
	ret
; 89ad4

Function89ad4: ; 89ad4
	push de
	call Function8932d
	jr c, .asm_89ae3
	ld hl, $0011
	add hl, bc
	call Function89b45
	jr c, .asm_89ae4

.asm_89ae3
	and a

.asm_89ae4
	pop de
	ret
; 89ae6

Function89ae6: ; 89ae6
	ld hl, wd031
	xor a
	ld [hl], a
	ld a, [MenuSelection]
.asm_89aee
	cp $6
	jr c, .asm_89afc
	sub $5
	ld c, a
	ld a, [hl]
	add $5
	ld [hl], a
	ld a, c
	jr .asm_89aee

.asm_89afc
	ld [wd030], a
	ret
; 89b00


Function89b00: ; 89b00 (22:5b00)
	callba MG_Mobile_Layout_LoadPals
	ret
; 89b07 (22:5b07)

Function89b1e: ; 89b1e (22:5b1e)
	call Function89b00
	ret

Function89b3b: ; 89b3b (22:5b3b)
	call Function8923c
	callba Function48cda
	ret

Function89b45: ; 89b45
	push hl
	push bc
	ld c, $10
	ld e, $0
.asm_89b4b
	ld a, [hli]
	ld b, a
	and $f
	cp $a
	jr c, .asm_89b5a
	ld a, c
	cp $b
	jr nc, .asm_89b74
	jr .asm_89b71

.asm_89b5a
	dec c
	swap b
	inc e
	ld a, b
	and $f
	cp $a
	jr c, .asm_89b6c
	ld a, c
	cp $b
	jr nc, .asm_89b74
	jr .asm_89b71

.asm_89b6c
	inc e
	dec c
	jr nz, .asm_89b4b
	dec e

.asm_89b71
	scf
	jr .asm_89b75

.asm_89b74
	and a

.asm_89b75
	pop bc
	pop hl
	ret
; 89b78


Function89b78: ; 89b78 (22:5b78)
	push bc
	ld a, [wd010]
	cp $10
	jr c, .asm_89b8c
	ld a, e
	and a
	jr z, .asm_89b89
	ld c, e
.asm_89b85
	inc hl
	dec c
	jr nz, .asm_89b85
.asm_89b89
	ld a, $7f
	ld [hl], a
.asm_89b8c
	ld a, [wd010]
	inc a
	and $1f
	ld [wd010], a
	pop bc
	ret

Function89c34: ; 89c34 (22:5c34)
	push bc
	ld a, [wd012]
	ld c, a
	inc a
	and $f
	ld [wd012], a
	ld a, c
	cp $8
	pop bc
	ret

Function89c44: ; 89c44 (22:5c44)
	call Function89c34
	jr c, .asm_89c4f
	push de
	call Function89448
	pop de
	ret
.asm_89c4f
	ld hl, Sprites
	push de
	ld a, b
	ld [hli], a
	ld d, $8
	ld a, e
	and a
	ld a, c
	jr z, .asm_89c60
.asm_89c5c
	add d
	dec e
	jr nz, .asm_89c5c
.asm_89c60
	pop de
	ld [hli], a
	ld a, d
	ld [hli], a
	xor a
	ld [hli], a
	ret

Function89d0d: ; 89d0d (22:5d0d)
	call Function8923c
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld c, $8
	ld de, UnknBGPals
.asm_89d1c
	push bc
	ld hl, Palette_89d4e
	ld bc, $8
	call CopyBytes
	pop bc
	dec c
	jr nz, .asm_89d1c
	ld hl, Palette_89d56
	ld de, wd010
	ld bc, $8
	call CopyBytes
	pop af
	ld [rSVBK], a
	call SetPalettes
	call Function89240
	ld c, $18
	call DelayFrames
	call RestartMapMusic
	ret
; 89d4e (22:5d4e)

Palette_89d4e: ; 89d4e
	RGB 31, 31, 31
	RGB 19, 19, 19
	RGB 15, 15, 15
	RGB 00, 00, 00
; 89d56

Palette_89d56: ; 89d56
	RGB 31, 31, 31
	RGB 19, 19, 19
	RGB 19, 19, 19
	RGB 00, 00, 00
; 89d5e

asm_89e2e: ; 89e2e (22:5e2e)
	ld a, [wd02d]
	ld hl, Jumptable_89e3c
	rst JumpTable
	ret

Function89e36: ; 89e36 (22:5e36)
	ld hl, wd02d
	inc [hl]
	jr asm_89e2e

Jumptable_89e3c: ; 89e3c (22:5e3c)
	dw Function89e6f
	dw Function89fed
	dw Function89ff6
	dw Function8a03d
	dw Function89eb9
	dw Function89efd
	dw Function89fce
	dw Function8a04c
	dw Function8a055
	dw Function8a0e6
	dw Function8a0ec
	dw Function8a0f5
	dw Function89e58
	dw Function89e68


Function89e58: ; 89e58 (22:5e58)
	ld a, $1
	call Function8a2fe
	call Function891fe
	call Function893e2
	call Function89168
	and a
	ret

Function89e68: ; 89e68 (22:5e68)
	call Function891fe
	ld a, $1
	scf
	ret

Function89e6f: ; 89e6f (22:5e6f)
	call Function891de
	call Function89245
	call Function89ee1
	call Function89e9a
	hlcoord 7, 4
	call Function8a58d
	ld a, $5
	hlcoord 7, 4, AttrMap
	call Function8a5a3
	ld a, $6
	hlcoord 10, 4, AttrMap
	call Function8a5a3
	call Function891ab
	call SetPalettes
	jp Function89e36

Function89e9a: ; 89e9a (22:5e9a)
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, Palette_89eb1
	ld de, UnknBGPals + 5 palettes
	ld bc, 1 palettes
	call CopyBytes
	pop af
	ld [rSVBK], a
	ret
; 89eb1 (22:5eb1)

Palette_89eb1: ; 89eb1
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 27, 19, 00
	RGB 00, 00, 00
; 89eb9

Function89eb9: ; 89eb9 (22:5eb9)
	call Function891fe
	call Function89ee1
	call Function89e9a
	hlcoord 7, 4
	call Function8a58d
	ld a, $5
	hlcoord 7, 4, AttrMap
	call Function8a5a3
	ld a, $6
	hlcoord 10, 4, AttrMap
	call Function8a5a3
	call Function891ab
	call SetPalettes
	jp Function89e36

Function89ee1: ; 89ee1 (22:5ee1)
	call ClearBGPalettes
	call Function893e2
	call Function8923c
	callba MG_Mobile_Layout_CreatePalBoxes
	hlcoord 1, 0
	call Function8a53d
	ret

Function89efd: ; 89efd (22:5efd)
	ld hl, wd012
	ld a, $ff
	ld [hli], a
	xor a
rept 4
	ld [hli], a
endr
	ld [hl], a
.asm_89f09
	ld hl, wd012
	inc [hl]
	ld a, [hli]
	and $3
	jr nz, .asm_89f2e
	ld a, [hl]
	cp $4
	jr nc, .asm_89f2e
	ld b, $32
	inc [hl]
	ld a, [hl]
	dec a
	jr z, .asm_89f26
	ld c, a
.asm_89f1f
	ld a, $b
	add b
	ld b, a
	dec c
	jr nz, .asm_89f1f
.asm_89f26
	ld c, $e8
	ld a, [wd013]
	call Function89fa5
.asm_89f2e
	ld a, [wd013]
	and a
	jr z, .asm_89f58
.asm_89f34
	call Function89f6a
	ld e, a
	ld a, c
	cp $a8
	jr nc, .asm_89f4d
	cp $46
	jr c, .asm_89f4d
	ld d, $0
	dec e
	ld hl, wd014
	add hl, de
	set 0, [hl]
	inc e
	jr .asm_89f51
.asm_89f4d
	ld a, $2
	add c
	ld c, a
.asm_89f51
	ld a, e
	call Function89f77
	dec a
	jr nz, .asm_89f34
.asm_89f58
	call DelayFrame
	ld hl, wd014
	ld c, $4
.asm_89f60
	ld a, [hli]
	and a
	jr z, .asm_89f09
	dec c
	jr nz, .asm_89f60
	jp Function89e36

Function89f6a: ; 89f6a (22:5f6a)
	push af
	ld de, $10
	call Function89f9a
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
	pop af
	ret

Function89f77: ; 89f77 (22:5f77)
	push af
	ld de, $10
	call Function89f9a
	ld d, $2
.asm_89f80
	push bc
	ld e, $2
.asm_89f83
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
rept 2
	inc hl
endr
	ld a, $8
	add c
	ld c, a
	dec e
	jr nz, .asm_89f83
	pop bc
	ld a, $8
	add b
	ld b, a
	dec d
	jr nz, .asm_89f80
	pop af
	ret

Function89f9a: ; 89f9a (22:5f9a)
	dec a
	ld hl, Sprites
	and a
	ret z
.asm_89fa0
	add hl, de
	dec a
	jr nz, .asm_89fa0
	ret

Function89fa5: ; 89fa5 (22:5fa5)
	ld de, $10
	call Function89f9a
	ld e, $2
	ld d, $a
.asm_89faf
	push bc
	ld a, $2
.asm_89fb2
	push af
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, d
	inc d
	ld [hli], a
	ld a, $1
	ld [hli], a
	ld a, $8
	add c
	ld c, a
	pop af
	dec a
	jr nz, .asm_89fb2
	pop bc
	ld a, $8
	add b
	ld b, a
	dec e
	jr nz, .asm_89faf
	ret

Function89fce: ; 89fce (22:5fce)
	call Function8a5b6
	ld a, $5
	hlcoord 7, 4, AttrMap
	call Function8a5a3
	ld a, $6
	hlcoord 10, 4, AttrMap
	call Function8a5a3
	call Function89448
	call SetPalettes
	call Function891ab
	jp Function89e36

Function89fed: ; 89fed (22:5fed)
	ld hl, UnknownText_0x8a102
	call PrintText
	jp Function89e36

Function89ff6: ; 89ff6 (22:5ff6)
	call Function891fe
	call ClearBGPalettes
	call Function893cc
	call Function89807
	call Function89492
	call Function894ca
	call OpenSRAMBank4
	ld hl, $a603
	ld a, -1
	ld bc, 8
	call ByteFill
	ld hl, $a603
	ld de, wd008
	call Function89381
	call CloseSRAM
	call Function8987f
	call OpenSRAMBank4
	hlcoord 1, 13
	ld bc, $a007
	call Function89a0c
	call CloseSRAM
	call Function891ab
	call Function89235
	jp Function89e36

Function8a03d: ; 8a03d (22:603d)
	ld hl, UnknownText_0x8a107
	call Function89209
	call PrintText
	call Function8920f
	jp Function89e36

Function8a04c: ; 8a04c (22:604c)
	ld hl, UnknownText_0x8a10c
	call PrintText
	jp Function89e36

Function8a055: ; 8a055 (22:6055)
	ld c, $7
	ld b, $4
.asm_8a059
	call Function8a0a1
	inc c
	call Function8a0c9
	push bc
	call Function8a58d
	pop bc
	call Function8a0de
	push bc
	push hl
	ld a, $5
	call Function8a5a3
	pop hl
rept 3
	inc hl
endr
	ld a, $6
	call Function8a5a3
	call CGBOnly_LoadEDTile
	pop bc
	ld a, c
	cp $b
	jr nz, .asm_8a059
	call Function8a0a1
	hlcoord 12, 4
	call Function8a58d
	ld a, $5
	hlcoord 12, 4, AttrMap
	call Function8a5a3
	pop hl
	ld a, $6
	hlcoord 15, 4, AttrMap
	call Function8a5a3
	call CGBOnly_LoadEDTile
	jp Function89e36

Function8a0a1: ; 8a0a1 (22:60a1)
	call Function8923c
	push bc
	call Function8a0c9
	ld e, $6
.asm_8a0aa
	push hl
	ld bc, $6
	add hl, bc
	ld d, [hl]
	call Function8a0c1
	pop hl
	ld [hl], d
	call Function89215
	ld bc, $14
	add hl, bc
	dec e
	jr nz, .asm_8a0aa
	pop bc
	ret

Function8a0c1: ; 8a0c1 (22:60c1)
	push hl
	ld bc, AttrMap - TileMap
	add hl, bc
	ld a, [hl]
	pop hl
	ret

Function8a0c9: ; 8a0c9 (22:60c9)
	push bc
	hlcoord 0, 0
	ld de, $14
	ld a, b
	and a
	jr z, .asm_8a0d8
.asm_8a0d4
	add hl, de
	dec b
	jr nz, .asm_8a0d4
.asm_8a0d8
	ld d, $0
	ld e, c
	add hl, de
	pop bc
	ret

Function8a0de: ; 8a0de (22:60de)
	call Function8a0c9
	ld de, AttrMap - TileMap
	add hl, de
	ret

Function8a0e6: ; 8a0e6 (22:60e6)
	call Function8b539
	jp Function89e36

Function8a0ec: ; 8a0ec (22:60ec)
	ld hl, UnknownText_0x8a111
	call PrintText
	jp Function89e36

Function8a0f5: ; 8a0f5 (22:60f5)
	call Function8b555
	jp nc, Function8a0ff
	ld hl, wd02d
	inc [hl]

Function8a0ff: ; 8a0ff (22:60ff)
	jp Function89e36
; 8a102 (22:6102)

UnknownText_0x8a102: ; 0x8a102
	; The CARD FOLDER stores your and your friends' CARDS. A CARD contains information like the person's name, phone number and profile.
	text_jump UnknownText_0x1c5238
	db "@"
; 0x8a107

UnknownText_0x8a107: ; 0x8a107
	; This is your CARD. Once you've entered your phone number, you can trade CARDS with your friends.
	text_jump UnknownText_0x1c52bc
	db "@"
; 0x8a10c

UnknownText_0x8a10c: ; 0x8a10c
	; If you have your friend's CARD, you can use it to make a call from a mobile phone on the 2nd floor of a #MON CENTER.
	text_jump UnknownText_0x1c531e
	db "@"
; 0x8a111

UnknownText_0x8a111: ; 0x8a111
	; To safely store your collection of CARDS, you must set a PASSCODE for your CARD FOLDER.
	text_jump UnknownText_0x1c5394
	db "@"
; 0x8a116

Function8a262: ; 8a262 (22:6262)
	call ClearBGPalettes
	call Function893e2
	call Function8923c
	callba MG_Mobile_Layout_CreatePalBoxes
	hlcoord 1, 0
	call Function8a53d
	hlcoord 12, 4
	call Function8a58d
	ld a, $5
	hlcoord 12, 4, AttrMap
	call Function8a5a3
	ld a, $6
	hlcoord 15, 4, AttrMap
	call Function8a5a3
	xor a
	ld [wd02e], a
	ld bc, wd013
	call Function8b36c
	call Function8b493
	call Function891ab
	call SetPalettes
	call Function8b5e7
	ret

Function8a2fe: ; 8a2fe (22:62fe)
	call Function8a313
	call Function89305
	ld hl, $a603
	ld bc, $8
	ld a, -1
	call ByteFill
	call CloseSRAM
	ret

Function8a313: ; 8a313 (22:6313)
	ld c, a
	call OpenSRAMBank4
	ld a, c
	ld [$a60b], a
	ret

Function8a400: ; 8a400 (22:6400)
	ld a, [de]
	inc de
	ld [hli], a
	cp $ff
	jr nz, Function8a400
	ret
; 8a408 (22:6408)

Function8a53d: ; 8a53d (22:653d)
	push hl
	ld a, $15
	ld c, $8
	ld de, $14
	call Function8a573
	ld a, $1d
	ld c, $9
	call Function8a57c
	inc a
	ld [hl], a
	call Function8a584
	pop hl
	add hl, de
	ld a, $1f
	ld c, $8
	call Function8a573
	dec hl
	ld a, $51
	ld [hli], a
	ld a, $26
	ld c, $1
	call Function8a57c
	ld a, $52
	ld c, $3
	call Function8a573
	ld a, $27
	ld c, $6

Function8a573: ; 8a573 (22:6573)
	ld [hl], a
	call Function8a584
	inc a
	dec c
	jr nz, Function8a573
	ret

Function8a57c: ; 8a57c (22:657c)
	ld [hl], a
	call Function8a584
	dec c
	jr nz, Function8a57c
	ret

Function8a584: ; 8a584 (22:6584)
	push af
	ld a, $4
	call Function89215
	inc hl
	pop af
	ret

Function8a58d: ; 8a58d (22:658d)
	ld a, $2d
	ld bc, $606
	ld de, $14
.asm_8a595
	push bc
	push hl
.asm_8a597
	ld [hli], a
	inc a
	dec c
	jr nz, .asm_8a597
	pop hl
	add hl, de
	pop bc
	dec b
	jr nz, .asm_8a595
	ret

Function8a5a3: ; 8a5a3 (22:65a3)
	ld bc, $603
	ld de, $14
.asm_8a5a9
	push bc
	push hl
.asm_8a5ab
	ld [hli], a
	dec c
	jr nz, .asm_8a5ab
	pop hl
	add hl, de
	pop bc
	dec b
	jr nz, .asm_8a5a9
	ret

Function8a5b6: ; 8a5b6 (22:65b6)
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, Palette_8a5e5
	ld de, UnknBGPals + 4 palettes
	ld bc, 3 palettes
	call CopyBytes
	ld hl, Palette_8a5fd
	ld de, UnknOBPals
	ld bc, 1 palettes
	call CopyBytes
	ld hl, Palette_8a605
	ld de, UnknOBPals + 1 palettes
	ld bc, 1 palettes
	call CopyBytes
	pop af
	ld [rSVBK], a
	ret
; 8a5e5 (22:65e5)

Palette_8a5e5: ; 8a5e5
	RGB 31, 31, 31
	RGB 27, 19, 00
	RGB 07, 11, 22
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 16, 16, 31
	RGB 27, 19, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 00, 00
	RGB 27, 19, 00
	RGB 00, 00, 00
; 8a5fd

Palette_8a5fd: ; 8a5fd
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 31, 31, 31
; 8a605

Palette_8a605: ; 8a605
	RGB 00, 00, 00
	RGB 14, 18, 31
	RGB 16, 16, 31
	RGB 31, 31, 31
; 8a60d

Function8a60d: ; 8a60d
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, Palette_8a624
	ld de, UnknOBPals
	ld bc, 1 palettes
	call CopyBytes
	pop af
	ld [rSVBK], a
	ret
; 8a624

Palette_8a624: ; 8a624
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 00, 00, 00
; 8a62c

Function8a679: ; 8a679 (22:6679)
	call Function891de
	call ClearBGPalettes
	call Function893cc
	call OpenSRAMBank4
	call Function8931b
	call Function89844
	call CloseSRAM
	call OpenSRAMBank4
	call Function8939a
	call Function89856
	hlcoord 1, 13
	call Function899fe
	call Function891ab
	call CloseSRAM
.asm_8a6a3
	call Function89a57
	jr c, .asm_8a6a3
	and a
	jr z, Function8a679
	ld hl, Jumptable_8a6bc
	dec a
	rst JumpTable
	jr c, Function8a679
	call Function891fe
	call Function8b677
	call Function89448
	ret

Jumptable_8a6bc: ; 8a6bc (22:66bc)
	dw Function8a6c0
	dw Function8a6c5


Function8a6c0: ; 8a6c0 (22:66c0)
	call PlayClickSFX
	and a
	ret

Function8a6c5: ; 8a6c5 (22:66c5)
	call PlayClickSFX
	call Function89d0d
	scf
	ret

Function8ab3b: ; 8ab3b (22:6b3b)
	call Function891fe
	call ClearBGPalettes
	call Function893cc
	call Function89807
	call Function89492
	call Function894ca
	call OpenSRAMBank4
	ld hl, $a603
	ld de, wd008
	call Function89381
	call CloseSRAM
	call Function8987f
	call OpenSRAMBank4
	hlcoord 1, 13
	ld bc, $a007
	call Function89a0c
	call CloseSRAM
	call Function891ab
	call Function8ab77
	jr c, Function8ab3b
	ret

Function8ab77: ; 8ab77 (22:6b77)
	call Function354b
	bit 0, c
	jr nz, .asm_8ab8e
	bit 1, c
	jr nz, .asm_8ab8e
	bit 3, c
	jr z, Function8ab77
	call PlayClickSFX
	call Function89d0d
	scf
	ret
.asm_8ab8e
	call PlayClickSFX
	and a
	ret

Function8aba9: ; 8aba9
	ld a, $2
	call Function8b94a
	ld a, $1
	ld [wd032], a
.asm_8abb3
	call Function891fe
	call Function8b677
.asm_8abb9
	call Function8b7bd
	jr z, .asm_8abdf
	ld a, c
	ld [MenuSelection], a
	call OpenSRAMBank4
	call Function8931b
	ld hl, $0011
	add hl, bc
	call Function89b45
	call CloseSRAM
	jr c, .asm_8abe2
	ld de, SFX_WRONG
	call WaitPlaySFX
	call CloseSRAM
	jr .asm_8abb9

.asm_8abdf
	xor a
	ld c, a
	ret

.asm_8abe2
	call PlayClickSFX
.asm_8abe5
	call Function891de
	call ClearBGPalettes
	call Function893cc
	call OpenSRAMBank4
	call Function8931b
	call Function89844
	call CloseSRAM
	call OpenSRAMBank4
	call Function8939a
	call Function89856
	hlcoord 1, 13
	call Function899fe
	call CloseSRAM
	call Function891ab
.asm_8ac0f
	call Function89a57
	jr c, .asm_8ac0f
	and a
	jr z, .asm_8abe5
	cp $2
	jr z, .asm_8ac0f
	hlcoord 0, 12
	ld b, $4
	ld c, $12
	call TextBox
	hlcoord 1, 14
	ld de, String_8ac3b
	call PlaceString
	ld a, $1
	call Function8925e
	jp c, .asm_8abb3
	ld a, [MenuSelection]
	ld c, a
	ret
; 8ac3b

String_8ac3b: ; 8ac3b
	db   "こ", $25, "ともだち", $1d, "でんわを"
	next "かけますか?@"
; 8ac4e

Function8ac4e: ; 8ac4e
	xor a
	ld [MenuSelection], a
	push de
	call Function891de
	call ClearBGPalettes
	call Function893cc
	pop bc
	call Function89844
	call Function8939a
	call Function89856
	hlcoord 1, 13
	call Function899fe
	call Function891ab
	ret
; 8ac70

Function8ac70: ; 8ac70
	push de
	ld a, $3
	call Function8b94a

Function8ac76: ; 8ac76
	call Function891fe
	call Function8b677

Function8ac7c: ; 8ac7c
	call Function8b7bd
	jr z, .asm_8acf0
	ld a, c
	ld [wd02f], a
	ld [MenuSelection], a
	call OpenSRAMBank4
	call Function8931b
	call Function8932d
	call CloseSRAM
	jr nc, .asm_8acb0
	call OpenSRAMBank4
	ld hl, $0011
	add hl, bc
	call Function89b45
	call CloseSRAM
	jr nc, .asm_8accc
	call OpenSRAMBank4
	call Function892b7
	call CloseSRAM
	jr .asm_8accc

.asm_8acb0
	call Function8ad0b
	jr c, Function8ac76
	and a
	jr nz, .asm_8accc
	call OpenSRAMBank4
	ld h, b
	ld l, c
	ld d, $0
	ld e, $6
	add hl, de
	ld d, h
	ld e, l
	pop hl
	ld c, $1f
	call Function89193
	jr .asm_8ace4

.asm_8accc
	pop hl
	call OpenSRAMBank4
	ld d, b
	ld e, c
	ld c, $6
	call Function89193
	ld a, $6
	add e
	ld e, a
	ld a, $0
	adc d
	ld d, a
	ld c, $1f
	call Function89193

.asm_8ace4
	call CloseSRAM
	call LoadStandardFont
	ld a, [wd02f]
	ld c, a
	and a
	ret

.asm_8acf0
	ld hl, UnknownText_0x8ad06
	call PrintText
	ld a, $2
	call Function89259
	jp c, Function8ac7c
	call LoadStandardFont
	pop de
	ld c, $0
	scf
	ret
; 8ad06

UnknownText_0x8ad06: ; 0x8ad06
	; Finish registering CARDS?
	text_jump UnknownText_0x1c554a
	db "@"
; 0x8ad0b

Function8ad0b: ; 8ad0b
.asm_8ad0b
	ld a, [MenuSelection]
	ld [wd02f], a
	call Function891de
	call ClearBGPalettes
	call Function893cc
	call OpenSRAMBank4
	call Function8931b
	push bc
	call Function89844
	call Function8939a
	call Function89856
	hlcoord 1, 13
	call Function899fe
	call CloseSRAM
	call Function891ab
	pop bc
.asm_8ad37
	push bc
	call Function89a57
	pop bc
	jr c, .asm_8ad37
	and a
	jr z, .asm_8ad0b
	cp $2
	jr z, .asm_8ad37
	call Function8923c
	push bc
	hlcoord 0, 12
	ld b, $4
	ld c, $12
	call TextBox
	ld de, String_8ad89
	hlcoord 1, 14
	call PlaceString
	ld a, $2
	call Function8925e
	jr c, .asm_8ad87
	call Function8923c
	hlcoord 0, 12
	ld b, $4
	ld c, $12
	call TextBox
	ld de, String_8ad9c
	hlcoord 1, 14
	call PlaceString
	ld a, $1
	call Function8925e
	jr c, .asm_8ad84
	ld a, $0
	jr .asm_8ad86

.asm_8ad84
	ld a, $1

.asm_8ad86
	and a

.asm_8ad87
	pop bc
	ret
; 8ad89

String_8ad89: ; 8ad89
	db   "こ", $25, "めいし", $1f, "けして"
	next "いれかえますか?@"
; 8ad9c

String_8ad9c: ; 8ad9c
	db   "おともだち", $25, "なまえを"
	next "のこして おきますか?@"
; 8adb3

Function8adb3: ; 8adb3
	call Function891de
	call Function8a262
	push af
	call Function891de
	pop af
	ret
; 8adbf

Function8adcc: ; 8adcc
	call OpenSRAMBank4
	call Function8b3b0
	call CloseSRAM
	ret nc
	cp $2
	ret z
	scf
	ret
; 8addb

Function8b342:: ; 8b342
	call GetSecondaryMapHeaderPointer
	ld d, h
	ld e, l
	ret
; 8b35d

Function8b36c: ; 8b36c (22:736c)
	push bc
	ld h, b
	ld l, c
	ld bc, $4
	ld a, -1
	call ByteFill
	pop bc
	ret

Function8b379: ; 8b379 (22:7379)
	push bc
	ld a, c
	add e
	ld c, a
	ld a, $0
	adc b
	ld b, a
	ld a, [bc]
	ld d, a
	pop bc
	ret

Function8b385: ; 8b385 (22:7385)
	push bc
	ld a, c
	add e
	ld c, a
	ld a, $0
	adc b
	ld b, a
	ld a, d
	ld [bc], a
	pop bc
	ret

Function8b391: ; 8b391 (22:7391)
	push bc
	ld e, $0
	ld d, $4
.asm_8b396
	ld a, [bc]
	inc bc
	cp $ff
	jr z, .asm_8b3a2
	inc e
	dec d
	jr nz, .asm_8b396
	dec e
	scf
.asm_8b3a2
	pop bc
	ret

Function8b3a4: ; 8b3a4 (22:73a4)
	push de
	push bc
	ld d, b
	ld e, c
	ld c, $4
	call Function89185
	pop bc
	pop de
	ret

Function8b3b0: ; 8b3b0 (22:73b0)
	ld bc, $a037
	ld a, [$a60b]
	and a
	jr z, .asm_8b3c2
	cp $3
	jr nc, .asm_8b3c2
	call Function8b391
	jr c, .asm_8b3c9
.asm_8b3c2
	call Function8b36c
	xor a
	ld [$a60b], a
.asm_8b3c9
	ld a, [$a60b]
	ret

Function8b3cd: ; 8b3cd (22:73cd)
	push de
	push bc
	ld e, $4
.asm_8b3d1
	ld a, [bc]
	inc bc
	call Function8998b
	inc hl
	dec e
	jr nz, .asm_8b3d1
	pop bc
	pop de
	ret

Function8b3dd: ; 8b3dd (22:73dd)
	push de
	push bc
	call Function354b
	ld a, c
	pop bc
	pop de
	bit 0, a
	jr nz, .asm_8b3f7
	bit 1, a
	jr nz, .asm_8b40e
	bit 6, a
	jr nz, .asm_8b429
	bit 7, a
	jr nz, .asm_8b443
	and a
	ret
.asm_8b3f7
	ld a, e
	cp $3
	jr z, .asm_8b407
	inc e
	ld d, $0
	call Function8b385
	xor a
	ld [wd010], a
	ret
.asm_8b407
	call PlayClickSFX
	ld d, $0
	scf
	ret
.asm_8b40e
	ld a, e
	and a
	jr nz, .asm_8b41e
	call PlayClickSFX
	ld d, $ff
	call Function8b385
	ld d, $1
	scf
	ret
.asm_8b41e
	ld d, $ff
	call Function8b385
	dec e
	xor a
	ld [wd010], a
	ret
.asm_8b429
	call Function8b379
	ld a, d
	cp $a
	jr c, .asm_8b433
	ld d, $9
.asm_8b433
	inc d
	ld a, d
	cp $a
	jr c, .asm_8b43b
	ld d, $0
.asm_8b43b
	call Function8b385
	xor a
	ld [wd010], a
	ret
.asm_8b443
	call Function8b379
	ld a, d
	cp $a
	jr c, .asm_8b44d
	ld d, $0
.asm_8b44d
	ld a, d
	dec d
	and a
	jr nz, .asm_8b454
	ld d, $9
.asm_8b454
	call Function8b385
	xor a
	ld [wd010], a
	ret

Function8b45c: ; 8b45c (22:745c)
	call Function8b36c
	xor a
	ld [wd010], a
	ld [wd012], a
	call Function8b391
	ld d, $0
	call Function8b385
.asm_8b46e
	call Function8923c
	call Function8b493
	call Function8b4cc
	call Function8b518
	call Function89b78
	push bc
	call Function8b4fd
	call Function89c44
	ld a, $1
	ld [hBGMapMode], a
	pop bc
	call Function8b3dd
	jr nc, .asm_8b46e
	ld a, d
	and a
	ret z
	scf
	ret

Function8b493: ; 8b493 (22:7493)
	push bc
	call Function8923c
	call Function8b521
	ld hl, Jumptable_8b4a0
	pop bc
	rst JumpTable
	ret

Jumptable_8b4a0: ; 8b4a0 (22:74a0)
	dw Function8b4a4
	dw Function8b4b8


Function8b4a4: ; 8b4a4 (22:74a4)
	push bc
	push de
	call Function8b4d8
	call TextBox
	pop de
	pop bc
	call Function8b4cc
	call Function8b518
	call Function8b3cd
	ret

Function8b4b8: ; 8b4b8 (22:74b8)
	push bc
	push de
	call Function8b4ea
	call Function89b3b
	pop de
	pop bc
	call Function8b4cc
	call Function8b518
	call Function8b3cd
	ret

Function8b4cc: ; 8b4cc (22:74cc)
	push bc
	ld hl, Unknown_8b529
	call Function8b50a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop bc
	ret

Function8b4d8: ; 8b4d8 (22:74d8)
	ld hl, Unknown_8b529
	call Function8b50a
	push hl
rept 2
	inc hl
endr
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
	pop hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

Function8b4ea: ; 8b4ea (22:74ea)
	ld hl, Unknown_8b529
	call Function8b50a
	push hl
rept 2
	inc hl
endr
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ret

Function8b4fd: ; 8b4fd (22:74fd)
	ld hl, Unknown_8b529 + 4
	call Function8b50a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld d, a
	ret

Function8b50a: ; 8b50a (22:750a)
	ld a, [wd02e]
	and a
	ret z
	ld b, $0
	ld c, $8
.asm_8b513
	add hl, bc
	dec a
	jr nz, .asm_8b513
	ret

Function8b518: ; 8b518 (22:7518)
	push de
	ld d, $0
	ld e, $14
	add hl, de
	inc hl
	pop de
	ret

Function8b521: ; 8b521 (22:7521)
	ld hl, Unknown_8b529 + 7
	call Function8b50a
	ld a, [hl]
	ret
; 8b529 (22:7529)

Unknown_8b529: ; 8b529
	dwcoord 2, 5
	db 1, 4, $20, $49, 0, 1
	dwcoord 7, 4
	db 1, 4, $48, $41, 0, 0
; 8b539

Function8b539: ; 8b539 (22:7539)
	ld bc, wd017
	call Function8b36c
	xor a
	ld [wd012], a
	ld [wd02e], a
	call Function8b493
	call Function8b4fd
	ld e, $0
	call Function89c44
	call CGBOnly_LoadEDTile
	ret

Function8b555: ; 8b555 (22:7555)
	ld hl, UnknownText_0x8b5ce
	call PrintText
	ld bc, wd017
	call Function8b45c
	jr c, .asm_8b5c8
	call Function89448
	ld bc, wd017
	call Function8b493
	ld bc, wd017
	call Function8b664
	jr nz, .asm_8b57c
	ld hl, UnknownText_0x8b5e2
	call PrintText
	jr Function8b555
.asm_8b57c
	ld hl, UnknownText_0x8b5d3
	call PrintText
	ld bc, wd013
	call Function8b45c
	jr c, Function8b555
	ld bc, wd017
	ld hl, wd013
	call Function8b3a4
	jr z, .asm_8b5a6
	call Function89448
	ld bc, wd013
	call Function8b493
	ld hl, UnknownText_0x8b5d8
	call PrintText
	jr .asm_8b57c
.asm_8b5a6
	call OpenSRAMBank4
	ld hl, wd013
	ld de, $a037
	ld bc, $4
	call CopyBytes
	call CloseSRAM
	call Function89448
	ld bc, wd013
	call Function8b493
	ld hl, UnknownText_0x8b5dd
	call PrintText
	and a
.asm_8b5c8
	push af
	call Function89448
	pop af
	ret
; 8b5ce (22:75ce)

UnknownText_0x8b5ce: ; 0x8b5ce
	; Please enter any four-digit number.
	text_jump UnknownText_0x1bc187
	db "@"
; 0x8b5d3

UnknownText_0x8b5d3: ; 0x8b5d3
	; Enter the same number to confirm.
	text_jump UnknownText_0x1bc1ac
	db "@"
; 0x8b5d8

UnknownText_0x8b5d8: ; 0x8b5d8
	; That's not the same number.
	text_jump UnknownText_0x1bc1cf
	db "@"
; 0x8b5dd

UnknownText_0x8b5dd: ; 0x8b5dd
	; Your PASSCODE has been set. Enter this number next time to open the CARD FOLDER.
	text_jump UnknownText_0x1bc1eb
	db "@"
; 0x8b5e2

UnknownText_0x8b5e2: ; 0x8b5e2
	; 0000 is invalid!
	text_jump UnknownText_0x1bc23e
	db "@"
; 0x8b5e7

Function8b5e7: ; 8b5e7 (22:75e7)
	ld bc, wd013
	call Function8b36c
	xor a
	ld [wd012], a
	ld [wd02e], a
	call Function8b493
	call Function891ab
	call Function8b4fd
	ld e, $0
	call Function89c44
.asm_8b602
	ld hl, UnknownText_0x8b642
	call PrintText
	ld bc, wd013
	call Function8b45c
	jr c, .asm_8b63c
	call Function89448
	ld bc, wd013
	call Function8b493
	call OpenSRAMBank4
	ld hl, $a037
	call Function8b3a4
	call CloseSRAM
	jr z, .asm_8b635
	ld hl, UnknownText_0x8b647
	call PrintText
	ld bc, wd013
	call Function8b36c
	jr .asm_8b602
.asm_8b635
	ld hl, UnknownText_0x8b64c
	call PrintText
	and a
.asm_8b63c
	push af
	call Function89448
	pop af
	ret
; 8b642 (22:7642)

UnknownText_0x8b642: ; 0x8b642
	; Enter the CARD FOLDER PASSCODE.
	text_jump UnknownText_0x1bc251
	db "@"
; 0x8b647

UnknownText_0x8b647: ; 0x8b647
	; Incorrect PASSCODE!
	text_jump UnknownText_0x1bc272
	db "@"
; 0x8b64c

UnknownText_0x8b64c: ; 0x8b64c
	; CARD FOLDER open.@ @
	text_jump UnknownText_0x1bc288
	start_asm
	ld de, SFX_TWINKLE
	call PlaySFX
	call WaitSFX
	ld c, $8
	call DelayFrames
	ld hl, .string_8b663
	ret
.string_8b663
	db "@"
; 8b664

Function8b664: ; 8b664 (22:7664)
	push bc
	ld de, $4
.asm_8b668
	ld a, [bc]
	cp $0
	jr nz, .asm_8b66e
	inc d
.asm_8b66e
	inc bc
	dec e
	jr nz, .asm_8b668
	pop bc
	ld a, d
	cp $4
	ret

Function8b677: ; 8b677
	call ClearBGPalettes
	call DisableLCD
	call Function8b690
	call Function8b6bb
	call Function8b6ed
	call EnableLCD
	call Function891ab
	call SetPalettes
	ret
; 8b690

Function8b690: ; 8b690
	ld hl, GFX_17afa5 + $514
	ld de, VTiles2
	ld bc, $160
	ld a, BANK(GFX_17afa5)
	call FarCopyBytes
	ld hl, GFX_17afa5 + $514 + $160 - $10
	ld de, VTiles2 tile $61
	ld bc, $10
	ld a, BANK(GFX_17afa5)
	call FarCopyBytes
	ld hl, GFX_17afa5 + $514 + $160
	ld de, VTiles1 tile $6e
	ld bc, $10
	ld a, BANK(GFX_17afa5)
	call FarCopyBytes
	ret
; 8b6bb

Function8b6bb: ; 8b6bb
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, Palette_8b6d5
	ld de, UnknBGPals
	ld bc, $0018
	call CopyBytes
	pop af
	ld [rSVBK], a
	call Function8949c
	ret
; 8b6d5

Palette_8b6d5: ; 8b6d5
	RGB 31, 31, 31
	RGB 31, 21, 00
	RGB 14, 07, 03
	RGB 00, 00, 00
	RGB 31, 31, 31
	RGB 31, 21, 00
	RGB 22, 09, 17
	RGB 00, 00, 00
	RGB 31, 31, 31
	RGB 31, 21, 00
	RGB 06, 24, 08
	RGB 00, 00, 00
; 8b6ed

Function8b6ed: ; 8b6ed
	hlcoord 0, 0, AttrMap
	ld bc, $012c
	xor a
	call ByteFill
	hlcoord 0, 14, AttrMap
	ld bc, $0050
	ld a, $7
	call ByteFill
	ret
; 8b703

Function8b703: ; 8b703
	call Function8923c
	push hl
	ld a, $c
	ld [hli], a
	inc a
	call Function8b73e
	inc a
	ld [hl], a
	pop hl
	push hl
	push bc
	ld de, SCREEN_WIDTH
	add hl, de
.asm_8b717
	push hl
	ld a, $f
	ld [hli], a
	ld a, $7f
	call Function8b73e
	ld a, $11
	ld [hl], a
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	dec b
	jr nz, .asm_8b717
	call Function8b732
	pop bc
	pop hl
	jr Function8b744
; 8b732

Function8b732: ; 8b732
	ld a, $12
	ld [hli], a
	ld a, $13
	call Function8b73e
	ld a, $14
	ld [hl], a
	ret
; 8b73e

Function8b73e: ; 8b73e
	ld d, c
.asm_8b73f
	ld [hli], a
	dec d
	jr nz, .asm_8b73f
	ret
; 8b744

Function8b744: ; 8b744
	ld de, AttrMap - TileMap
	add hl, de
rept 2
	inc b
endr
rept 2
	inc c
endr
	xor a
.asm_8b74d
	push bc
	push hl
.asm_8b74f
	ld [hli], a
	dec c
	jr nz, .asm_8b74f
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	pop bc
	dec b
	jr nz, .asm_8b74d
	ret
; 8b75d

Function8b75d: ; 8b75d
	call Function8923c
	hlcoord 0, 0
	ld a, $1
	ld bc, SCREEN_WIDTH
	call ByteFill
	hlcoord 0, 1
	ld a, $2
	ld [hl], a
	hlcoord 9, 1
	ld c, $b
	call Function8b788
	hlcoord 1, 1
	ld a, $4
	ld e, $8
.asm_8b780
	ld [hli], a
	inc a
	dec e
	jr nz, .asm_8b780
	jr Function8b79e
; 8b787

Function8b788: ; 8b788
.asm_8b788
	ld a, $2
	ld [hli], a
	dec c
	ret z
	ld a, $1
	ld [hli], a
	dec c
	ret z
	ld a, $3
	ld [hli], a
	dec c
	ret z
	ld a, $1
	ld [hli], a
	dec c
	jr nz, .asm_8b788
	ret
; 8b79e

Function8b79e: ; 8b79e
	hlcoord 0, 1, AttrMap
	ld a, $1
	ld [hli], a
	hlcoord 9, 1, AttrMap
	ld e, $b
.asm_8b7a9
	ld a, $2
	ld [hli], a
	dec e
	ret z
	xor a
	ld [hli], a
	dec e
	ret z
	ld a, $1
	ld [hli], a
	dec e
	ret z
	xor a
	ld [hli], a
	dec e
	jr nz, .asm_8b7a9
	ret
; 8b7bd

Function8b7bd: ; 8b7bd
	call Function8b855
	ld hl, MenuDataHeader_0x8b867
	call CopyMenuDataHeader
	ld a, [wd030]
	ld [wMenuCursorBuffer], a
	ld a, [wd031]
	ld [wMenuScrollPosition], a
	ld a, [wd032]
	and a
	jr z, .asm_8b7e0
	ld a, [wMenuFlags]
	set 3, a
	ld [wMenuFlags], a

.asm_8b7e0
	ld a, [wd0e3]
	and a
	jr z, .asm_8b7ea
	dec a
	ld [wScrollingMenuCursorPosition], a

.asm_8b7ea
	hlcoord 0, 2
	ld b, $b
	ld c, $12
	call Function8b703
	call Function8b75d
	call UpdateSprites
	call Function89209
	call ScrollingMenu
	call Function8920f
	ld a, [wMenuJoypad]
	cp $2
	jr z, .asm_8b823
	cp $20
	jr nz, .asm_8b813
	call Function8b832
	jr .asm_8b7ea

.asm_8b813
	cp $10
	jr nz, .asm_8b81c
	call Function8b83e
	jr .asm_8b7ea

.asm_8b81c
	ld a, [MenuSelection]
	cp $ff
	jr nz, .asm_8b824

.asm_8b823
	xor a

.asm_8b824
	ld c, a
	ld a, [wMenuCursorY]
	ld [wd030], a
	ld a, [wMenuScrollPosition]
	ld [wd031], a
	ret
; 8b832

Function8b832: ; 8b832
	ld a, [wMenuScrollPosition]
	ld hl, wMenuData2Items
	sub [hl]
	jr nc, Function8b84b
	xor a
	jr Function8b84b
; 8b83e

Function8b83e: ; 8b83e
	ld a, [wMenuScrollPosition]
	ld hl, wMenuData2Items
	add [hl]
	cp $24
	jr c, Function8b84b
	ld a, $24

Function8b84b: ; 8b84b
	ld [wMenuScrollPosition], a
	ld a, [wMenuCursorY]
	ld [wMenuCursorBuffer], a
	ret
; 8b855

Function8b855: ; 8b855
	ld a, $28
	ld hl, wd002
	ld [hli], a
	ld c, $28
	xor a
.asm_8b85e
	inc a
	ld [hli], a
	dec c
	jr nz, .asm_8b85e
	ld a, $ff
	ld [hl], a
	ret
; 8b867

MenuDataHeader_0x8b867: ; 0x8b867
	db $40 ; flags
	db 03, 01 ; start coords
	db 13, 18 ; end coords
	dw MenuData2_0x8b870
	db 1 ; default option
; 0x8b86f

	db 0

MenuData2_0x8b870: ; 0x8b870
	db $3c ; flags
	db 5 ; items
	db 3, 1
	dbw 0, wd002
	dba Function8b880
	dba Function8b88c
	dba Function8b8c8
; 8b880

Function8b880: ; 8b880
	ld h, d
	ld l, e
	ld de, MenuSelection
	lb bc, PRINTNUM_LEADINGZEROS | 1, 2
	call PrintNum
	ret
; 8b88c

Function8b88c: ; 8b88c
	call OpenSRAMBank4
	ld h, d
	ld l, e
	push hl
	ld de, String_89116
	call Function8931b
	call Function8932d
	jr c, .asm_8b8a3
	ld hl, 0
	add hl, bc
	ld d, h
	ld e, l

.asm_8b8a3
	pop hl
	push hl
	call PlaceString
	pop hl
	ld d, $0
	ld e, $6
	add hl, de
	push hl
	ld de, String_89116
	call Function8931b
	call Function8934a
	jr c, .asm_8b8c0
	ld hl, $0006
	add hl, bc
	ld d, h
	ld e, l

.asm_8b8c0
	pop hl
	call PlaceString
	call CloseSRAM
	ret
; 8b8c8

Function8b8c8: ; 8b8c8
	hlcoord 0, 14
	ld b, $2
	ld c, $12
	call TextBox
	ld a, [wd033]
	ld b, 0
	ld c, a
	ld hl, Unknown_8b903
rept 2
	add hl, bc
endr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld d, h
	ld e, l
	hlcoord 1, 16
	call PlaceString
	hlcoord 0, 13
	ld a, $f
	ld [hl], a
	hlcoord 19, 13
	ld a, $11
	ld [hl], a
	ld a, [wMenuScrollPosition]
	cp $24
	ret c
	hlcoord 0, 13
	ld c, $12
	call Function8b732
	ret
; 8b903

Unknown_8b903: ; 8b903
	dw String_8b90b
	dw String_8b919
	dw String_8b92a
	dw String_8b938

String_8b90b: db "めいしを えらんでください@"        ; Please select a noun.
String_8b919: db "どの めいしと いれかえますか?@"    ; OK to swap with any noun?
String_8b92a: db "あいてを えらんでください@"        ; Please select an opponent.
String_8b938: db "いれる ところを えらんでください@" ; Please select a location.
; 8b94a

Function8b94a: ; 8b94a
	ld [wd033], a
	xor a
	ld [wMenuScrollPosition], a
	ld [wd032], a
	ld [wd0e3], a
	ld [wd031], a
	ld a, $1
	ld [wd030], a
	ret
; 8b960
