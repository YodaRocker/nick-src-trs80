;bbarch: Archive oldest messages on the tree.
; Only public messages will be archived.
; Output in file BBARmmyy.ZMS:1
;
*GET	DOSCALLS
*GET	EXTERNAL
*GET	ASCII
;
MAX_ACTIVE	EQU	350	;Max active msgs allowed.
;
	ORG	PROG_START
	DEFW	BASE
	DEFW	THIS_PROG_END
	DEFW	0
	DEFW	0
;End of program load info.
;
	COM	'<BBARCH 1.0b 04-Oct-86>'
	ORG	BASE+100H
START	LD	SP,START
	LD	A,(PRIV_1)
	BIT	IS_SYSOP,A
	LD	A,0
	JP	Z,TERMINATE
;
	CALL	FILES_OPEN
;
	CALL	READ_STATS	;Read number of msgs.
;
	LD	HL,(NUM_MSG)
	LD	DE,(NUM_KLD_MSG)
	OR	A
	SBC	HL,DE
	LD	DE,MAX_ACTIVE+1
	OR	A
	SBC	HL,DE
	JR	NC,NEEDS_ARCHIVE
	XOR	A
	JP	TERMINATE
NEEDS_ARCHIVE
	INC	HL
	LD	(TAKE_MSGS),HL		;#msgs to archive
	LD	A,H
	OR	L
	JP	Z,TERMINATE
;
	CALL	OPEN_ARCH
;
	LD	HL,-1
	LD	(THIS_MSG_NUM),HL
;
ARCHIVE
	LD	HL,(TAKE_MSGS)
	LD	A,H
	OR	L
	JP	Z,FINISHED
;
	CALL	READ_HDR
	JR	NZ,FINISHED	;if no more msgs.
	LD	HL,(THIS_MSG_NUM)
	INC	HL
	LD	(THIS_MSG_NUM),HL
;
	LD	A,(HDR_FLAG)
	BIT	FM_KILLED,A		;If deleted.
	JR	NZ,TRY_NEXT
;;	BIT	2,A		;If SPECIAL message
;;	JR	NZ,TRY_NEXT
	BIT	FM_PRIVATE,A	;Never a private msg.
	JR	NZ,TRY_NEXT
;
;Don't archive a network message which is not sent.
	AND	30H
	CP	10H
	JR	Z,TRY_NEXT
;
;OK. Archive this message.
	CALL	WRITE_ARCH
	CALL	Z,KILL_THIS	;If archived, kill.
	LD	HL,(TAKE_MSGS)
	DEC	HL
	LD	(TAKE_MSGS),HL
;
TRY_NEXT
	JR	ARCHIVE
;
FINISHED
	CALL	WRITE_STATS
	CALL	CLOSE_FILES
	XOR	A
	JP	TERMINATE
;
FILES_OPEN
	LD	DE,FCB_TXT
	LD	HL,BUF_TXT
	LD	B,0
	CALL	DOS_OPEN_EX
	JP	NZ,ERROR
;
	LD	DE,FCB_HDR
	LD	HL,BUF_HDR
	LD	B,HDR_LEN
	CALL	DOS_OPEN_EX
	JP	NZ,ERROR
;
	LD	DE,FCB_TOP
	LD	HL,BUF_TOP
	LD	B,0
	CALL	DOS_OPEN_EX
	JP	NZ,ERROR
;
	LD	A,(FCB_TXT+1)
	AND	0F8H
	OR	40H
	LD	(FCB_TXT+1),A
	LD	A,(FCB_HDR+1)
	AND	0F8H
	OR	40H
	LD	(FCB_HDR+1),A
	LD	A,(FCB_TOP+1)
	AND	0F8H
	OR	40H
	LD	(FCB_TOP+1),A
;
	RET
;
READ_STATS
	LD	B,16
	LD	DE,FCB_TOP
	LD	HL,STATS_REC
RS_1	CALL	$GET
	JP	NZ,ERROR
	LD	(HL),A
	INC	HL
	DJNZ	RS_1
	RET
;
WRITE_STATS
	LD	DE,FCB_TOP
	CALL	DOS_REWIND
	LD	B,16
	LD	HL,STATS_REC
WS_1	LD	A,(HL)
	CALL	$PUT
	JP	NZ,ERROR
	INC	HL
	DJNZ	WS_1
	RET
;
OPEN_ARCH
	LD	DE,FCB_ARCH
	LD	HL,BUF_ARCH
	LD	B,0
	CALL	DOS_OPEN_NEW
	JP	NZ,ERROR
	CALL	DOS_POS_EOF
	JP	NZ,ERROR
	RET
;
READ_HDR
	LD	DE,FCB_HDR
	LD	HL,HDR_REC
	CALL	DOS_READ_SECT
	JR	NZ,POSS_EOF
	RET
POSS_EOF
	CP	1CH
	JR	Z,IS_EOF
	CP	1DH
	JR	Z,IS_EOF
	JP	ERROR
IS_EOF	XOR	A
	CP	1
	RET
;
WRITE_ARCH
	LD	A,(HDR_RBA)
	LD	C,A
	LD	HL,(HDR_RBA+1)
	LD	DE,FCB_TXT
	CALL	DOS_POS_RBA
	JP	NZ,ERROR
	CALL	$GET
	JP	NZ,WA_CORRUPT
	CP	0FFH
	JP	NZ,WA_CORRUPT
;
	CALL	$GET		;Bypass dummy byte
	CALL	$GET		;Bypass # lines
;
	LD	HL,M_FROM
	CALL	ARCH_MSG
	CALL	ARCH_COPY	;copy sender name
	LD	HL,M_TO
	CALL	ARCH_MSG
	CALL	ARCH_COPY	;copy recvr name
	LD	HL,M_DATE
	CALL	ARCH_MSG
	CALL	ARCH_COPY	;copy date sent
	LD	HL,M_SUBJ
	CALL	ARCH_MSG
	CALL	ARCH_COPY	;copy subject
WA_1	CALL	ARCH_COPY
	JR	NZ,WA_1		;until null seen.
;
	LD	A,CR
	LD	DE,FCB_ARCH
	CALL	$PUT
	CALL	$PUT
;
	XOR	A
	LD	DE,FCB_ARCH
	CALL	$PUT
	JP	NZ,ERROR
	RET	;is Z.
;
WA_CORRUPT
	XOR	A
	CP	1
	RET			;Corrupted.
;
KILL_THIS
	LD	HL,HDR_FLAG
	SET	0,(HL)		;Set DELETED.
	LD	HL,HDR_TOPIC	;Set topic# to 1
	LD	(HL),1		;(ie. killed)
	CALL	REWRITE_HDR
;
	LD	HL,(THIS_MSG_NUM)
	LD	A,1
	CALL	SET_TOPIC_NO
;
	LD	HL,(NUM_KLD_MSG)
	INC	HL
	LD	(NUM_KLD_MSG),HL
	RET
;
CLOSE_FILES
	LD	DE,FCB_ARCH
	CALL	DOS_CLOSE
	JP	NZ,ERROR
	LD	DE,FCB_TXT
	CALL	DOS_CLOSE
	JP	NZ,ERROR
	LD	DE,FCB_HDR
	CALL	DOS_CLOSE
	JP	NZ,ERROR
	LD	DE,FCB_TOP
	CALL	DOS_CLOSE
	JP	NZ,ERROR
	RET
;
ARCH_MSG
	LD	DE,FCB_ARCH
	CALL	FPUTS
	RET
;
ARCH_COPY
	LD	DE,FCB_TXT
	CALL	$GET
	JP	NZ,ERROR
	CP	0
	RET	Z
AC_1
	PUSH	AF
	LD	DE,FCB_ARCH
	CALL	$PUT
	JP	NZ,ERROR
	POP	AF
	CP	CR
	JR	Z,AC_2
	LD	DE,FCB_TXT
	CALL	$GET
	JP	NZ,ERROR
	JR	AC_1
AC_2	XOR	A
	CP	1
	RET
;
REWRITE_HDR
	LD	DE,FCB_HDR
	CALL	DOS_BACK_RECD
	JP	NZ,ERROR
	LD	HL,HDR_REC
	CALL	DOS_WRIT_SECT
	JP	NZ,ERROR
	RET
;
SET_TOPIC_NO
	PUSH	AF
	LD	DE,4096		;topic file offset.
	ADD	HL,DE
;Set RBA from HL
	LD	C,L
	LD	L,H
	LD	H,0
	LD	DE,FCB_TOP
	CALL	DOS_POS_RBA
	JP	NZ,ERROR
;
	POP	AF
	CALL	$PUT
	JP	NZ,ERROR
	RET
;
ERROR	PUSH	AF
	OR	80H
	CALL	DOS_ERROR
	POP	AF
	JP	TERMINATE
;
;
;
;
*GET	MSGHDR.HDR
*GET	MSGTOP.HDR
;
*GET	ROUTINES
;
M_FROM	DEFM	'From: ',0
M_TO	DEFM	'To:   ',0
M_DATE	DEFM	'Date: ',0
M_SUBJ	DEFM	'Subj: ',0
;
TAKE_MSGS	DEFW	0
THIS_MSG_NUM	DEFW	0
;
FCB_ARCH	DEFM	'BBAR'
ARCH_MM		DEFM	'CH'
ARCH_YY		DEFM	'IV',ETX
		DC	32-9,0
;
FCB_TXT	DEFM	'MSGTXT.ZMS',ETX
	DC	32-11,0
;
FCB_TOP	DEFM	'MSGTOP.ZMS',ETX
	DC	32-11,0
;
FCB_HDR	DEFM	'MSGHDR.ZMS',ETX
	DC	32-11,0
;
BUF_TXT	DEFS	256
BUF_TOP	DEFS	256
BUF_HDR	DEFS	256
BUF_ARCH DEFS	256
;
THIS_PROG_END	EQU	$
;
	END	START
