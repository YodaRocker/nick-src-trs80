;password: let a user change his password.
;
*GET	DOSCALLS.HDR
*GET	EXTERNAL.HDR
*GET	ASCII.HDR
;
	ORG	PROG_START
	DEFW	BASE
	DEFW	THIS_PROG_END
	DEFW	TERMINATE
	DEFW	0
;End of program load info.
;
	COM	'<Password 1.3c 19-May-87>'
	ORG	BASE+100H
START	LD	SP,START
;
PWD_1
	LD	HL,(USR_NAME)
	LD	DE,UN_BUFF
PWD_2	LD	A,(HL)
	LD	(DE),A
	CP	CR
	JR	Z,PWD_3
	OR	A
	JR	Z,PWD_3
	INC	HL
	INC	DE
	JR	PWD_2
;
PWD_3	LD	HL,UN_BUFF
	CALL	USER_SEARCH
	JR	Z,PWD_4
	JR	NC,PWD_3A
	PUSH	AF
	OR	80H
	CALL	DOS_ERROR
	POP	AF
	JP	TERMINATE
;
;If unknown.
PWD_3A	LD	HL,M_NAMEBAD
	CALL	LOG_MSG
	LD	HL,M_NAMEBAD	;Name is wrong.
	LD	DE,$2
	CALL	MESS_0
	XOR	A
	JP	TERMINATE
;
;name checks out OK
PWD_4
;
	LD	HL,M_CHANGING
	LD	DE,$2
	CALL	MESS_0
	LD	HL,(USR_NAME)
	CALL	MESS_CR
;
;check old password
	LD	A,(UF_PASSWD)
	OR	A		;if null passwd
	JR	Z,OLD_OK
;prompt for old password.
PWD_5	LD	HL,M_OLD
	LD	DE,$2
	CALL	MESS_0
	LD	HL,PWD_BUF
	LD	B,12
	CALL	40H
	JR	NC,PWD_5A
	XOR	A
	JP	TERMINATE
;Change new password to U/C, set 0 terminator.
PWD_5A	LD	HL,PWD_BUF
PWD_6	LD	A,(HL)
	CP	CR
	JR	Z,PWD_7
	OR	A
	JR	Z,PWD_7
	INC	HL
	CP	'a'
	JR	C,PWD_6
	DEC	HL
	AND	5FH
	LD	(HL),A
	INC	HL
	JR	PWD_6
;
PWD_7
	LD	(HL),0
;now check old <-> entered password.
	LD	HL,UF_PASSWD
	LD	DE,PWD_BUF
	LD	B,13
CN_3	LD	A,(DE)
	CP	(HL)
	JR	NZ,CN_4
	OR	A	;if end.
	JR	Z,OLD_OK
	INC	HL
	INC	DE
	DJNZ	CN_3
	LD	A,(DE)
	OR	A
	JR	Z,OLD_OK
;
CN_4	LD	HL,M_DENIED
	LD	DE,$2
	CALL	MESS_0
	LD	A,1
	JP	TERMINATE
;
;old password checks out.
OLD_OK	LD	HL,M_NEW_1
	LD	DE,$2
	CALL	MESS_0
	LD	HL,PWD_BUF
	LD	B,12
	CALL	40H
	JP	C,EXIT
	LD	HL,PWD_BUF
	CALL	STR_UPPER
;Ask for re-entry.
	LD	HL,M_NEW_2
	LD	DE,$2
	CALL	MESS_0
	LD	HL,PWD2_BUF
	LD	B,12
	CALL	40H
	JR	C,EXIT
	LD	HL,PWD2_BUF
	CALL	STR_UPPER
;
	LD	HL,PWD_BUF
	LD	DE,PWD2_BUF
	CALL	STR_CMP
	JP	NZ,EXIT
;
	LD	HL,PWD_BUF
ZN_1	LD	A,(HL)
	CP	CR
	JR	Z,ZN_1A
	INC	HL
	JR	ZN_1
ZN_1A
	LD	(HL),0
;Zero whole field.
	LD	HL,UF_PASSWD
	LD	B,13
ZN_2	LD	(HL),0
	INC	HL
	DJNZ	ZN_2
;
;
ZN_5	LD	HL,PWD_BUF
	LD	DE,UF_PASSWD
ZN_5A	LD	A,(HL)
	LD	(DE),A
	OR	A
	JR	Z,ZN_5B
	INC	HL
	INC	DE
	JR	ZN_5A
ZN_5B
	LD	DE,US_FCB
	LD	A,(US_RBA)
	LD	HL,(US_RBA+1)
	LD	C,A
	CALL	DOS_POS_RBA
	JP	NZ,ERROR
;
	LD	HL,US_UBUFF
	LD	B,UF_LRL
	LD	DE,US_FCB
ZN_6	LD	A,(HL)
	CALL	$PUT
	JP	NZ,ERROR
	INC	HL
	DJNZ	ZN_6
;
	CALL	DOS_CLOSE
	JP	NZ,ERROR
	LD	HL,M_SUCCESS
	LD	DE,$2
	CALL	MESS_0
	LD	A,0
	JP	TERMINATE
;
EXIT	LD	DE,US_FCB
	CALL	DOS_CLOSE
	JP	NZ,ERROR
	LD	HL,M_NOCHG
	LD	DE,$2
	CALL	MESS_0
	LD	A,0
	JP	TERMINATE
;
STR_UPPER
	LD	A,(HL)
	OR	A
	RET	Z
	CP	CR
	RET	Z
	CP	ETX
	RET	Z
	INC	HL
	CP	'a'
	JR	C,STR_UPPER
	CP	'z'+1
	JR	NC,STR_UPPER
	AND	5FH
	DEC	HL
	LD	(HL),A
	INC	HL
	JR	STR_UPPER
;
ERROR	PUSH	AF
	OR	80H
	CALL	DOS_ERROR
	LD	HL,M_SORRY
	LD	DE,$2
	CALL	MESS_0
	LD	HL,M_ERROR
	CALL	LOG_MSG
	POP	AF
	PUSH	AF
	CALL	PRINT_DEC
	LD	DE,US_FCB
	CALL	DOS_CLOSE
	POP	AF
	JP	TERMINATE
;
PRINT_DEC
	LD	H,'0'-1
PD_1	INC	H
	SUB	10
	JR	NC,PD_1
	ADD	A,'0'+10
	PUSH	AF
	LD	A,H
	LD	(DEC_CODE),A
	POP	AF
	LD	(DEC_CODE+1),A
	LD	HL,DEC_CODE
	CALL	LOG_MSG
	RET
;
*GET	ROUTINES
;
M_CHANGING
	DEFM	'Changing password for ',0
M_NOCHG	DEFM	'Password to remain unchanged',CR,0
;
M_NAMEBAD
	DEFM	'Name compare mismatch! (Sorry)',CR,0
M_OLD	DEFM	'Enter current password: ',0
M_DENIED
	DEFM	'Password change denied',CR,0
M_NEW_1	DEFM	'Enter NEW password: ',0
M_NEW_2	DEFM	'Re-enter new password: ',0
M_SUCCESS
	DEFM	'Successful!',CR,0
;
PWD_BUF	DC	16,0
PWD2_BUF	DC	16,0
;
M_SORRY	DEFM	'Sorry about that!',CR,ETX
M_ERROR	DEFM	'(PASSWORD) Error # ',0
DEC_CODE	DEFB	'xx',CR,0
;
UN_BUFF	DEFS	64
;
THIS_PROG_END	EQU	$
;
	END	START