;Game source code.
; 13-Dec-84.
;
	ORG	5200H
;
	DEFS	0FFH	;stack area
_STACK	NOP
;
*GET	EQUATES:1
*GET	OPTIONS:1
*GET	DATA:1
*GET	WAVEDATA:1
START
	LD	SP,_STACK
	CALL	INIT
X_1	CALL	TITLES
	CALL	PLAY_GAME
	JR	X_1
;
TITLES
	CALL	CLS
	LD	HL,TITLE_1
	CALL	MOVE_TITLE
X_2	CALL	002BH
	CP	'S'
	RET	Z
	CP	'Q'
	JP	Z,402DH
	CP	'q'
	JP	Z,402DH
	CP	's'
	JR	NZ,X_2
	RET
;
CLS	LD	HL,3C00H
	LD	DE,3C01H
	LD	(HL),80H
	LD	BC,03FFH
	LDIR
	RET
;
MOVE_TITLE
	LD	C,(HL)
	INC	HL
	LD	B,(HL)
	INC	HL
	LD	DE,3C00H
	LDIR
	RET
;
INIT
	RET
;
PLAY_GAME
	CALL	GAME_INIT
G_1	CALL	GAME_LOOP
	LD	A,(MEN_LEFT)
	OR	A
	JR	NZ,G_1
GAME_OVER
	RET
;
GAME_INIT
	LD	A,MAX_MEN
	LD	(MEN_LEFT),A
	XOR	A
	LD	(_COUNTER),A
	LD	(NUM_ALIEN),A
	LD	(SHOT_FIRED),A
	LD	HL,S_VDU
	LD	DE,S_VDU+1
	LD	(HL),80H
	LD	BC,03FFH
	LDIR
	CALL	CLR_GRX_2
	LD	A,START_POSN
	LD	(MAN_POSN),A
	LD	HL,SCORE
	LD	B,5
GI_1	LD	(HL),'0'
	INC	HL
	DJNZ	GI_1
	LD	HL,LOOP_STK
	LD	(LOOP_PTR),HL
	LD	HL,WAVES
	LD	(WAVE_PC),HL
	XOR	A
	LD	(WAVE_CTR),A
	LD	HL,0
	LD	(WAVE_DELAY),HL
	LD	HL,AL_TAB
	LD	B,MAX_ALIEN
	LD	DE,5
GI_2	LD	(HL),0
	ADD	HL,DE
	DJNZ	GI_2
	CALL	NOSHOTS
	LD	A,1
	LD	(ALIEN_NO),A
	RET
;
GAME_LOOP
	CALL	EXEC_COMM
	CALL	MOVE_ALIEN_2
	CALL	MOVE_MAN
	XOR	A
	LD	(DEAD),A
	CALL	CHKD_MAN
	CALL	CHKD_ALIEN
	CALL	MOVE_SHOTS
	CALL	ALIEN_SHOTS
	CALL	CHKD_MAN
	CALL	CHKD_ALIEN
	CALL	UPDATE_ALL
	LD	A,(DEAD)
	OR	A
	RET	Z
	LD	A,(MEN_LEFT)
	DEC	A
	LD	(MEN_LEFT),A
	LD	BC,0
	CALL	60H
	RET
;
UPDATE_ALL
	CALL	CLR_GRX_2
	CALL	DRAW_ALIEN_2
	CALL	DRAW_MAN_3
	CALL	DRAW_SHOTS_2
	CALL	DRAW_BOMBS
	CALL	DRAW_TEXT
	CALL	UPDATE_VDU_2
	RET
;
GAME_DELAY
	PUSH	BC
	PUSH	AF
	LD	BC,0001H
	CALL	60H
	POP	AF
	POP	BC
	RET
;
MOVE_MAN
	LD	A,(ROW_6)
	AND	60H
	RET	Z
	LD	(_TEMPB),A
	CP	60H
	RET	Z
	OR	A
	RET	Z
	CP	20H
	CALL	Z,MOVE_LEFT
	LD	A,(_TEMPB)
	CP	40H
	CALL	Z,MOVE_RIGHT
	RET
;
MOVE_LEFT
	LD	A,(MAN_POSN)
	DEC	A
	DEC	A
	CP	MIN_POSN
	RET	C
	CP	MAX_POSN+1
	RET	NC
	LD	(MAN_POSN),A
	RET
;
MOVE_RIGHT
	LD	A,(MAN_POSN)
	INC	A
	INC	A
	CP	MAX_POSN+1
	RET	NC
	LD	(MAN_POSN),A
	RET
;
;******
MOVE_ALIEN_2
	LD	HL,AL_TAB
	LD	B,MAX_ALIEN
	LD	C,0
MA_LOOP	PUSH	BC
	LD	A,C
	LD	(ALIEN),A
	LD	A,(HL)
	PUSH	HL
	OR	A
	CALL	NZ,MOVE_ONE
	POP	HL
	LD	DE,5
	ADD	HL,DE
	POP	BC
	INC	C
	DJNZ	MA_LOOP
	RET
;
MOVE_ONE
	AND	1
	RET	Z
	LD	(_TABST),HL
EXECUT	INC	HL
	INC	HL
	INC	HL
	LD	E,(HL)
	INC	HL
	LD	D,(HL)
	LD	(_TABEND),HL
	LD	A,(DE)
	CP	20
	RET	NC
	ADD	A,A
	PUSH	DE
	PUSH	HL
	LD	E,A
	LD	D,0
	LD	HL,I_TABLE
	ADD	HL,DE
	LD	E,(HL)
	INC	HL
	LD	D,(HL)
	POP	HL
	PUSH	DE
	POP	IX
	POP	DE
	JP	(IX)
;
I_TABLE	DEFW	I_DISAP,I_GOTO,I_UP,I_DOWN,I_LEFT
	DEFW	I_RIGHT,I_INV,I_VIS,I_JUMP,I_REPT
	DEFW	I_ENDR,I_CALL,I_RETN,I_RNDJP,I_NULL
	DEFW	I_REPTD,I_ENDRD,I_CALLD,I_RETND,I_SYNC
;
I_DISAP	LD	HL,(_TABST)
	XOR	A
	LD	(HL),A
	LD	A,(ALIEN)
	LD	C,A
	CALL	RELS_LOOPS
	RET
;
I_GOTO	INC	DE
	LD	HL,(_TABST)
	INC	HL
	LD	A,(DE)
	LD	(HL),A
	INC	DE
	INC	HL
	LD	A,(DE)
	LD	(HL),A
	INC	DE
	INC	HL
	LD	(HL),E
	INC	HL
	LD	(HL),D
	RET
;
I_UP	INC	DE
	LD	(HL),D
	DEC	HL
	LD	(HL),E
	DEC	HL
	DEC	(HL)
	RET
;
I_DOWN	INC	DE
	LD	(HL),D
	DEC	HL
	LD	(HL),E
	DEC	HL
	INC	(HL)
	RET
;
I_LEFT	INC	DE
	LD	(HL),D
	DEC	HL
	LD	(HL),E
	DEC	HL
	DEC	HL
	DEC	(HL)
	DEC	(HL)
	RET
;
I_RIGHT	INC	DE
	LD	(HL),D
	DEC	HL
	LD	(HL),E
	DEC	HL
	DEC	HL
	INC	(HL)
	INC	(HL)
	RET
;
I_INV
	RET
I_VIS
	RET
;
I_JUMP	INC	DE
	LD	A,(DE)
	DEC	HL
	LD	(HL),A
	INC	DE
	INC	HL
	LD	A,(DE)
	LD	(HL),A
	LD	HL,(_TABST)
	JP	EXECUT
;
I_REPT	INC	DE
	LD	A,(DE)
	INC	DE
	LD	(DE),A
	INC	DE
	LD	(HL),D
	DEC	HL
	LD	(HL),E
	LD	HL,(_TABST)
	JP	EXECUT
;
I_ENDR	INC	DE
	INC	DE
	INC	DE
	LD	(HL),D
	DEC	HL
	LD	(HL),E
	DEC	DE
	EX	DE,HL
	LD	B,(HL)
	DEC	HL
	LD	C,(HL)
	INC	BC
	INC	BC
	LD	A,(BC)
	DEC	A
	LD	(BC),A
	LD	HL,(_TABST)
	JP	Z,EXECUT
	PUSH	BC
	POP	HL
	EX	DE,HL
	INC	DE
	LD	(HL),E
	INC	HL
	LD	(HL),D
	LD	HL,(_TABST)
	JP	EXECUT
;
I_CALL	INC	DE
	EX	DE,HL
	LD	C,(HL)
	INC	HL
	LD	B,(HL)
	INC	HL
	LD	A,H
	LD	(BC),A
	INC	BC
	LD	A,L
	LD	(BC),A
	INC	BC
	EX	DE,HL
	LD	(HL),B
	DEC	HL
	LD	(HL),C
	LD	HL,(_TABST)
	JP	EXECUT
;
I_RETN	INC	DE
	EX	DE,HL
	LD	C,(HL)
	INC	HL
	LD	B,(HL)
	PUSH	BC
	POP	HL
	INC	HL
	LD	A,(HL)
	LD	(DE),A
	DEC	HL
	DEC	DE
	LD	A,(HL)
	LD	(DE),A
	LD	HL,(_TABST)
	JP	EXECUT
;
I_RNDJP	JP	I_DISAP
;
I_NULL	INC	DE
	LD	(HL),D
	DEC	HL
	LD	(HL),E
	RET
;
I_REPTD	INC	DE
	INC	DE
	LD	(HL),D
	DEC	HL
	LD	(HL),E
	LD	HL,(LOOP_PTR)
	LD	A,(ALIEN)
	LD	(HL),A
	INC	HL
	DEC	DE
	DEC	DE
	LD	(HL),E
	INC	HL
	LD	(HL),D
	INC	HL
	INC	DE
	LD	A,(DE)
	LD	(HL),A
	INC	HL
	LD	(LOOP_PTR),HL
	LD	HL,(_TABST)
	JP	EXECUT
;
I_ENDRD	INC	DE
	EX	DE,HL
	LD	(_INSADDR),HL
	LD	HL,LOOP_STK
I_E_1	CALL	CP_END_L
	JP	Z,ERROR
	PUSH	HL
	CALL	CK_1_L
	POP	HL
	JR	Z,I_E_2
	LD	DE,4
	ADD	HL,DE
	JR	I_E_1
I_E_2	INC	HL
	INC	HL
	INC	HL
	DEC	(HL)
	JR	Z,I_E_3
	LD	HL,(_INSADDR)
	LD	E,(HL)
	INC	HL
	LD	D,(HL)
	INC	DE
	INC	DE
	LD	HL,(_TABEND)
	LD	(HL),D
	DEC	HL
	LD	(HL),E
	LD	HL,(_TABST)
	JP	EXECUT
I_E_3	CALL	MV_STK_L
	LD	HL,(_INSADDR)
	INC	HL
	INC	HL
	EX	DE,HL
	LD	HL,(_TABEND)
	LD	(HL),D
	DEC	HL
	LD	(HL),E
	LD	HL,(_TABST)
	JP	EXECUT
;
CK_1_L	LD	A,(ALIEN)
	CP	(HL)
	RET	NZ
	INC	HL
	EX	DE,HL
	LD	HL,(_INSADDR)
	LD	A,(DE)
	CP	(HL)
	RET	NZ
	INC	DE
	INC	HL
	LD	A,(DE)
	CP	(HL)
	RET
;
ERROR	JP	402DH
;
CP_END_L
	EX	DE,HL
	LD	HL,(LOOP_PTR)
	EX	DE,HL
	LD	A,H
	CP	D
	RET	NZ
	LD	A,L
	CP	E
	RET
;
MV_STK_L
	INC	HL
	PUSH	HL
	LD	D,H
	LD	E,L
	DEC	HL
	DEC	HL
	DEC	HL
	DEC	HL
	PUSH	HL
	LD	HL,(LOOP_PTR)
	OR	A
	SBC	HL,DE
	LD	A,H
	OR	L
	JR	NZ,MSL_1
	POP	AF
	POP	AF
	JR	MSL_2
MSL_1	PUSH	HL
	POP	BC
	POP	DE
	POP	HL
	LDIR
MSL_2	LD	HL,(LOOP_PTR)
	LD	DE,-4
	ADD	HL,DE
	LD	(LOOP_PTR),HL
	RET
;
I_CALLD	RET
I_RETND	RET
;
;
DRAW_ALIEN_2
	LD	HL,AL_TAB
	LD	B,MAX_ALIEN
UP_LOOP	PUSH	BC
	PUSH	HL
	LD	A,(HL)
	OR	A
	CALL	NZ,DRAW_ONE_2
	POP	HL
	LD	DE,5
	ADD	HL,DE
	POP	BC
	DJNZ	UP_LOOP
	RET
;
CLR_GRX_2
	LD	HL,S_GRX
	LD	C,5
	LD	B,128
	LD	A,80H
CG_1	LD	(HL),A
	INC	HL
	DJNZ	CG_1
	DEC	C
	JR	NZ,CG_1
	RET
;
MOVE_SHOTS
	LD	A,(SHOT_FIRED)
	OR	A
	JR	NZ,MV_SHOT
	LD	A,(ROW_6)
	AND	80H
	RET	Z
	LD	A,1
	LD	(SHOT_FIRED),A
	LD	A,(MAN_POSN)
	LD	(SHOT_X),A
	LD	A,44
	LD	(SHOT_Y),A
	RET
MV_SHOT
	LD	A,(SHOT_Y)
	DEC	A
	DEC	A
	LD	(SHOT_Y),A
	CP	WIDTH_Y
	RET	C
	XOR	A
	LD	(SHOT_FIRED),A
	RET
;
CHKD_MAN
	CALL	CHK_COLLIDE
	CALL	CHK_BOMBED
	RET
;
CHK_COLLIDE
	LD	HL,AL_TAB
	LD	B,MAX_ALIEN
	LD	C,0
CM_1	PUSH	BC
	LD	A,(HL)
	PUSH	HL
	AND	1
	CALL	NZ,CM_ONE
	POP	HL
	LD	DE,5
	ADD	HL,DE
	POP	BC
	INC	C
	DJNZ	CM_1
	RET
CM_ONE	INC	HL
	INC	HL
	LD	A,(HL)
	SUB	43
	RET	C
	CP	5
	RET	NC
	DEC	HL
	LD	A,(MAN_POSN)
	LD	B,A
	LD	A,(HL)
	ADD	A,3
	SUB	B
	RET	C
	CP	7
	RET	NC
MAN_DEAD
	LD	A,1
	LD	(DEAD),A
	DEC	HL
	LD	(HL),0
	CALL	RELS_LOOPS
	LD	A,(NUM_ALIEN)
	DEC	A
	LD	(NUM_ALIEN),A
	RET
;
CHKD_ALIEN
	LD	A,(SHOT_FIRED)
	OR	A
	RET	Z
	LD	A,(SHOT_X)
	LD	D,A
	LD	A,(SHOT_Y)
	LD	E,A
	LD	HL,AL_TAB
	LD	B,MAX_ALIEN
	LD	C,0
CA_1	PUSH	BC
	LD	A,(HL)
	PUSH	HL
	AND	1
	CALL	NZ,CA_ONE
	POP	HL
	LD	BC,5
	ADD	HL,BC
	POP	BC
	INC	C
	DJNZ	CA_1
	RET
CA_ONE	INC	HL
	INC	HL
	LD	A,(SHOT_FIRED)
	OR	A
	RET	Z
	LD	A,E
	SUB	(HL)
	RET	C
	CP	3
	RET	NC
	DEC	HL
	LD	A,D
	ADD	A,2
	SUB	(HL)
	RET	C
	CP	5
	RET	NC
AL_DEAD	DEC	HL
	LD	(HL),0
	CALL	RELS_LOOPS
	XOR	A
	LD	(SHOT_FIRED),A
	LD	HL,POINTS
	CALL	ADD_SCORE
	LD	A,(NUM_ALIEN)
	DEC	A
	LD	(NUM_ALIEN),A
	RET
;
ALIEN_SHOTS
	LD	HL,AL_SHOT
	LD	DE,AL_TAB
	LD	B,MAX_ALIEN
AS_1	PUSH	BC
	PUSH	DE
	PUSH	HL
	CALL	M1SHOT
	POP	HL
	LD	DE,3
	ADD	HL,DE
	POP	DE
	PUSH	HL
	LD	HL,5
	ADD	HL,DE
	EX	DE,HL
	POP	HL
	POP	BC
	DJNZ	AS_1
	RET
;
M1SHOT	LD	A,(HL)
	OR	A
	JR	NZ,SHOT_ACTIVE
	LD	A,(DE)
	AND	1
	RET	Z
	LD	A,R
	AND	1FH
	CP	3
	RET	NC
	LD	(HL),1
	INC	DE
	INC	HL
	LD	A,(DE)
	LD	(HL),A
	INC	DE
	INC	HL
	LD	A,(DE)
	INC	A
	LD	(HL),A
	CP	WIDTH_Y-1
	RET	C
	DEC	HL
	DEC	HL
	LD	(HL),0
	RET
;
SHOT_ACTIVE
	INC	HL
	INC	HL
	LD	A,(HL)
	INC	A
	LD	(HL),A
	CP	WIDTH_Y-1
	RET	C
	DEC	HL
	DEC	HL
	LD	(HL),0
	RET
;
DRAW_BOMBS
	LD	HL,AL_SHOT
	LD	B,MAX_ALIEN
DB_1	PUSH	BC
	PUSH	HL
	LD	A,(HL)
	AND	1
	CALL	NZ,DRAW_1_BOMB_2
	POP	HL
	LD	DE,3
	ADD	HL,DE
	POP	BC
	DJNZ	DB_1
	RET
;
CHK_BOMBED	LD	A,(DEAD)
	OR	A
	RET	NZ
	LD	HL,AL_SHOT
	LD	B,MAX_ALIEN
CB_1	PUSH	BC
	PUSH	HL
	LD	A,(HL)
	OR	A
	CALL	NZ,CB_ONE
	POP	HL
	LD	BC,3
	ADD	HL,BC
	POP	BC
	DJNZ	CB_1
	RET
;
CB_ONE	INC	HL
	INC	HL
	LD	A,(HL)
	SUB	43
	RET	C
	CP	4
	RET	NC
	DEC	HL
	LD	A,(MAN_POSN)
	LD	B,A
	LD	A,(HL)
	ADD	A,3
	SUB	B
	RET	C
	CP	7
	RET	NC
CB_DEAD	LD	A,1
	LD	(DEAD),A
	DEC	HL
	LD	(HL),0
	RET
;
DRAW_TEXT
	LD	DE,S_GRX
	LD	HL,MEN_MESS
	LD	BC,5
	LDIR
	EX	DE,HL
	LD	A,(MEN_LEFT)
	CALL	BYTE_DEC
	LD	HL,SCORE
	LD	DE,S_GRX+29
	LD	BC,5
	LDIR
	RET
;
MEN_MESS	DEFM	'Men: '
;
;
ADD_SCORE
	LD	DE,4
	ADD	HL,DE
	LD	DE,SCORE+4
	LD	B,5
AS2_1	PUSH	BC
	LD	A,(DE)
	ADD	A,(HL)
	SUB	30H
	LD	(DE),A
	CP	3AH
	CALL	NC,AS2_2
	DEC	DE
	DEC	HL
	POP	BC
	DJNZ	AS2_1
	RET
AS2_2	SUB	10
	LD	(DE),A
	DEC	DE
	LD	A,(DE)
	INC	A
	LD	(DE),A
	INC	DE
	RET
;
EXEC_COMM
	LD	HL,(WAVE_DELAY)
	LD	A,H
	OR	L
	JR	Z,EC_1
	DEC	HL
	LD	(WAVE_DELAY),HL
	RET
EC_1	LD	HL,(WAVE_PC)
	LD	A,(HL)
	CP	12
	RET	NC
	ADD	A,A
	PUSH	HL
	LD	E,A
	LD	D,0
	LD	HL,W_TABLE
	ADD	HL,DE
	LD	E,(HL)
	INC	HL
	LD	D,(HL)
	POP	HL
	PUSH	DE
	POP	IX
	JP	(IX)
;
W_TABLE	DEFW	W_REST,W_WAVE,W_FINISH,W_NEWMAN
	DEFW	W_WAIT,W_KILLALL,W_NEW,W_WREPT
	DEFW	W_WENDR,W_STOP,W_JMP,W_SYNC
;
W_REST	INC	HL
	LD	(WAVE_PC),HL
	RET
;
W_WAVE	LD	(WAVE_START),HL
	INC	HL
	LD	(WAVE_PC),HL
	CALL	CLS
	LD	A,1
	LD	(ALIEN_NO),A
	LD	A,(WAVE_CTR)
	INC	A
	LD	(WAVE_CTR),A
	LD	HL,WAVE_MESS
	LD	DE,7*64+3C00H+25
	LD	BC,5
	LDIR
	EX	DE,HL
	LD	A,(WAVE_CTR)
	CALL	BYTE_DEC
	LD	BC,0
	CALL	60H
	CALL	60H
	CALL	60H
	CALL	NOSHOTS
	LD	HL,LOOP_STK
	LD	(LOOP_PTR),HL
	CALL	CLS
	LD	HL,S_VDU
	LD	DE,S_VDU+1
	LD	(HL),80H
	LD	BC,03FFH
	LDIR
	LD	A,START_POSN
	LD	(MAN_POSN),A
	RET
;
WAVE_MESS
	DEFM	'Wave '
;
;
W_FINISH
	LD	A,(NUM_ALIEN)
	OR	A
	RET	NZ
	INC	HL
	LD	(WAVE_PC),HL
	RET
;
W_NEWMAN
	INC	HL
	LD	(WAVE_PC),HL
	LD	A,(MEN_LEFT)
	INC	A
	LD	(MEN_LEFT),A
	RET
;
W_WAIT	INC	HL
	LD	E,(HL)
	INC	HL
	LD	D,(HL)
	INC	HL
	LD	(WAVE_PC),HL
	EX	DE,HL
	LD	(WAVE_DELAY),HL
	RET
;
W_KILLALL
	INC	HL
	LD	(WAVE_PC),HL
	LD	HL,AL_TAB
	LD	B,MAX_ALIEN
	LD	DE,5
WK_1	LD	(HL),0
	ADD	HL,DE
	DJNZ	WK_1
	XOR	A
	LD	(NUM_ALIEN),A
	LD	HL,LOOP_STK
	LD	(LOOP_PTR),HL
	RET
;
W_NEW	LD	DE,5
	PUSH	HL
	ADD	HL,DE
	LD	(WAVE_PC),HL
	LD	A,(NUM_ALIEN)
	CP	MAX_ALIEN
	POP	HL
	JP	NC,EXEC_COMM
	PUSH	HL
	LD	HL,AL_TAB
	LD	B,MAX_ALIEN
	LD	DE,5
WN_1	LD	A,(HL)
	AND	1
	JR	Z,WN_2
	ADD	HL,DE
	DJNZ	WN_1
	JP	ERROR
WN_2	LD	(HL),1
	INC	HL
	POP	DE
	INC	DE
	LD	BC,4
	EX	DE,HL
	LDIR
	LD	A,(NUM_ALIEN)
	INC	A
	LD	(NUM_ALIEN),A
	JP	EXEC_COMM
;
W_WREPT	INC	HL
	LD	A,(HL)
	INC	HL
	LD	(HL),A
	INC	HL
	LD	(WAVE_PC),HL
	JP	EXEC_COMM
;
W_WENDR
	INC	HL
	LD	E,(HL)
	INC	HL
	LD	D,(HL)
	INC	HL
	LD	(WAVE_PC),HL
	INC	DE
	INC	DE
	EX	DE,HL
	DEC	(HL)
	JP	Z,EXEC_COMM
	INC	HL
	LD	(WAVE_PC),HL
	JP	EXEC_COMM
;
W_STOP	LD	HL,MSG1
	CALL	4467H
	JP	402DH
;
MSG1	DEFM	'Bye!',0DH
;
W_JMP	INC	HL
	LD	E,(HL)
	INC	HL
	LD	D,(HL)
	EX	DE,HL
	LD	(WAVE_PC),HL
	JP	EXEC_COMM
;
NOSHOTS	XOR	A
	LD	(SHOT_FIRED),A
	LD	HL,AL_SHOT
	LD	DE,3
	LD	B,MAX_ALIEN
NOS_1	LD	(HL),0
	ADD	HL,DE
	DJNZ	NOS_1
	RET
;
RELS_LOOPS
	LD	HL,LOOP_STK
RL_1	EX	DE,HL
	LD	HL,(LOOP_PTR)
	OR	A
	SBC	HL,DE
	EX	DE,HL
	LD	A,D
	OR	E
	RET	Z
	LD	A,(HL)
	CP	C
	JR	NZ,RL_3
	PUSH	HL
	INC	HL
	INC	HL
	INC	HL
	PUSH	BC
	CALL	MV_STK_L
	POP	BC
	POP	HL
	JR	RL_1
RL_3	LD	DE,4
	ADD	HL,DE
	JR	RL_1
;
SYNCHRON
	LD	HL,AL_TAB
	LD	B,MAX_ALIEN
	LD	C,A
	CP	1
	JR	NZ,SY_0
	LD	A,(ALIEN_NO)
	ADD	A,2
	LD	(ALIEN_NO),A
SY_0	XOR	A
	LD	(_TEMPB),A
SY_1	LD	A,(HL)
	CP	C
	PUSH	BC
	PUSH	DE
	PUSH	HL
	CALL	Z,SYNC_1
	POP	HL
	LD	DE,5
	ADD	HL,DE
	POP	DE
	POP	BC
	LD	A,(_TEMPB)
	INC	A
	LD	(_TEMPB),A
	DJNZ	SY_1
	RET
;
SYNC_1	LD	A,(HL)
	CP	1
	JR	NZ,SYNC_2
	LD	A,(ALIEN_NO)
	LD	(HL),A
SYNC_2	INC	HL
	INC	HL
	INC	HL
	LD	(HL),E
	INC	HL
	LD	(HL),D
	LD	A,(_TEMPB)
	LD	C,A
	CALL	RELS_LOOPS
	RET
;
I_SYNC	INC	DE
	INC	DE
	INC	DE
	INC	DE
	LD	(HL),D
	DEC	HL
	LD	(HL),E
	EX	DE,HL
	DEC	HL
	LD	D,(HL)
	DEC	HL
	LD	E,(HL)
	DEC	HL
	LD	A,(HL)
	CALL	SYNCHRON
	LD	HL,(_TABST)
	JP	EXECUT
;
W_SYNC	INC	HL
	LD	A,(HL)
	INC	HL
	LD	E,(HL)
	INC	HL
	LD	D,(HL)
	INC	HL
	LD	(WAVE_PC),HL
	CALL	SYNCHRON
	RET
;
UPDATE_VDU_2
	LD	IX,3C00H
	LD	HL,S_VDU
	LD	DE,S_GRX
	LD	BC,0400H
UV2_1	LD	A,(DE)
	CP	(HL)
	JR	Z,UV2_2
	LD	(HL),A
	LD	(IX+0),A
UV2_2	INC	IX
	INC	HL
	INC	DE
	DEC	C
	JR	NZ,UV2_1
	DJNZ	UV2_1
	RET
;
BYTE_DEC
	LD	C,100
	CP	A
	CALL	BD_1
	LD	C,10
	CALL	BD_1
	LD	C,1
	CP	255
	CALL	BD_1
	RET
;
BD_1	JR	NZ,BD_2
	CP	C
	JR	NC,BD_2
	CP	A
	RET
BD_2	LD	(HL),30H
BD_3	CP	C
	JR	C,BD_4
	SUB	C
	INC	(HL)
	JR	BD_3
BD_4	INC	HL
	RET
;
DRAW_MAN_3
	LD	A,(MAN_POSN)
	OR	A
	RR	A
	LD	DE,MANDATA_1
	JR	NC,DM3_1
	LD	DE,MANDATA_2
DM3_1	LD	C,A
	LD	B,0
	LD	HL,S_GRX+LOWLEFT
	ADD	HL,BC
	LD	B,3
DM3_2	LD	A,(DE)
	OR	(HL)
	LD	(HL),A
	INC	HL
	INC	DE
	DJNZ	DM3_2
	RET
;
DRAW_SHOTS_2
	LD	A,(SHOT_FIRED)
	OR	A
	RET	Z
	LD	A,(SHOT_X)
	LD	B,A
	LD	A,(SHOT_Y)
	LD	C,A
	LD	D,2
	LD	HL,SHDATA
	CALL	FIND_POSN	;hl=addr,de=table
	LD	BC,S_GRX
	ADD	HL,BC
	LD	B,2
DS2_1	LD	A,(DE)
	OR	(HL)
	LD	(HL),A
	INC	HL
	INC	DE
	DJNZ	DS2_1
	RET
;
FIND_POSN
	PUSH	HL
	LD	A,D
	LD	(WXWY),A
	LD	A,B
	LD	(PX),A
	LD	A,C
	LD	B,0FFH
FP_1	SUB	3
	INC	B
	JR	NC,FP_1
	ADD	A,3
	LD	(YMOD3),A
	LD	A,B
	LD	(YDIV3),A
	LD	A,(PX)
	AND	1
	LD	(XMOD2),A
	LD	A,(WXWY)
	LD	L,A
	LD	H,0
	ADD	HL,HL
	EX	DE,HL
	LD	HL,0
	LD	A,(YMOD3)
	OR	A
	JR	Z,FP_4
FP_3	ADD	HL,DE
	DEC	A
	JR	NZ,FP_3
FP_4	LD	(_TEMPW),HL
	LD	A,(WXWY)
	LD	L,A
	LD	H,0
	LD	A,(XMOD2)
	OR	A
	JR	NZ,FP_5
	LD	HL,0
FP_5	EX	DE,HL
	LD	HL,(_TEMPW)
	ADD	HL,DE
	POP	DE
	ADD	HL,DE
	PUSH	HL
	LD	A,(YDIV3)
	LD	L,0
	LD	H,A
	OR	A
	RR	H
	RR	L
	RR	H
	RR	L
	LD	A,(PX)
	SRL	A
	ADD	A,L
	LD	L,A
	POP	DE
	RET
;
DRAW_1_BOMB_2
	INC	HL
	LD	A,(HL)
	CP	WIDTH_X-4
	RET	NC
	LD	B,A
	INC	HL
	LD	A,(HL)
	CP	WIDTH_Y-1
	RET	NC
	LD	C,A
	LD	D,6
	LD	HL,BMDATA
	CALL	FIND_POSN
	LD	BC,S_GRX
	ADD	HL,BC
	LD	B,3
D1B2_1	LD	A,(DE)
	OR	(HL)
	LD	(HL),A
	INC	DE
	INC	HL
	DJNZ	D1B2_1
	LD	BC,61
	ADD	HL,BC
	LD	B,3
D1B2_2	LD	A,(DE)
	OR	(HL)
	LD	(HL),A
	INC	DE
	INC	HL
	DJNZ	D1B2_2
	RET
;
DRAW_ONE_2
	INC	HL
	LD	A,(HL)
	CP	WIDTH_X-4
	RET	NC
	LD	B,A
	INC	HL
	LD	A,(HL)
	CP	WIDTH_Y-1
	RET	NC
	LD	C,A
	LD	D,6
	LD	HL,ALDATA
	CALL	FIND_POSN
	LD	BC,S_GRX
	ADD	HL,BC
	LD	B,3
DO2_1	LD	A,(DE)
	OR	(HL)
	LD	(HL),A
	INC	DE
	INC	HL
	DJNZ	DO2_1
	LD	BC,61
	ADD	HL,BC
	LD	B,3
DO2_2	LD	A,(DE)
	OR	(HL)
	LD	(HL),A
	INC	DE
	INC	HL
	DJNZ	DO2_2
	RET
;
	END	START
