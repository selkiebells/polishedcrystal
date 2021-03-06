Facings: ; 4049
	dw FacingStepDown0    ; FACING_STEP_DOWN_0
	dw FacingStepDown1    ; FACING_STEP_DOWN_1
	dw FacingStepDown2    ; FACING_STEP_DOWN_2
	dw FacingStepDown3    ; FACING_STEP_DOWN_3
	dw FacingStepUp0      ; FACING_STEP_UP_0
	dw FacingStepUp1      ; FACING_STEP_UP_1
	dw FacingStepUp2      ; FACING_STEP_UP_2
	dw FacingStepUp3      ; FACING_STEP_UP_3
	dw FacingStepLeft0    ; FACING_STEP_LEFT_0
	dw FacingStepLeft1    ; FACING_STEP_LEFT_1
	dw FacingStepLeft2    ; FACING_STEP_LEFT_2
	dw FacingStepLeft3    ; FACING_STEP_LEFT_3
	dw FacingStepRight0   ; FACING_STEP_RIGHT_0
	dw FacingStepRight1   ; FACING_STEP_RIGHT_1
	dw FacingStepRight2   ; FACING_STEP_RIGHT_2
	dw FacingStepRight3   ; FACING_STEP_RIGHT_3
	dw FacingFishDown     ; FACING_FISH_DOWN
	dw FacingFishUp       ; FACING_FISH_UP
	dw FacingFishLeft     ; FACING_FISH_LEFT
	dw FacingFishRight    ; FACING_FISH_RIGHT
	dw FacingEmote        ; FACING_EMOTE
	dw FacingShadow       ; FACING_SHADOW
	dw FacingBigDollAsym  ; FACING_BIG_DOLL_ASYM
	dw FacingBigDollSym   ; FACING_BIG_DOLL_SYM
	dw FacingWeirdTree0   ; FACING_WEIRD_TREE_0
	dw FacingWeirdTree1   ; FACING_WEIRD_TREE_1
	dw FacingWeirdTree2   ; FACING_WEIRD_TREE_2
	dw FacingWeirdTree3   ; FACING_WEIRD_TREE_3
	dw FacingBoulderDust1 ; FACING_BOULDER_DUST_1
	dw FacingBoulderDust2 ; FACING_BOULDER_DUST_2
	dw FacingGrass1       ; FACING_GRASS_1
	dw FacingGrass2       ; FACING_GRASS_2
FacingsEnd: dw 0

NUM_FACINGS EQU (FacingsEnd - Facings) / 2


; Tables used as a reference to transform OAM data.

; Format:
;	db y, x, attributes, tile index

FacingStepDown0:
FacingStepDown2:
FacingWeirdTree0:
FacingWeirdTree2:
	db 4 ; #
	db  0,  0, 0, $00
	db  0,  8, 0, $01
	db  8,  0, 2, $02
	db  8,  8, 2, $03
; 409c

FacingStepDown1:
	db 4 ; #
	db  0,  0, 0, $80
	db  0,  8, 0, $81
	db  8,  0, 2, $82
	db  8,  8, 2, $83
; 40ad

FacingStepDown3:
	db 4 ; #
	db  0,  8, 0 | X_FLIP, $80
	db  0,  0, 0 | X_FLIP, $81
	db  8,  8, 2 | X_FLIP, $82
	db  8,  0, 2 | X_FLIP, $83
; 40be

FacingStepUp0:
FacingStepUp2:
	db 4 ; #
	db  0,  0, 0, $04
	db  0,  8, 0, $05
	db  8,  0, 2, $06
	db  8,  8, 2, $07
; 40cf

FacingStepUp1:
	db 4 ; #
	db  0,  0, 0, $84
	db  0,  8, 0, $85
	db  8,  0, 2, $86
	db  8,  8, 2, $87
; 40e0

FacingStepUp3:
	db 4 ; #
	db  0,  8, 0 | X_FLIP, $84
	db  0,  0, 0 | X_FLIP, $85
	db  8,  8, 2 | X_FLIP, $86
	db  8,  0, 2 | X_FLIP, $87
; 40f1

FacingStepLeft0:
FacingStepLeft2:
	db 4 ; #
	db  0,  0, 0, $08
	db  0,  8, 0, $09
	db  8,  0, 2, $0a
	db  8,  8, 2, $0b
; 4102

FacingStepRight0:
FacingStepRight2:
	db 4 ; #
	db  0,  8, 0 | X_FLIP, $08
	db  0,  0, 0 | X_FLIP, $09
	db  8,  8, 2 | X_FLIP, $0a
	db  8,  0, 2 | X_FLIP, $0b
; 4113

FacingStepLeft1:
FacingStepLeft3:
	db 4 ; #
	db  0,  0, 0, $88
	db  0,  8, 0, $89
	db  8,  0, 2, $8a
	db  8,  8, 2, $8b
; 4124

FacingStepRight1:
FacingStepRight3:
	db 4 ; #
	db  0,  8, 0 | X_FLIP, $88
	db  0,  0, 0 | X_FLIP, $89
	db  8,  8, 2 | X_FLIP, $8a
	db  8,  0, 2 | X_FLIP, $8b
; 4135

FacingFishDown:
	db 5 ; #
	db  0,  0, 0, $00
	db  0,  8, 0, $01
	db  8,  0, 2, $02
	db  8,  8, 2, $03
	db 16,  0, 4, $7c
; 414a

FacingFishUp:
	db 5 ; #
	db  0,  0, 0, $04
	db  0,  8, 0, $05
	db  8,  0, 2, $06
	db  8,  8, 2, $07
	db -8,  0, 4, $7c
; 415f

FacingFishLeft:
	db 5 ; #
	db  0,  0, 0, $08
	db  0,  8, 0, $09
	db  8,  0, 2, $0a
	db  8,  8, 2, $0b
	db  5, -8, 4 | X_FLIP, $7d
; 4174

FacingFishRight:
	db 5 ; #
	db  0,  8, 0 | X_FLIP, $08
	db  0,  0, 0 | X_FLIP, $09
	db  8,  8, 2 | X_FLIP, $0a
	db  8,  0, 2 | X_FLIP, $0b
	db  5, 16, 4, $7d
; 4189

FacingEmote:
	db 4 ; #
	db  0,  0, 4, $78
	db  0,  8, 4, $79
	db  8,  0, 4, $7a
	db  8,  8, 4, $7b
; 419a

FacingShadow:
	db 2 ; #
	db  0,  0, 4, $7c
	db  0,  8, 4 | X_FLIP, $7c
; 41a3

FacingBigDollSym: ; big snorlax or lapras doll
	db 16 ; #
	db  0,  0, 0, $00
	db  0,  8, 0, $01
	db  8,  0, 0, $02
	db  8,  8, 0, $03
	db 16,  0, 0, $04
	db 16,  8, 0, $05
	db 24,  0, 0, $06
	db 24,  8, 0, $07
	db  0, 24, 0 | X_FLIP, $00
	db  0, 16, 0 | X_FLIP, $01
	db  8, 24, 0 | X_FLIP, $02
	db  8, 16, 0 | X_FLIP, $03
	db 16, 24, 0 | X_FLIP, $04
	db 16, 16, 0 | X_FLIP, $05
	db 24, 24, 0 | X_FLIP, $06
	db 24, 16, 0 | X_FLIP, $07
; 41e4

FacingWeirdTree1:
	db 4 ; #
	db  0,  0, 0, $04
	db  0,  8, 0, $05
	db  8,  0, 0, $06
	db  8,  8, 0, $07
; 41f5

FacingWeirdTree3:
	db 4 ; #
	db  0,  8, 0 | X_FLIP, $04
	db  0,  0, 0 | X_FLIP, $05
	db  8,  8, 0 | X_FLIP, $06
	db  8,  0, 0 | X_FLIP, $07
; 4206

FacingBigDollAsym: ; big doll other than snorlax or lapras
	db 14 ; #
	db  0,  0, 0, $00
	db  0,  8, 0, $01
	db  8,  0, 0, $04
	db  8,  8, 0, $05
	db 16,  8, 0, $07
	db 24,  8, 0, $0a
	db  0, 24, 0, $03
	db  0, 16, 0, $02
	db  8, 24, 0 | X_FLIP, $02
	db  8, 16, 0, $06
	db 16, 24, 0, $09
	db 16, 16, 0, $08
	db 24, 24, 0 | X_FLIP, $04
	db 24, 16, 0, $0b
; 423f

FacingBoulderDust1:
	db 4 ; #
	db  0,  0, 4, $7e
	db  0,  8, 4, $7e
	db  8,  0, 4, $7e
	db  8,  8, 4, $7e
; 4250

FacingBoulderDust2:
	db 4 ; #
	db  0,  0, 4, $7f
	db  0,  8, 4, $7f
	db  8,  0, 4, $7f
	db  8,  8, 4, $7f
; 4261

FacingGrass1:
	db 2 ; #
	db  8,  0, 4, $7e
	db  8,  8, 4 | X_FLIP, $7e
; 426a

FacingGrass2:
	db 2 ; #
	db  9, -1, 4, $7e
	db  9,  9, 4 | X_FLIP, $7e
; 4273
