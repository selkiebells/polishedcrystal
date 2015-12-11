const_value set 2
	const AZALEATOWN_AZALEA_ROCKET1
	const AZALEATOWN_GRAMPS
	const AZALEATOWN_TEACHER
	const AZALEATOWN_YOUNGSTER
	const AZALEATOWN_SLOWPOKE1
	const AZALEATOWN_SLOWPOKE2
	const AZALEATOWN_SLOWPOKE3
	const AZALEATOWN_SLOWPOKE4
	const AZALEATOWN_FRUIT_TREE
	const AZALEATOWN_SILVER
	const AZALEATOWN_AZALEA_ROCKET3
	const AZALEATOWN_KURT_OUTSIDE

AzaleaTown_MapScriptHeader:
.MapTriggers:
	db 3

	; triggers
	dw .Trigger0, 0
	dw .Trigger1, 0
	dw .Trigger2, 0

.MapCallbacks:
	db 1

	; callbacks
	dbw 5, .Flypoint

.Trigger0
	end

.Trigger1
	end

.Trigger2
	end

.Flypoint
	setflag ENGINE_FLYPOINT_AZALEA
	return

UnknownScript_0x198018:
	moveperson AZALEATOWN_SILVER, $b, $b
	spriteface PLAYER, RIGHT
	showemote EMOTE_SHOCK, PLAYER, 15
	special Special_FadeOutMusic
	pause 15
	appear AZALEATOWN_SILVER
	applymovement AZALEATOWN_SILVER, MovementData_0x198134
	spriteface PLAYER, DOWN
	jump UnknownScript_0x198049

UnknownScript_0x198034:
	spriteface PLAYER, RIGHT
	showemote EMOTE_SHOCK, PLAYER, 15
	special Special_FadeOutMusic
	pause 15
	appear AZALEATOWN_SILVER
	applymovement AZALEATOWN_SILVER, MovementData_0x19813c
	spriteface PLAYER, UP
UnknownScript_0x198049:
	playmusic MUSIC_RIVAL_ENCOUNTER
	opentext
	writetext UnknownText_0x19814d
	waitbutton
	closetext
	setevent EVENT_RIVAL_AZALEA_TOWN
	checkevent EVENT_GOT_TOTODILE_FROM_ELM
	iftrue UnknownScript_0x198071
	checkevent EVENT_GOT_CHIKORITA_FROM_ELM
	iftrue UnknownScript_0x198081
	winlosstext UnknownText_0x1981e6, UnknownText_0x19835b
	setlasttalked AZALEATOWN_SILVER
	loadtrainer RIVAL1, RIVAL1_6
	startbattle
	reloadmapmusic
	returnafterbattle
	jump UnknownScript_0x198091

UnknownScript_0x198071:
	winlosstext UnknownText_0x1981e6, UnknownText_0x19835b
	setlasttalked AZALEATOWN_SILVER
	loadtrainer RIVAL1, RIVAL1_4
	startbattle
	reloadmapmusic
	returnafterbattle
	jump UnknownScript_0x198091

UnknownScript_0x198081:
	winlosstext UnknownText_0x1981e6, UnknownText_0x19835b
	setlasttalked AZALEATOWN_SILVER
	loadtrainer RIVAL1, RIVAL1_5
	startbattle
	reloadmapmusic
	returnafterbattle
	jump UnknownScript_0x198091

UnknownScript_0x198091:
	playmusic MUSIC_RIVAL_AFTER
	opentext
	writetext UnknownText_0x198233
	waitbutton
	closetext
	spriteface PLAYER, LEFT
	applymovement AZALEATOWN_SILVER, MovementData_0x198144
	playsound SFX_EXIT_BUILDING
	disappear AZALEATOWN_SILVER
	dotrigger $0
	waitsfx
	playmapmusic
	end

AzaleaRocketScript_0x1980ab:
	jumptextfaceplayer UnknownText_0x19837b

AzaleaRocketScript_0x1980ae:
	jumptextfaceplayer UnknownText_0x1983c7

GrampsScript_0x1980b1:
	faceplayer
	opentext
	checkevent EVENT_CLEARED_SLOWPOKE_WELL
	iftrue UnknownScript_0x1980bf
	writetext UnknownText_0x19841b
	waitbutton
	closetext
	end

UnknownScript_0x1980bf:
	writetext UnknownText_0x198473
	waitbutton
	closetext
	end

TeacherScript_0x1980c5:
	jumptextfaceplayer UnknownText_0x1984ce

YoungsterScript_0x1980c8:
	jumptextfaceplayer UnknownText_0x19851a

SlowpokeScript_0x1980cb:
	opentext
	writetext UnknownText_0x1985b0
	pause 60
	writetext UnknownText_0x1985c3
	cry SLOWPOKE
	waitbutton
	closetext
	end

WoosterScript:
; unused
	faceplayer
	opentext
	writetext WoosterText
	cry QUAGSIRE
	waitbutton
	closetext
	end

UnknownScript_0x1980e5:
	applymovement PLAYER, MovementData_0x198148
	opentext
	writetext UnknownText_0x1985df
	buttonsound
	spriteface AZALEATOWN_KURT_OUTSIDE, RIGHT
	writetext UnknownText_0x19860b
	buttonsound
	writetext UnknownText_0x198628
	waitbutton
	verbosegiveitem GS_BALL
	spriteface AZALEATOWN_KURT_OUTSIDE, LEFT
	setflag ENGINE_HAVE_EXAMINED_GS_BALL
	clearevent EVENT_ILEX_FOREST_LASS
	setevent EVENT_ROUTE_34_ILEX_FOREST_GATE_LASS
	dotrigger $0
	closetext
	end

KurtOutsideScript_0x19810c:
	faceplayer
	opentext
	writetext UnknownText_0x198628
	waitbutton
	spriteface AZALEATOWN_KURT_OUTSIDE, LEFT
	closetext
	end

AzaleaTownSign:
	jumptext AzaleaTownSignText

KurtsHouseSign:
	jumptext KurtsHouseSignText

AzaleaGymSign:
	jumptext AzaleaGymSignText

SlowpokeWellSign:
	jumptext SlowpokeWellSignText

CharcoalKilnSign:
	jumptext CharcoalKilnSignText

AzaleaTownIlextForestSign:
	jumptext AzaleaTownIlexForestSignText

AzaleaTownPokeCenterSign:
	jumpstd pokecentersign

AzaleaTownMartSign:
	jumpstd martsign

WhiteApricornTree:
	fruittree FRUITTREE_AZALEA_TOWN

MapAzaleaTownSignpostItem8:
	dwb EVENT_AZALEA_TOWN_HIDDEN_FULL_HEAL, FULL_HEAL
	

MovementData_0x198134:
	step_left
	step_left
	step_left
	step_left
	step_left
	step_left
	turn_head_up
	step_end

MovementData_0x19813c:
	step_left
	step_left
	step_left
	step_left
	step_left
	step_left
	turn_head_down
	step_end

MovementData_0x198144:
	step_left
	step_left
	step_left
	step_end

MovementData_0x198148:
	step_left
	step_left
	step_up
	turn_head_left
	step_end

UnknownText_0x19814d:
	text "…Tell me some-"
	line "thing."

	para "Is it true that"
	line "TEAM ROCKET has"
	cont "returned?"

	para "What? You beat"
	line "them? Hah! Quit"
	cont "lying."

	para "You're not joking?"
	line "Then let's see how"
	cont "good you are."
	done

UnknownText_0x1981e6:
	text "… Humph! Useless"
	line "#MON!"

	para "Listen, you. You"
	line "only won because"

	para "my #MON were"
	line "weak."
	done

UnknownText_0x198233:
	text "I hate the weak."

	para "#MON, trainers."
	line "It doesn't matter"
	cont "who or what."

	para "I'm going to be"
	line "strong and wipe"
	cont "out the weak."

	para "That goes for TEAM"
	line "ROCKET too."

	para "They act big and"
	line "tough in a group."

	para "But get them"
	line "alone, and they're"
	cont "weak."

	para "I hate them all."

	para "You stay out of my"
	line "way. A weakling"

	para "like you is only a"
	line "distraction."
	done

UnknownText_0x19835b:
	text "…Humph! I knew"
	line "you were lying."
	done

UnknownText_0x19837b:
	text "It's unsafe to go"
	line "in there, so I'm"
	cont "standing guard."

	para "Aren't I a good"
	line "Samaritan?"
	done

UnknownText_0x1983c7:
	text "Do you know about"
	line "SLOWPOKETAIL? I"
	cont "heard it's tasty!"

	para "Aren't you glad I"
	line "told you that?"
	done

UnknownText_0x19841b:
	text "The SLOWPOKE have"
	line "disappeared from"
	cont "town…"

	para "I heard their"
	line "TAILS are being"
	cont "sold somewhere."
	done

UnknownText_0x198473:
	text "The SLOWPOKE have"
	line "returned."

	para "Knowing them, they"
	line "could've just been"

	para "goofing off some-"
	line "where."
	done

UnknownText_0x1984ce:
	text "Did you come to"
	line "get KURT to make"
	cont "some BALLS?"

	para "A lot of people do"
	line "just that."
	done

UnknownText_0x19851a:
	text "Cut through AZALEA"
	line "and you'll be in"
	cont "ILEX FOREST."

	para "But these skinny"
	line "trees make it"

	para "impossible to get"
	line "through."

	para "The CHARCOAL MAN's"
	line "#MON can CUT"
	cont "down trees."
	done

UnknownText_0x1985b0:
	text "SLOWPOKE: …"

	para "<......> <......> <......>"
	done

UnknownText_0x1985c3:
	text "<......> <......>Yawn?"
	done

WoosterText:
	text "WOOSTER: Gugyoo…"
	done

UnknownText_0x1985df:
	text "ILEX FOREST is"
	line "restless!"

	para "What is going on?"
	done

UnknownText_0x19860b:
	text "<PLAYER>, here's"
	line "your GS BALL back!"
	done

UnknownText_0x198628:
	text "Could you go see"
	line "why ILEX FOREST is"
	cont "so restless?"
	done

AzaleaTownSignText:
	text "AZALEA TOWN"
	line "Where People and"

	para "#MON Live in"
	line "Happy Harmony"
	done

KurtsHouseSignText:
	text "KURT'S HOUSE"
	done

AzaleaGymSignText:
	text "AZALEA TOWN"
	line "#MON GYM"
	cont "LEADER: BUGSY"

	para "The Walking"
	line "Bug #MON"
	cont "Encyclopedia"
	done

SlowpokeWellSignText:
	text "SLOWPOKE WELL"

	para "Also known as the"
	line "RAINMAKER WELL."

	para "Locals believe"
	line "that a SLOWPOKE's"
	cont "yawn summons rain."

	para "Records show that"
	line "a SLOWPOKE's yawn"

	para "ended a drought"
	line "400 years ago."
	done

CharcoalKilnSignText:
	text "CHARCOAL KILN"
	done

AzaleaTownIlexForestSignText:
	text "ILEX FOREST"

	para "Enter through the"
	line "gate."
	done

AzaleaTown_MapEventHeader:
	; filler
	db 0, 0

.Warps:
	db 8
	warp_def $9, $f, 1, AZALEA_POKECENTER_1F
	warp_def $d, $15, 1, CHARCOAL_KILN
	warp_def $5, $15, 2, AZALEA_MART
	warp_def $5, $9, 1, KURTS_HOUSE
	warp_def $f, $a, 1, AZALEA_GYM
	warp_def $7, $1f, 1, SLOWPOKE_WELL_B1F
	warp_def $a, $2, 3, ILEX_FOREST_AZALEA_GATE
	warp_def $b, $2, 4, ILEX_FOREST_AZALEA_GATE

.XYTriggers:
	db 3
	xy_trigger 1, $a, $5, $0, UnknownScript_0x198018, $0, $0
	xy_trigger 1, $b, $5, $0, UnknownScript_0x198034, $0, $0
	xy_trigger 2, $6, $9, $0, UnknownScript_0x1980e5, $0, $0

.Signposts:
	db 9
	signpost 9, 19, SIGNPOST_READ, AzaleaTownSign
	signpost 9, 10, SIGNPOST_READ, KurtsHouseSign
	signpost 15, 14, SIGNPOST_READ, AzaleaGymSign
	signpost 7, 29, SIGNPOST_READ, SlowpokeWellSign
	signpost 13, 19, SIGNPOST_READ, CharcoalKilnSign
	signpost 9, 16, SIGNPOST_READ, AzaleaTownPokeCenterSign
	signpost 5, 22, SIGNPOST_READ, AzaleaTownMartSign
	signpost 9, 3, SIGNPOST_READ, AzaleaTownIlextForestSign
	signpost 6, 31, SIGNPOST_ITEM, MapAzaleaTownSignpostItem8

.PersonEvents:
	db 12
	person_event SPRITE_AZALEA_ROCKET, 9, 31, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, PERSONTYPE_SCRIPT, 0, AzaleaRocketScript_0x1980ab, EVENT_AZALEA_TOWN_SLOWPOKETAIL_ROCKET
	person_event SPRITE_GRAMPS, 9, 21, SPRITEMOVEDATA_WANDER, 2, 1, -1, -1, 0, PERSONTYPE_SCRIPT, 0, GrampsScript_0x1980b1, -1
	person_event SPRITE_TEACHER, 13, 15, SPRITEMOVEDATA_WALK_UP_DOWN, 2, 0, -1, -1, (1 << 3) | PAL_OW_BLUE, PERSONTYPE_SCRIPT, 0, TeacherScript_0x1980c5, -1
	person_event SPRITE_YOUNGSTER, 9, 7, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 0, 1, -1, -1, (1 << 3) | PAL_OW_GREEN, PERSONTYPE_SCRIPT, 0, YoungsterScript_0x1980c8, -1
	person_event SPRITE_SLOWPOKE, 17, 8, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, 0, PERSONTYPE_SCRIPT, 0, SlowpokeScript_0x1980cb, EVENT_AZALEA_TOWN_SLOWPOKES
	person_event SPRITE_SLOWPOKE, 9, 18, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, 0, PERSONTYPE_SCRIPT, 0, SlowpokeScript_0x1980cb, EVENT_AZALEA_TOWN_SLOWPOKES
	person_event SPRITE_SLOWPOKE, 9, 29, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, 0, PERSONTYPE_SCRIPT, 0, SlowpokeScript_0x1980cb, EVENT_AZALEA_TOWN_SLOWPOKES
	person_event SPRITE_SLOWPOKE, 15, 15, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, 0, PERSONTYPE_SCRIPT, 0, SlowpokeScript_0x1980cb, EVENT_AZALEA_TOWN_SLOWPOKES
	person_event SPRITE_FRUIT_TREE, 2, 8, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, 0, PERSONTYPE_SCRIPT, 0, WhiteApricornTree, -1
	person_event SPRITE_AZALEA_ROCKET, 10, 11, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, PERSONTYPE_SCRIPT, 0, ObjectEvent, EVENT_RIVAL_AZALEA_TOWN
	person_event SPRITE_AZALEA_ROCKET, 16, 10, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, PERSONTYPE_SCRIPT, 0, AzaleaRocketScript_0x1980ae, EVENT_SLOWPOKE_WELL_ROCKETS
	person_event SPRITE_KURT_OUTSIDE, 5, 6, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, PERSONTYPE_SCRIPT, 0, KurtOutsideScript_0x19810c, EVENT_AZALEA_TOWN_KURT
