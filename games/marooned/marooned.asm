;SAMPLE CAVE MK 2.1 (C) ZETA SOFTWARE, 03/9/82.
ROOMIN	EQU	32767
	ORG	32741
	DEFB	0
	DEFW	0
	DEFW	VERBT
	DEFW	COMDOT
	DEFW	SPEDOT
	DEFW	SPGOT
	DEFW	OBTABL
	DEFW	OBROOM
	DEFW	RMNAME
	DEFW	BEFORE
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	ORG	8300H
BACK	CALL	VDUOUT
	LD	A,0DH
	CALL	33H
	LD	HL,(32742)
	JP	(HL)

VDUOUT	LD	A,(HL)
	CP	'^'
	RET	Z
	CALL	0033H
	INC	HL
	PUSH	BC
	LD	BC,512
	CALL	0060H
	POP	BC
	JR	VDUOUT
BEFORE	DEFS	256
RMNAME	DEFB	255
	DEFB	1	;ROOM 1
	DEFM	'I AM AT THE SOUTH END OF A VAST HALL STRETCHING FORWARD OUT OF  SIGHT TO THE NORTH. BEHIND ME IS AN OPEN DOORWAY.'
	DEFB	0DH
	DEFM	'TO THE WEST I CAN SEE A PASSAGE LEADING ELSEWHERE.^'
	DEFM	'I AM AT THE SOUTH END OF THE VAST HALL.^'
	DEFB	255
	DEFB	2	;ROOM 2
	DEFM	'I AM AT THE NORTH END OF A VAST HALL, STRETCHING FAR SOUTH.'
	DEFB	0DH
	DEFM	'TO THE NORTH I SEE A DOOR.^'
	DEFM	'I AM AT THE NORTH END OF THE VAST HALL, NEAR A DOOR.^'
	DEFB	255
	DEFB	3	;ROOM 3
	DEFM	'I AM STANDING NEAR A LARGE IRON DOOR.^'
	DEFM	'I AM NEAR THE DOOR.^'
	DEFB	255
	DEFB	4	;ROOM 4
	DEFM	'I AM STANDING ON A BLEAK ALIEN LANDSCAPE. TO THE NORTH I SEE A  LARGE BUILDING, AND FOOTSTEPS LEADING FROM IT.'
	DEFB	0DH
	DEFM	'SOMEONE HAS OBVIOUSLY BEEN HERE RECENTLY!!^'
	DEFM	'I AM AT THE BLEAK ALIEN LANDSCAPE.^'
	DEFB	255
	DEFB	5
	DEFM	'I AM SEATED BEHIND A HUGE MAHOGANY DESK IN THE OFFICE.'
	DEFB	0DH
	DEFM	'THE CHAIR IS COMFORTABLE TO SIT ON.^'
	DEFM	'I AM SITTING AT THE DESK.^'
	DEFB	255
	DEFB	6
	DEFM	'I HAVE ENTERED A LARGE, SPARSELY FURNISHED BUT NEVERTHELESS     COMFORTABLE OFFICE.'
	DEFB	0DH
	DEFM	'TO THE EAST I SEE A PASSAGEWAY.^'
	DEFM	'I AM IN THE OFFICE.^'
	DEFB	255
	DEFB	7	;ROOM 7
	DEFM	'I AM STANDING NEAR THE STATUE. AS I APPROACHED IT SOME HIDDEN   MECHANISM CAUSED IT TO MOVE ASIDE, TO REVEAL...^'
	DEFM	'I AM NEAR THE STATUE.^'
	DEFB	255
	DEFB	8
	DEFM	'I AM WALKING DOWN A CIRCULAR IRON STAIRCASE. THE AIR IS VERY'
	DEFB	0DH
	DEFM	'DUSTY AND STUFFY HERE.'
	DEFB	0DH
	DEFM	'BELOW ME IS MORE WINDING STAIRS.^'
	DEFM	'I AM ON THE DISUSED STAIRCASE.^'
	DEFB	255
	DEFB	9
	DEFM	'I AM INSIDE A WINE CELLAR. RACKS OF BOTTLES FILLED WITH WINE    ARE COVERED WITH COBWEBS.^'
	DEFM	'I AM IN THE CELLAR.^'
	DEFB	255
	DEFB	10	;ROOM 10
	DEFM	'I AM STANDING NEAR THE STATUE. WILLIE LOOKS ON ME BENEVOLENTLY.^'
	DEFM	'I AM STANDING NEAR THE STATUE.^'
	DEFB	255
	DEFB	11	;ROOM 11
	DEFM	'I FIND MYSELF IN A STUDY WITH EXITS TO THE NORTH AND SOUTH.^'
	DEFM	'I AM IN THE STUDY.^'
;END OF RMNAME ....
	DEFB	0
OBTABL	DEFB	255
	DEFB	1
	DEFM	'A STATUE OF WILLIE CROWTHER IS STANDING HERE.^'
	DEFM	'STATUE OF WILLIE CROWTHER.^'
	DEFM	'WILLIE^WILLIE CROWTHER^'
	DEFB	255
	DEFB	2
	DEFM	'THERE IS A LARGE IRON DOOR HERE.^'
	DEFM	'LARGE IRON DOOR.^'
	DEFM	'DOOR^IRON DOOR^'
	DEFB	255
	DEFB	3
	DEFM	'A TELEPHONE IS SITTING ON THE DESK.^'
	DEFM	'GREEN TELEPHONE.^'
	DEFM	'PHONE^TELEPHONE^'
	DEFB	255
	DEFB	4
	DEFM	'A VERY LARGE WOODEN DESK.^'
	DEFM	'LARGE DESK.^'
	DEFM	'DESK^LARGE DESK^MAHOGANY DESK^'
	DEFB	255
	DEFB	5
	DEFM	'THERE IS A WINDOW HERE.^'
	DEFM	'WINDOW.^'
	DEFM	'WINDOW^'
	DEFB	255
	DEFB	6
	DEFM	'A COMFORTABLE CHAIR SITS BEHIND THE DESK.^'
	DEFM	'CHAIR, VERY COMFORTABLE.^'
	DEFM	'CHAIR^COMFORTABLE CHAIR^'
	DEFB	255
	DEFB	7
	DEFM	'I SEE SOME PAPERS LYING IN A DRAWER.^'
	DEFM	'RANDOM PAPERS.^'
	DEFM	'PAPERS^'
	DEFB	255
	DEFB	8
	DEFM	'A SIGN HAS BEEN PAINTED ONTO THE DOOR.^S^SIGN^'
	DEFB	255
	DEFB	9
	DEFM	'A PLAQUE HAS BEEN AFFIXED TO THE WALL HERE.^P^PLAQUE^'
	DEFB	255
	DEFB	10
	DEFM	'TO THE NORTH I SEE A LARGE BUILDING.^'
	DEFM	'B^BUILDING^HALL^'
	RST	56
	DEFB	11
	DEFM	'THERE IS A WINDING STAIRCASE HERE^S^STAIR^STAIRS^STAIRCASE^WINDING STAIRCASE^'
	RST	56
	DEFB	12
	DEFM	'THERE ARE COBWEBS HERE.^COBWEBS.^COB^WEBS^COBWEBS^'
	RST	56
	DEFB	13
	DEFM	'CELLAR^CELLAR^CELLAR^'
	RST	56
	DEFB	14
	DEFM	'THERE IS A BOTTLE OF WINE HERE.^BOTTLE OF WINE.^BOTTLE^WINE^BOTTLE OF WINE^'
	RST	56
	DEFB	15
	DEFM	'THERE IS A CORK HERE.^A CORK.^CORK^'
	RST	56
	DEFB	16
	DEFM	'THERE IS A COMPUTER HERE.^A SMALL COMPUTER.^COMPUTER^SYSTEM-80^SYSTEM 80^'
	RST	56
	DEFB	17
	DEFM	'THERE IS A RUBIKS CUBE HERE.^A MIXED-UP CUBE^CUBE^RUBIKS CUBE^'
	RST	56
	DEFB	18
	DEFM	'THERE IS A ROLLED UP PIECE OF PARCHMENT HERE.^PIECE OF PARCHMENT.^PARCHMENT^PARCH^'
	RST	56
	DEFB	19
	DEFM	'THERE IS A KEY LYING ON THE GROUND HERE.^TINY KEY.^KEY^TINY KEY^'
	RST	56
	DEFB	20
	DEFM	'UU^UU^UP^U^'
	RST	56
	DEFB	21
	DEFM	'NN^NN^N^NOR^NORTH^'
	RST	56
	DEFB	22
	DEFM	'SS^SS^S^SOU^SOUTH^'
	RST	56
	DEFB	23
	DEFM	'EE^EE^E^EAS^EAST^'
	RST	56
	DEFB	24
	DEFM	'WW^WW^W^WES^WEST^'
	RST	56
	DEFB	25
	DEFM	'DD^DD^D^DOWN^'
	RST	56
	DEFB	26
	DEFM	'OFFICE^OFFICE^OFFICE^'
	RST	56
	DEFB	27
	DEFM	'LAND^LAND^LAND^LANDSCAPE^'
	RST	56
	DEFB	28
	DEFM	'LABEL^LABEL^LABEL^'
	RST	56
	DEFB	29
	DEFM	'LL^LL^LISA^LISA JANE^'
	RST	56
	DEFB	30
	DEFM	'ME^ME^ME^'
	RST	56
	DEFB	31
	DEFM	'DOG^DOG^DOG^LEXIA^HUNTER^'
	RST	56
	DEFB	32
	DEFM	'THERE IS A ** GOLDEN PEN ** HERE!!^** GOLDEN PEN **^PEN^GOLDEN PEN^GOLDEN^'
	RST	56
	DEFB	33
	DEFM	'THERE IS A STATUE HERE OF NICK ANDREW.^STATUE^NICK^ANDREW^NICK ANDREW^GOD^'
	RST	56
	DEFB	34
	DEFM	'THERE IS A PLACARD HERE ON THE FLOOR.^PLACARD^PLACARD^'
	DEFB	0
VERBT	RST	56
	DEFB	1
	DEFM	'GO^WALK^RUN^CRAWL^JUMP^'
	RST	56
	DEFB	2
	DEFM	'LOOK^EXAMINE^PEEK^SEE^'
	RST	56
	DEFB	3
	DEFM	'GET^PICK-UP^TAKE^STEAL^'
	RST	56
	DEFB	4
	DEFM	'DROP^LEAVE^RETURN^FORGET^'
	RST	56
	DEFB	5
	DEFM	'BREAK^SMASH^DESTROY^KILL^'
	RST	56
	DEFB	6
	DEFM	'LISTEN^HEAR^HARK^HARKEN^'
	RST	56
	DEFB	7
	DEFM	'HELP^HINT^INFO^'
	RST	56
	DEFB	8
	DEFM	'SIT^'
	RST	56
	DEFB	9
	DEFM	'SPIT^'
	RST	56
	DEFB	10
	DEFM	'QUIT^STOP^END^'
	RST	56
	DEFB	11
	DEFM	'UNLOCK^'
	RST	56
	DEFB	12
	DEFM	'LOCK^'
	RST	56
	DEFB	13
	DEFM	'WAIT^'
	RST	56
	DEFB	14
	DEFM	'SLEEP^REST^SNORE^LIE-DOWN^'
	RST	56
	DEFB	15
	DEFM	'READ^'
	RST	56
	DEFB	16
	DEFM	'BURN^LIGHT^FIRE^'
	RST	56
	DEFB	17
	DEFM	'EAT^CONSUME^'
	RST	56
	DEFB	18
	DEFM	'PHONE^TELEPHONE^RING^'
	RST	56
	DEFB	19
	DEFM	'WHY^WHY?^WHY??^'
	RST	56
	DEFB	20
	DEFM	'U^UP^'
	RST	56
	DEFB	21
	DEFM	'N^NOR^NORTH^'
	RST	56
	DEFB	22
	DEFM	'S^SOU^SOUTH^'
	RST	56
	DEFB	23
	DEFM	'E^EAS^EAST^'
	RST	56
	DEFB	24
	DEFM	'W^WES^WEST^'
	RST	56
	DEFB	25
	DEFM	'D^DOWN^'
	RST	56
	DEFB	26
	DEFM	'TRAIN^'
	RST	56
	DEFB	27
	DEFM	'INV^INVEN^INVENTORY^'
	RST	56
	DEFB	28
	DEFM	'BARK^WOOF^GROWL^'
	RST	56
	DEFB	29
	DEFM	'STATUE^'
	RST	56
	DEFB	30
	DEFM	'WINDOW^'
	RST	56
	DEFB	31
	DEFM	'OPEN^UNCORK^'
	DEFB	0
SPGOT	RST	56
	DEFB	1	;ROOM 1
	DEFB	20
	NOP
	DEFB	21
	DEFB	2
	DEFB	22
	DEFB	4
	DEFB	23
	NOP
	DEFB	24
	DEFB	6
	DEFB	25
	NOP
	DEFB	29
	DEFB	10
	RST	56
	DEFB	2	;ROOM	2
	DEFB	20
	NOP
	DEFB	21
	DEFB	3
	DEFB	22
	DEFB	1
	DEFB	23
	NOP
	DEFB	24
	NOP
	DEFB	25
	NOP
	DEFB	29
	DEFB	7
	RST	56
	DEFB	3	;ROOM 3
	DEFB	20
	NOP
	DEFB	22
	DEFB	2
	DEFB	23
	NOP
	DEFB	24
	NOP
	DEFB	25
	NOP
	RST	56
	DEFB	4	;ROOM 4
	DEFB	20
	NOP
	DEFB	21
	DEFB	1
	DEFB	22
	NOP
	DEFB	23
	NOP
	DEFB	24
	NOP
	DEFB	25
	NOP
	RST	56
	DEFB	5	;ROOM 5
	DEFB	20
	DEFB	6
	DEFB	21
	NOP
	DEFB	22
	NOP
	DEFB	23
	NOP
	DEFB	24
	NOP
	DEFB	25
	NOP
	RST	56
	DEFB	6	;ROOM 6
	DEFB	20
	NOP
	DEFB	21
	NOP
	DEFB	22
	NOP
	DEFB	23
	DEFB	1
	DEFB	24
	NOP
	DEFB	25
	DEFB	5
	DEFB	30
	DEFB	4
	RST	56
	DEFB	7	;ROOM 7
	DEFB	20
	NOP
	DEFB	21
	NOP
	DEFB	22
	NOP
	DEFB	23
	NOP
	DEFB	24
	DEFB	2
	DEFB	25
	DEFB	8
	RST	56
	DEFB	8	;ROOM 8
	DEFB	20
	DEFB	7
	DEFB	21
	NOP
	DEFB	22
	NOP
	DEFB	23
	NOP
	DEFB	24
	NOP
	DEFB	25
	DEFB	9
	RST	56
	DEFB	9	;ROOM 9
	DEFB	20
	DEFB	8
	DEFB	21
	NOP
	DEFB	22
	NOP
	DEFB	23
	NOP
	DEFB	24
	NOP
	DEFB	25
	NOP
	RST	56
	DEFB	10	;ROOM 10
	DEFB	24
	DEFB	1
	DEFB	20
	NOP
	DEFB	21
	NOP
	DEFB	22
	NOP
	DEFB	23
	NOP
	DEFB	25
	NOP
	RST	56
	DEFB	11	;ROOM 11
	DEFB	20
	NOP
	DEFB	22
	DEFB	3
	DEFB	23
	NOP
	DEFB	24
	NOP
	DEFB	25
	NOP
	NOP
OBROOM	RST	56
	DEFB	1
	DEFB	1
	RST	56
	DEFB	2
	DEFB	3
	RST	56
	DEFB	3
	DEFB	6
	RST	56
	DEFB	4
	DEFB	6
	RST	56
	DEFB	5
	DEFB	6
	RST	56
	DEFB	6
	DEFB	6
	RST	56
	DEFB	7
	DEFB	5
	RST	56
	DEFB	8
	DEFB	3
	RST	56
	DEFB	9
	DEFB	2
	RST	56
	DEFB	10
	NOP
	RST	56
	DEFB	11
	DEFB	7
	RST	56
	DEFB	12
	DEFB	8
	RST	56
	DEFB	13
	DEFB	0
	RST	56
	DEFB	14
	DEFB	9
	RST	56
	DEFB	15
	DEFB	0
	RST	56
	DEFB	16
	DEFB	11
	RST	56
	DEFB	17
	DEFB	4
	RST	56
	DEFB	18
	DEFB	0
	RST	56
	DEFB	19
	DEFB	0
	RST	56
	DEFB	20
	NOP
	RST	56
	DEFB	21
	NOP
	RST	56
	DEFB	22
	NOP
	RST	56
	DEFB	23
	NOP
	RST	56
	DEFB	24
	NOP
	RST	56
	DEFB	25
	NOP
	RST	56
	DEFB	26
	NOP
	RST	56
	DEFB	27
	NOP
	RST	56
	DEFB	28
	NOP
	RST	56
	DEFB	29
	NOP
	RST	56
	DEFB	30
	NOP
	RST	56
	DEFB	31
	NOP
	RST	56
	DEFB	32
	DEFB	5
	RST	56
	DEFB	33
	DEFB	2
	RST	56
	DEFB	34
	DEFB	11
	NOP
SPEDOT	RST	56
	DEFB	1
	DEFB	6
	DEFW	AAA1
	RST	56
	DEFB	1
	DEFB	9
	DEFW	AAB1
	RST	56
	DEFB	1
	DEFB	14
	DEFW	AAC1
	RST	56
	DEFB	2
	DEFB	6
	DEFW	AAD1
	RST	56
	DEFB	3
	DEFB	6
	DEFW	AAE1
	RST	56
	DEFB	3
	DEFB	21
	DEFW	NOPASS
	RST	56
	DEFB	4
	DEFB	14
	DEFW	AAF1
	RST	56
	DEFB	5
	DEFB	16
	DEFW	AAG1
	RST	56
	DEFB	9
	DEFB	17
	DEFW	AAH1
	RST	56
	DEFB	11
	DEFB	21
	DEFW	AAI1
	NOP
AAA1	LD	HL,AAA2
	JP	BACK
AAA2	DEFM	'I HEAR A HOARSE GUFFAW !!!^'
AAB1	LD	HL,AAB2
	JP	BACK
AAB2	DEFM	'THIS IS UTTER SACRILEGE !!!^'
AAC1	LD	HL,AAC2
	JP	BACK
AAC2	DEFM	'I CANT BECAUSE THE LAUGHTER KEEPS ME AWAKE.^'
AAD1	LD	HL,AAD2
	JP	BACK
AAD2	DEFM	'I HEAR INTENSE CHUCKLING: O SALABIM,SALABID,SALABIM...^'
AAE1	LD	HL,AAE2
	JP	BACK
AAE2	DEFM	'I HEAR FAINT BEEPING NOISES THROUGH THE DOOR.^'
AAF1	LD	HL,AAF2
	CALL	VDUOUT
	LD	A,0DH
	CALL	0033H
	JP	402DH
AAF2	DEFM	'I HAVE BEEN EATEN BY LITTLE GREEN MEN!!'
	DEFB	0DH
	DEFM	'I AM DEAD !!!!!^'
AAG1	LD	HL,AAG2
	CALL	VDUOUT
	LD	A,0DH
	CALL	0033H
	JP	402DH
AAG2	DEFM	'THE FIRE GETS OUT OF CONTROL WITH THESE PAPERS AND DESK!!!'
	DEFB	0DH
	DEFM	'I AM DEAD !!!!!!^'
AAH1	LD	HL,AAH2
	JP	BACK
AAH2	DEFM	'HIC!  HIC!  HIC!^'
AAI1	LD	HL,AAI2
	CALL	VDUOUT
	JP	402DH
AAI2	DEFM	'I AM IN A LARGE HALL. MANY PEOPLE RUSH FORWARD TO GREET ME!!!!  I HAVE WON THE ADVENTURE !!!'
	DEFB	0DH
	DEFB	'^'
COMDOT	DEFB	5
	DEFW	AA1
	DEFB	6
	DEFW	AB1
	DEFB	7
	DEFW	AC1
	DEFB	9
	DEFW	AD1
	DEFB	10
	DEFW	AE1
	DEFB	13
	DEFW	AF1
	DEFB	14
	DEFW	AG1
	DEFB	16
	DEFW	AH1
	DEFB	17
	DEFW	AI1
	DEFB	19
	DEFW	AJ1
	DEFB	26
	DEFW	AK1
	DEFB	28
	DEFW	AL1
	DEFB	8
	DEFW	AM1
	DEFB	29
	DEFW	AN1
	DEFB	30
	DEFW	AO1
	DEFB	1
	DEFW	GO1
	DEFB	2
	DEFW	LOOK1
	DEFB	3
	DEFW	GET1
	DEFB	4
	DEFW	DROP1
	DEFB	11
	DEFW	UNLOCK
	DEFB	12
	DEFW	LOCK1
	DEFB	15
	DEFW	READ1
	DEFB	18
	DEFW	PHONE1
	DEFB	27
	DEFW	INVEN1
	DEFB	31
	DEFW	OPEN1
	NOP
AA1	LD	HL,AA2
	JP	BACK
AB1	LD	HL,AB2
	JP	BACK
AC1	LD	HL,AC2
	JP	BACK
AD1	LD	HL,AD2
	JP	BACK
AE1	LD	HL,AE2
	JP	BACK
AF1	LD	HL,AF2
	JP	BACK
AG1	LD	HL,AG2
	JP	BACK
AH1	LD	HL,AH2
	JP	BACK
AI1	LD	HL,AI2
	JP	BACK
AJ1	LD	HL,AJ2
	JP	BACK
AK1	LD	HL,AK2
	JP	BACK
AL1	LD	HL,AL2
	JP	BACK
AM1	LD	HL,AM2
	JP	BACK
AN1	LD	HL,AN2
	JP	BACK
AO1	LD	HL,AO2
	JP	BACK
PHONE1	LD	HL,PHONE2
	JP	BACK
AA2	DEFM	'I HAPPEN TO LIKE IT.^'
AB2	DEFM	'I HEAR NOTHING.^'
AC2	DEFM	'PERHAPS IT WOULD BE WISE TO SAY A MAGIC WORD HERE...^'
AD2	DEFM	'THATS AN UNHEALTHY HABIT.^'
AE2	DEFM	'SORRY, YOU -->MUST<-- COMPLETE THIS.^'
AF2	DEFM	'I WAITED, BUT NOTHING HAPPENED.^'
AG2	DEFM	'I SPENT A RESTFUL NIGHT HERE, SNORING.^'
AH2	DEFM	'I TRIED, BUT THE FIRE DIDNT CATCH HOLD.^'
AI2	DEFM	'IT DIDNT TASTE NICE SO I STOPPED.^'
AJ2	DEFM	'SOMETIMES I WONDER...^'
AK2	DEFM	'HEEL/SIT/STAND/GOOD BOY!!!!^'
AL2	DEFM	'IS THAT REALLY NECESSARY??^'
AM2	DEFM	'I SAT, BUT IT DIDNT HELP MY CONSTIPATION, SO I STOOD UP AGAIN.^'
AN2	DEFM	'I CANT SEE ANY, HAVE YOU LOST ONE??^'
AO2	DEFM	'NEED SOME FRESH AIR, EH??^'
PHONE2	DEFM	'IT'
	DEFB	39
	DEFM	'S ENGAGED.^'
LOOK1	LD	A,E
	CP	0
	JR	NZ,LOOK2
	LD	HL,BEFORE
	LD	A,(ROOMIN)
	LD	C,A
	LD	B,0
	ADD	HL,BC
	LD	(HL),0
	LD	HL,(32742)
	JP	(HL)
LOOK2	CP	1
	JP	Z,BA1
	CP	2
	JP	Z,BA2
	CP	3
	JP	Z,BA3
	CP	4
	JP	Z,BA4
	CP	5
	JP	Z,BA5
	CP	6
	JP	Z,BA6
	CP	7
	JP	Z,BA7
	CP	8
	JP	Z,BA8
	CP	9
	JP	Z,BA9
	CP	10
	JP	Z,BA10
	CP	11
	JP	Z,BA11
	CP	12
	JP	Z,BA12
	CP	13
	JP	Z,BA13
	CP	14
	JP	Z,BA14
	CP	15
	JP	Z,BA15
	CP	16
	JP	Z,BA16
	CP	17
	JP	Z,BA17
	CP	18
	JP	Z,BA18
	CP	19
	JP	Z,BA19
	CP	20
	JP	Z,BA20
	CP	21
	JP	Z,BA21
	CP	22
	JP	Z,BA22
	CP	23
	JP	Z,BA23
	CP	24
	JP	Z,BA24
	CP	25
	JP	Z,BA25
	CP	26
	JP	Z,BA26
	CP	27
	JP	Z,BA27
	CP	28
	JP	Z,BA28
	CP	29
	JP	Z,BA29
	CP	30
	JP	Z,BA30
	CP	31
	JP	Z,BA31
	CP	32
	JP	Z,BA32
	CP	33
	JP	Z,BA33
	JP	BA34
RETURN	JP	BACK
BA1	LD	HL,BB1
	JP	RETURN
BA2	LD	HL,BB2
	JP	RETURN
BA3	LD	HL,BB3
	JP	RETURN
BA4	LD	HL,BB4
	JP	RETURN
BA5	LD	HL,BB5
	JP	RETURN
BA6	LD	HL,BB6
	JP	RETURN
BA7	LD	HL,BB7
	JP	RETURN
BA8	LD	HL,BB8
	JP	RETURN
BA9	LD	HL,BB9
	JP	RETURN
BA10	LD	HL,BB10
	JP	RETURN
BA11	LD	HL,BB11
	JP	RETURN
BA12	LD	HL,BB12
	JP	RETURN
BA13	LD	HL,BB13
	JP	RETURN
BA14	LD	HL,BB14
	JP	RETURN
BA15	LD	HL,BB15
	JP	RETURN
BA16	LD	HL,BB16
	JP	RETURN
BA17	LD	HL,BB17
	JP	RETURN
BA18	LD	HL,BB18
	JP	RETURN
BA19	LD	HL,BB19
	JP	RETURN
BA20	LD	HL,BB20
	CALL	VDUOUT
	LD	A,0DH
	CALL	0033H
	JP	402DH
BA21	LD	HL,BB21
	JP	RETURN
BA22	LD	HL,BB22
	JP	RETURN
BA23	LD	HL,BB23
	JP	RETURN
BA24	LD	HL,BB24
	JP	RETURN
BA25	LD	HL,BB25
	JP	RETURN
BA26	LD	HL,BB26
	JP	RETURN
BA27	LD	HL,BB27
	JP	RETURN
BA28	LD	HL,BB28
	JP	RETURN
BA29	LD	HL,BB29
	JP	RETURN
BA30	LD	HL,BB30
	JP	RETURN
BA31	LD	HL,BB31
	JP	RETURN
BA32	LD	HL,BB32
	JP	RETURN
BA33	LD	HL,BB33
	JP	RETURN
BA34	LD	HL,BB34
	JP	RETURN
BB1	DEFM	'WILLIE SMILES AT ME BENEVOLENTLY.^'
BB2	DEFM	'ITS A LARGE DOOR.^'
BB3	DEFM	'ITS VANDALISED.^'
BB4	DEFM	'I THINK THE DESK IS MADE OF MAHOGANY.^'
BB5	DEFM	'I SEE SOMETHING!!!!!^'
BB6	DEFM	'ITS A SWIVEL CHAIR.^'
BB7	DEFM	'THEY SAY: "THESE PAPERS WILL SELF-DESTRUCT IN 10 SECONDS." SIGNED NICK, CHIEF ADVENTURER HERE.^'
BB8	DEFM	'THERES SOMETHING WRITTEN ON IT!^'
BB9	DEFM	'THERES SOMETHING WRITTEN THERE!^'
BB10	DEFM	'ITS RUN-DOWN AND VERY DISUSED.^'
BB11	DEFM	'THEY LOOK QUITE DISUSED.^'
BB12	DEFM	'I TRY, BUT THE COBWEBS STICK TO MY FINGERS.^'
BB13	DEFM	'ITS FULL OF WINE RACKS.^'
BB14	DEFM	'THERE IS SOMETHING WRITTEN ON THE LABEL.^'
BB15	DEFM	'ONE END IS DIRTY,DUSTY AND DRY, THE OTHER END IS JUST DRY.^'
BB16	DEFM	'IT IS A SYSTEM-80 WITH A DISK DRIVE ATTACHED.^'
BB17	DEFM	'THE CUBE HAS ALL ITS COLOURS MIXED.^'
BB18	DEFM	'THERES SOMETHING WRITTEN ON IT!^'
BB19	DEFM	'IT IS A LOCKWOOD KEY, MADE IN AUSTRALIA.^'
BB20	DEFM	'THE CEILING FALLS ON YOU!!!'
	DEFB	0DH
	DEFM	'YOU ARE DEAD !!!!'
	DEFB	0DH
	DEFB	'^'
BB21	DEFM	'MAYBE I SHOULD GO THERE...^'
BB22	DEFM	'MAYBE I SHOULD GO THERE...^'
BB23	DEFM	'MAYBE I SHOULD GO THERE...^'
BB24	DEFM	'MAYBE I SHOULD GO THERE...^'
BB25	DEFM	'MAYBE I SHOULD GO THERE...^'
BB26	DEFM	'I LIKE IT.^'
BB27	DEFM	'ITS BLEAK AND ALIEN.^'
BB28	DEFM	'THERE IS SOMETHING WRITTEN ON IT...^'
BB29	DEFM	'HI THERE.^'
BB30	DEFM	'I AM PRETTY UGLY.^'
BB31	DEFM	'IT IS LICKING MY FEET. YUCK!!^'
BB32	DEFM	'THE INSCRIPTION SAYS: "CONGRATULATIONS!!".^'
BB33	DEFM	'NICK IS CHORTLING AWAY TO HIMSELF.^'
BB34	DEFM	'THERE IS SOMETHING WRITTEN THERE..^'
GO1	LD	HL,SPGOT
ABBA	LD	A,(HL)
	OR	A
	JR	Z,ABBE
	CP	255
	JR	Z,ABBC
	CP	E
	JR	NZ,ABBB
	INC	HL
	LD	A,(HL)
	OR	A
	JR	NZ,ABBF
ABBE	LD	HL,NOWAY
	JP	RETURN
NOWAY	DEFM	'THERE IS NO WAY TO GO THERE.^'
ABBF	LD	(ROOMIN),A
	LD	HL,(32742)
	JP	(HL)
ABBB	INC	HL
	INC	HL
	JR	ABBA
ABBC	INC	HL
	LD	A,(ROOMIN)
	CP	(HL)
	JR	NZ,ABBD
	INC	HL
	JR	ABBA
ABBD	INC	HL
ABBG	INC	HL
	INC	HL
	LD	A,(HL)
	OR	A
	JR	Z,ABBE
	CP	255
	JR	NZ,ABBG	
	JR	ABBC
;END OF GO1 ALL O.K.
CARRY	DEFM	'I AM CARRYING THE FOLLOWING:^'
INVEN1	LD	HL,CARRY
	CALL	VDUOUT
	LD	A,0DH
	CALL	0033H
	LD	HL,32759
LOOKLP	INC	HL
	LD	A,L
	CP	254
	JR	Z,FINIT
	LD	A,(HL)
	OR	A
	JR	Z,LOOKLP
	PUSH	HL
	CALL	DISPOB
	POP	HL
	JR	LOOKLP
FINIT	LD	A,0DH
	CALL	0033H
	LD	HL,(32742)
	JP	(HL)
DISPOB	LD	HL,OBTABL
	LD	D,A
	DEC	HL
GOLOOP	INC	HL
	LD	A,(HL)
	OR	A
	JR	Z,ERROR
	CP	255
	JR	NZ,GOLOOP
	INC	HL
	LD	A,(HL)
	CP	D
	JR	NZ,GOLOOP
BYPASS	LD	A,(HL)
	INC	HL
	CP	'^'
	JR	NZ,BYPASS
	CALL	VDUOUT
	LD	A,0DH
	CALL	0033H
	RET
ERROR	LD	HL,ERROBJ
	POP	IX
	CALL	VDUOUT
	JP	402DH
ERROBJ	DEFM	'ERROR FOUND IN OBJECT TABLE ACCESS: DISPOB INVENTORY.^'
READ1	LD	A,E
	CP	0
	JR	NZ,READ2
	LD	HL,NOREAD
	JP	RETURN
NOREAD	DEFM	'READ WHAT???^'
READ2	CP	8
	JR	Z,SIGN1
	CP	9
	JR	Z,PLAQU1
	CP	18
	JP	Z,PAPER1
	CP	28
	JP	Z,LABLE1
	CP	34
	JP	Z,PLCRD1
	LD	HL,BLOODY
	JP	RETURN
BLOODY	DEFM	'WHY DON'
	DEFB	39
	DEFM	'T YOU JUST LOOK AT THE BLOODY THING!^'
SIGN1	LD	HL,SIGN2
	JP	RETURN
SIGN2	DEFM	'AUTHORISED PERSONNEL ONLY ADMITTED.^'
PLAQU1	LD	HL,PLAQU2
	JP	RETURN
PLAQU2	DEFM	'----------------------------'
	DEFB	0DH
	DEFM	'I ADVENTURERS HALL OF FAME I'
	DEFB	0DH
	DEFM	'----------------------------^'
PAPER1	LD	HL,PAPER2
	JP	RETURN
PAPER2	DEFM	'=*=*=*=*=*=*=*=*='
	DEFB	0DH
	DEFM	'* DON'
	DEFB	39
	DEFM	'T LOOK UP *
	DEFB	0DH
	DEFM	'=*=*=*=*=*=*=*=*=^'
LABLE1	LD	HL,LABLE2
	JP	RETURN
LABLE2	DEFM	'IT IS FULL OF VODKA.^'
PLCRD1	LD	HL,PLCRD2
	JP	RETURN
PLCRD2	DEFM	'=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*='
	DEFB	0DH
	DEFM	'>GO NORTH TO COMPLETE THIS ADVENTURE<
	DEFB	0DH
	DEFM	'=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=^'
OPEN1	LD	A,E
	OR	A
	JR	NZ,NOWHAT
	LD	HL,OPWHAT
	JP	RETURN
OPWHAT	DEFM	'OPEN WHAT??^'
NOWHAT	CP	14
	JR	Z,BOTLE
	LD	HL,NOTOPN
	JP	RETURN
NOTOPN	DEFM	'THERE IS NO WAY THAT I CAN OPEN THAT.^'
BOTLE	LD	HL,OBROOM
SRCH	LD	A,(HL)
	OR	A
	JR	NZ,NERROR
ERRBRM	LD	HL,ERRBR
	JP	RETURN
ERRBR	DEFM	'ERROR FOUND IN OBROOM ACCESSING...^'
NERROR	INC	HL
	LD	A,(HL)
	CP	15
	JR	Z,CORKY
	INC	HL
	INC	HL
	JR	SRCH
CORKY	INC	HL
	LD	A,(HL)
	OR	A
	JR	NZ,ALOPEN
	LD	HL,32759
SRCH2	INC	HL
	LD	A,L
	CP	254
	JR	Z,SRCH3
	LD	A,(HL)
	CP	15
	JR	NZ,SRCH2
ALOPEN	LD	HL,OP
	JP	RETURN
OP	DEFM	'THE BOTTLE IS ALREADY OPEN !!^'
SRCH3	LD	HL,OBROOM
GOGO	LD	A,(HL)
	OR	A
	JR	Z,ERRBRM
	INC	HL
	LD	A,(HL)
	CP	14
	JR	Z,BIP
	INC	HL
	INC	HL
	JR	GOGO
BIP	INC	HL
	LD	A,(HL)
	OR	A
	JR	Z,ALLOK
	LD	D,A
	LD	A,(ROOMIN)
	CP	D
	JR	Z,ALLOK
	LD	HL,NOFIND
	JP	RETURN
NOFIND	DEFM	'I CANNOT FIND THE BOTTLE.^'
ALLOK	LD	HL,OKOK
	CALL	VDUOUT
	LD	A,0DH
	CALL	0033H
	LD	A,15
	CALL	CREATE
	LD	A,18
	CALL	CREATE
	LD	A,19
	CALL	CREATE
	LD	HL,(32742)
	JP	(HL)
OKOK	DEFM	'I PULLED THE CORK FROM THE BOTTLE.'
	DEFB	0DH
	DEFM	'A PIECE OF PARCHMENT FELL OUT.'
	DEFB	0DH
	DEFM	'A KEY FELL OUT.'
	DEFB	0DH
	DEFM	'AND THE CORK FELL OUT.^'
CREATE	LD	D,A
SRCH4	LD	HL,OBROOM
QRP	LD	A,(HL)
	OR	A
	JR	NZ,NERRC
ERRC	LD	HL,ERRCD
	POP	IX
	JP	RETURN
ERRCD	DEFM	'ERROR FOUND IN CREATE...^'
NERRC	INC	HL
	LD	A,(HL)
	CP	D
	JR	Z,BYPE
	INC	HL
	INC	HL
	JR	QRP
BYPE	INC	HL
	LD	A,(HL)
	OR	A
	JR	Z,OKSOFR
EXISTS	LD	HL,EXIST
	POP	IX
	JP	RETURN
EXIST	DEFM	'REFERENCED OBJECT ALREADY EXISTS.^'
OKSOFR	LD	A,(ROOMIN)
	LD	(HL),A
	RET
DROP1	LD	A,E
	OR	A
	JR	NZ,DRP1
	LD	HL,DRPWHT
	JP	RETURN
DRPWHT	DEFM	'DROP WHAT??^'
DRP1	LD	HL,32759
SRCH5	INC	HL
	LD	A,L
	CP	254
	JR	Z,YGOTIT
	LD	A,(HL)
	CP	E
	JR	NZ,SRCH5
	LD	(HL),0
	LD	A,E
	CALL	CREATE
	LD	HL,(32742)
	JP	(HL)
YGOTIT	LD	HL,CARYIN
	JP	RETURN
CARYIN	DEFM	'I AM NOT CARRYING IT!^'
GET1	LD	A,E
	OR	A
	JR	NZ,DGNBT1
	LD	HL,GTWHT
	JP	RETURN
GTWHT	DEFM	'GET WHAT??^'
DGNBT1	LD	HL,32759
ZAA	INC	HL
	LD	A,L
	CP	254
	JR	Z,ZAB
	LD	A,(HL)
	CP	E
	JR	NZ,ZAA
	LD	HL,ALCARR
	JP	RETURN
ALCARR	DEFM	'I AM ALREADY CARRYING IT !!^'
ZAB	LD	HL,OBROOM
ZAC	LD	A,(HL)
	OR	A
	JP	Z,ERRBRM
	INC	HL
	LD	A,(HL)
	CP	E
	JR	Z,ZAD
	INC	HL
	INC	HL
	JR	ZAC
ZAD	INC	HL
	LD	D,(HL)
	LD	A,(ROOMIN)
	CP	D
	JR	Z,ZAE
	LD	HL,CANFIN
	JP	RETURN
CANFIN	DEFM	'I CANNOT FIND IT !!^'
ZAE	LD	A,E
	CP	3
	JR	Z,LOK
	CP	7
	JR	Z,LOK
	CP	12
	JR	Z,LOK
	CP	14
	JR	Z,LOK
	CP	15
	JR	Z,LOK
	CP	16
	JR	Z,LOK
	CP	17
	JR	Z,LOK
	CP	18
	JR	Z,LOK
	CP	19
	JR	Z,LOK
	CP	32
	JR	Z,LOK
	LD	HL,UNABL
	JP	RETURN
UNABL	DEFM	'I AM UNABLE TO MOVE THAT OBJECT.^'
LOK	LD	HL,32759
ZAF	INC	HL
	LD	A,L
	CP	254
	JR	Z,OVALOD
	LD	A,(HL)
	OR	A
	JR	NZ,ZAF
	LD	(HL),E
	LD	HL,OBROOM
ZAG	LD	A,(HL)
	OR	A
	JR	Z,TERROR
	INC	HL
	LD	A,(HL)
	CP	E
	JR	Z,ZAH
	INC	HL
	INC	HL
	JR	ZAG
ZAH	INC	HL
	LD	(HL),0
	LD	HL,(32742)
	JP	(HL)
TERROR	LD	HL,TERRM
	JP	RETURN
TERRM	DEFM	'ERROR IN OBROOM>GET>KILL ACCESS...^'
OVALOD	LD	HL,LOADED
	JP	RETURN
LOADED	DEFM	'I AM OVERLOADED.'
	DEFB	0DH
	DEFM	'I WILL HAVE TO DROP SOMETHING FIRST.^'
NOPASS	LD	A,(32741)
	OR	A
	JR	NZ,PYES
	LD	HL,PASSNO
	JP	RETURN
PASSNO	DEFM	'THE DOOR IS LOCKED. YOU MAY NOT PASS.^'
PYES	LD	A,11
	LD	(ROOMIN),A
	LD	HL,PAYES
	JP	RETURN
PAYES	DEFM	'THE DOOR IS UNLOCKED. YOU MAY PASS.^'
LOCK1	LD	A,(ROOMIN)
	CP	3
	JR	Z,ZBA
	LD	HL,NOTH
	JP	RETURN
NOTH	DEFM	'THERE IS NOTHING HERE FOR ME TO LOCK.^'
ZBA	LD	HL,32759
ZBB	INC	HL
	LD	A,L
	CP	254
	JR	NZ,ZBC
	LD	HL,NOTLOK
	JP	RETURN
NOTLOK	DEFM	'I HAVE NOTHING WITH WHICH TO LOCK IT!^'
ZBC	LD	A,(HL)
	CP	19
	JR	NZ,ZBB
	LD	A,0
	LD	(32741),A
	LD	HL,NOWLOK
	JP	RETURN
NOWLOK	DEFM	'THE DOOR IS NOW LOCKED.^'
UNLOCK	LD	A,(ROOMIN)
	CP	3
	JR	Z,ZCA
	LD	HL,NOTHUN
	JP	RETURN
NOTHUN	DEFM	'THERE IS NOTHING HERE FOR ME TO UNLOCK.^'
ZCA	LD	HL,32759
ZCB	INC	HL
	LD	A,L
	CP	254
	JR	NZ,ZCC
	LD	HL,NOTUNL
	JP	RETURN
NOTUNL	DEFM	'YOU HAVE NOTHING WITH WHICH TO UNLOCK THE DOOR.^'
ZCC	LD	A,(HL)
	CP	19
	JR	NZ,ZCB
	LD	A,255
	LD	(32741),A
	LD	HL,NOWUNL
	JP	RETURN
NOWUNL	DEFM	'THE DOOR IS NOW UNLOCKED.^'
	END	8000H
