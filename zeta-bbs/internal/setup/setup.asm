;setup: prepare for use as a remote system.
;
*GET	DOSCALLS.HDR
*GET	EXTERNAL.HDR
*GET	ASCII.HDR
;
	COM	'<SETUP 1.1a 02-Apr-88>'
	ORG	BASE+100H
START	LD	SP,START
	PUSH	HL		;Save any parameters.
;
	LD	A,1		;Speed up
	OUT	(254),A
;
	LD	HL,END_PROG	;Clear memory
	LD	DE,END_PROG+1
	LD	BC,0FFFFH-END_PROG
	LD	(HL),0
	LDIR
;
	LD	HL,TEMP_RAM-1	;Set HIMEM (usually F7FF)
	LD	(HIMEM),HL
;
	LD	DE,44A0H	;Start clock interrupts
	PUSH	DE
	CALL	4413H
	POP	DE
	CALL	4410H
;
;load any required data into memory.
;from parameters given.
	POP	HL
NXT_PARAM
	LD	A,(HL)
	CP	CR
	JR	Z,FIXED_DATA
	CP	'T'
	JR	NZ,NO_TEST
	LD	A,(SYS_STAT)
	SET	6,A
	SET	4,A		;Daring!
;Sets a permanent 'BOOT FOR TESTING!' bit...
	LD	(SYS_STAT),A
	INC	HL
	JR	NXT_PARAM
NO_TEST
	CP	'S'		;sort Directory
	JR	NZ,NEXT
	INC	HL
	LD	A,(HL)
	SUB	'0'
	CP	8
	JR	NC,NXT_PARAM
	LD	A,(HL)
	LD	(SORT_DISK),A
	PUSH	HL
;sort directory. Complain if errors.
	LD	HL,SORT_CMD
	CALL	DOS_CALL
	JR	Z,SORT_OK
	OR	80H
	CALL	DOS_ERROR
	JP	DOS		;abort.
SORT_OK
	POP	HL
NEXT	INC	HL
	JR	NXT_PARAM
;
FIXED_DATA
;load number of calls into memory.
	CALL	GET_STATS
	JP	NZ,SETUP_ERR
	LD	HL,(ST_LOGGED_IN)	;logged in count
	LD	(CALLER),HL
	LD	HL,(ST_PKTS_RCVD)	;packets got.
	LD	(PKTS_RCVD),HL
	LD	DE,ST_FCB
	CALL	DOS_CLOSE
;
	JP	DOS		;Done!
;
SETUP_ERR
	OR	80H
	CALL	DOS_ERROR
	LD	DE,ST_FCB
	CALL	DOS_CLOSE
	JP	DOS		;Abort.
;
GET_STATS
	LD	DE,ST_FCB
	LD	HL,ST_BUF
	LD	B,16
	CALL	DOS_OPEN_EX
	RET	NZ
	LD	A,(ST_FCB+1)
	AND	0F8H		;Unprotect
	LD	(ST_FCB+1),A
	LD	HL,STATS_REC
	CALL	DOS_READ_SECT
	RET
;
SORT_CMD
	DEFM	'DS '
SORT_DISK
	DEFM	'0',CR
;
;
ST_FCB	DEFM	'STATS.ZMS',CR
	DC	32-10,0
*GET	STATS.HDR
;
ST_BUF	DEFS	256
;
END_PROG	EQU	$
;
	END	START
