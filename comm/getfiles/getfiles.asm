;getfiles: get a list of files off OMEN systems
;
F_ZETA	EQU	1
F_TRS80	EQU	0
F_SYS80	EQU	0
F_ATERM	EQU	0
;
*GET	DOSCALLS
*GET	TERMINAL/HDR
;
	COM	'<getfiles 1.0 05-Apr-86>'
;
	ORG	0C000H		;past XMF load.
;
START
	LD	SP,START
	CALL	OPENF
	CALL	RS_INIT
;
LOOP	LD	SP,START
	CALL	READFN
;
	JR	NZ,NOFILES
	CALL	RS_INIT
	LD	HL,S_SEND
	CALL	PRTSTR
;
	CALL	WAIT5
	LD	HL,S_SEND
	CALL	STR_SEND
;
	LD	HL,400
	LD	(WAITS),HL
	CALL	WAIT40
;
	LD	HL,S_XMF
	CALL	PRTSTR
	CALL	DOS_CALL
	JR	LOOP
;
PRTSTR	PUSH	HL
	CALL	4467H
	POP	HL
	RET
;
NOFILES
	JP	DOS
;
READFN
	LD	HL,S_SEND_F
	LD	BC,S_XMF_F
	LD	DE,FCB_IN
READFN1
	CALL	$GET
	RET	NZ
	LD	(HL),A
	LD	(BC),A
	INC	HL
	INC	BC
	CP	0DH
	JR	NZ,READFN1
	RET
;
WAIT5
	LD	HL,200
	LD	(WAITS),HL
WAIT40
	LD	A,(4040H)
	CP	D
	LD	D,A
	JR	Z,WAIT40
;If char recvd, reset wait counter.
	IN	A,(RDSTAT)
	BIT	DAV,A
	JR	Z,WAIT_02
	IN	A,(RDDATA)
	PUSH	HL
	PUSH	DE
	CALL	33H
	POP	DE
	POP	HL
	LD	HL,(WAITS)
	JR	WAIT40
;
WAIT_02	DEC	HL
	LD	A,H
	OR	L
	JR	NZ,WAIT40
	RET
;
STR_SEND
	LD	A,(HL)
	PUSH	HL
	CALL	CH_$PUT
	POP	HL
	LD	A,(HL)
	INC	HL
	CP	0DH
	JR	NZ,STR_SEND
	RET
;
CH_$PUT	PUSH	AF
CH_1	IN	A,(RDSTAT)
	BIT	CTS,A
	JR	Z,CH_1
	POP	AF
	OUT	(WRDATA),A
	PUSH	AF
	LD	B,0
CH_2	IN	A,(RDSTAT)
	BIT	DAV,A
	JR	NZ,CH_3
	PUSH	BC
	LD	B,0
	DJNZ	$
	POP	BC
	DJNZ	CH_2
	POP	AF
	JR	CH_$PUT
CH_3
	IN	A,(RDDATA)
	CALL	33H
	POP	AF
	RET
;
OPENF
	LD	DE,FCB_IN
	CALL	DOS_EXTRACT
	JP	NZ,DOS
	LD	HL,BUFF_IN
	LD	B,0
	CALL	DOS_OPEN_EX
	JP	NZ,DOS
	RET
;
RS_INIT
	IF	F_ZETA			;Zeta
	LD	A,82H			;Zeta
	OUT	(WRSTAT),A		;Zeta
	LD	A,40H			;Zeta
	OUT	(WRSTAT),A		;Zeta
	LD	A,0EH			;Zeta�
	OUT	(WRSTAT),A		;Zeta
	LD	A,05H			;Zeta
	OUT	(WRSTAT),A		;Zeta
	ENDIF				;Zeta
;
	RET
;
;
S_SEND
	DEFM	'S '
S_SEND_F
	DEFM	'filename...............',0
;
S_XMF	DEFM	'XMF R '
S_XMF_F
	DEFM	'filename...............',0
WAITS	DEFW	0
;
FCB_IN	DEFS	32
BUFF_IN	DEFS	256
;
	END	START