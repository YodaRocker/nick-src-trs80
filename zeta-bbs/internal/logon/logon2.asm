;logon2: Part 2 of 2 of logon.
;
HI_VISITOR
	CALL	WAIT_KEY
	LD	HL,M_VISIT
	LD	DE,$2
	CALL	MESS_0
	LD	HL,F_VISIT
	CALL	LIST_NOSTOP
;
	IF	NEWCOND		;Visitors must agree say Y
HV_1A	LD	HL,M_AGREE
	LD	DE,$2
	CALL	MESS_0
HV_2	LD	HL,YN_BUFF
	LD	B,1
	CALL	40H
	JR	C,HV_1A
	LD	A,(HL)
	AND	5FH
	CP	'Y'
	JP	Z,HV_3
	CP	'N'
	JR	NZ,HV_1A
;user doesn't like to use the system!
	LD	HL,M_STUFFED
	LD	DE,$2
	CALL	MESS_0
	LD	A,2
	JP	TERM_DISCON	;Un-civil behaviour.
;
HV_3	LD	HL,M_AGRD
	LD	DE,$2
	CALL	MESS_0
;
	ENDIF			;newcond
;
	RET
;
PUTS_0	LD	A,(HL)
	OR	A
	RET	Z
	CALL	$PUT
	JR	NZ,PUTS_0A	;fileio error.
	INC	HL
	JR	PUTS_0
;
PUTS_0A	PUSH	AF
	LD	A,(DE)
	BIT	7,A		;if file open
	JR	Z,PUTS_0B
	CALL	DOS_CLOSE	;close file
	POP	AF
	JP	ERROR		;go to error.
PUTS_0B	POP	AF
	RET
;
REGISTER			;Register a new person.
	LD	DE,REGIST_FCB	;Open register.log file
	LD	HL,REGIST_BUF
	LD	B,0
	CALL	DOS_OPEN_EX
	JP	NZ,ERROR
	CALL	DOS_POS_EOF
	JP	NZ,ERROR
;
	INC	DE
	LD	A,(DE)		;Unprotect
	AND	0F8H
	LD	(DE),A
	DEC	DE
;
	LD	HL,TIME_BUF	;Write date/time
	CALL	446DH
	LD	HL,DATE_BUF
	CALL	X_TODAY
	LD	HL,DATE
	LD	DE,REGIST_FCB
	CALL	PUTS_0
;
	LD	HL,M_REGISTER	;Write login name
	CALL	PUTS_0
	LD	HL,NAME_BUFF
	CALL	PUTS_0
	LD	HL,M_REGISTER2
	CALL	PUTS_0
;
WHPASS	LD	HL,M_WHPASS	;ask for a password
	LD	DE,$2
	CALL	MESS_0
	LD	HL,PASS_BUFF
	LD	B,12
	CALL	40H
	JR	C,WHPASS
	LD	HL,PASS_BUFF
	CALL	TO_UPPER
	LD	(HL),0		;(hl) was CR terminat.
;
	LD	HL,PASS_BUFF	;Check length and chars
	CALL	STR_LEN
	CP	4
	JR	NC,REG_00A
	LD	HL,M_PASS_SHRT
	LD	DE,$2
	CALL	MESS_0
	JR	WHPASS		;try again.
REG_00A
	LD	HL,NAME_BUFF
	LD	DE,PASS_BUFF
	CALL	INSTR
	JR	NZ,REG_00B
	LD	HL,M_PASS_NAME
	LD	DE,$2
	CALL	MESS_0
	JR	WHPASS
;
REG_00B	;is OK.
;
;
	LD	HL,M_WAIT
	CALL	PUTS
;
	CALL	ZERO_SEARCH	;Search for empty.
	JR	Z,ADD_2		;*** overwrite only ***
	LD	HL,(US_PMAX)
	INC	HL
	LD	(US_PMAX),HL	;*** should = US_POSN ***
	JP	C,ERROR
;Name must be appended.
	LD	A,L
	OR	A		;if need new hash sector.
	JR	NZ,ADD_2
;
	LD	A,UF_LRL+1	;Ok. Write new sector
	CALL	MULTIPLY
	LD	DE,US_FCB
	CALL	DOS_POS_RBA
	JP	NZ,ERROR
	LD	B,0
ADD_1	XOR	A		;Write 256 zeroes.
	CALL	$PUT
	JP	NZ,ERROR
	DJNZ	ADD_1
ADD_2
;
	LD	HL,(US_POSN)	;Set hash
	LD	E,L
	LD	L,0
	LD	A,UF_LRL+1
	CALL	MULTIPLY
	LD	C,E
	LD	DE,US_FCB
	CALL	DOS_POS_RBA
	JP	NZ,ERROR
	LD	A,(US_HASH)
	CALL	$PUT		;Write hash.
	JP	NZ,ERROR
;
;Now write rest of data.
	LD	HL,(US_UMAX)
	INC	HL
	LD	(US_UMAX),HL
;
	LD	HL,(US_POSN)	;*** new ***
	PUSH	HL
	INC	H
	LD	L,0
	EX	DE,HL
	POP	HL
	LD	A,UF_LRL
	CALL	MULTIPLY
	LD	A,L
	ADD	A,D
	LD	L,A
	LD	A,0
	ADC	A,H
	LD	H,A
	LD	DE,US_FCB
	CALL	DOS_POS_RBA
;Setup.
;
	LD	A,040H		;Active.
	LD	(UF_STATUS),A
;
	LD	HL,UF_NAME
	LD	B,24
ADD_20	LD	(HL),0
	INC	HL
	DJNZ	ADD_20
	LD	HL,UF_PASSWD
	LD	B,13
ADD_21	LD	(HL),0
	INC	HL
	DJNZ	ADD_21
	LD	DE,UF_NAME
	LD	HL,NAME_BUFF
ADD_22	LD	A,(HL)
	LD	(DE),A
	OR	A
	JR	Z,ADD_23
	INC	HL
	INC	DE
	JR	ADD_22
ADD_23
	LD	HL,PASS_BUFF	;desired passwd.
	LD	DE,UF_PASSWD
ADD_24	LD	A,(HL)
	LD	(DE),A
	OR	A
	JR	Z,ADD_25
	INC	HL
	INC	DE
	JR	ADD_24
;
ADD_25
;
	LD	HL,(US_UMAX)
	LD	(UF_UID),HL
;
	LD	HL,0
	LD	(UF_NCALLS),HL
;
	XOR	A		;00/00/00.
	LD	(UF_LASTCALL),A
	LD	(UF_LASTCALL+1),A
	LD	(UF_LASTCALL+2),A
;
	LD	A,1BH		;Priv 1 Visitor
	LD	(UF_PRIV1),A
	LD	A,0BH		;Priv 2 Visitor
	LD	(UF_PRIV2),A
	XOR	A
	LD	(UF_PRIV3),A
;
	XOR	A
	LD	(UF_TDATA),A
;
	LD	A,40H		;Unpaid (nonmember).
	LD	(UF_REGCOUNT),A
;
	XOR	A
	LD	(UF_BADLOGIN),A
;
	XOR	A
	LD	(UF_TFLAG1),A
	LD	A,0BFH		;dumb type.
	LD	(UF_TFLAG2),A
;
	LD	A,8
	LD	(UF_ERASE),A
	LD	A,18H
	LD	(UF_KILL),A
	LD	A,0
	LD	(UF_NOTHING),A
;
;OK now write the data out....
	LD	HL,US_UBUFF
	LD	B,UF_LRL
	LD	DE,US_FCB
ADD_5	LD	A,(HL)
	CALL	$PUT
	JP	NZ,ERROR
	INC	HL
	DJNZ	ADD_5
;
;Now update info at start of file.
	LD	BC,1
	LD	DE,US_FCB
	CALL	DOS_POSIT
	JP	NZ,ERROR
	CALL	_US_RDREC
	JP	NZ,ERROR
;Update record and write.
	LD	BC,1		;Position fcb.
	LD	DE,US_FCB
	CALL	DOS_POSIT
	JP	NZ,ERROR
;
	LD	HL,(US_PMAX)
	LD	(UF_NCALLS),HL
	LD	HL,(US_UMAX)
	LD	(UF_UID),HL
	LD	HL,US_UBUFF
	LD	B,UF_LRL
ADD_6	LD	A,(HL)
	CALL	$PUT
	JP	NZ,ERROR
	INC	HL
	DJNZ	ADD_6
;
;Done! Now get data back (and check write!)
	LD	HL,NAME_BUFF
	CALL	USER_SEARCH
	JP	NZ,ERROR
;
;Successful! Close register log & return
	LD	DE,REGIST_FCB
	CALL	DOS_CLOSE
	JP	NZ,ERROR
	RET
;
PUT_CR	LD	A,CR
	CALL	$PUT
	RET
;
;instr: Check if one string contains another.
; input: HL=string to scan, DE=string to search for.
;output: Z= 'DE' string found within 'HL' string.
INSTR	LD	(S_STR),DE
	LD	(L_STR),HL
INS_01	LD	HL,(L_STR)
	LD	DE,(S_STR)
INS_02	LD	A,(HL)
	OR	A
	JR	Z,INS_03	;end of scan str
	LD	A,(DE)
	CALL	CI_CMP
	JR	Z,INS_04
	INC	HL
	JR	INS_02
INS_03	CP	1
	RET	;nz
INS_04	INC	HL
	LD	(L_STR),HL
	INC	DE
INS_05	LD	A,(DE)
	OR	A
	RET	Z	;found if end of DE
	CALL	CI_CMP
	JR	NZ,INS_01
	INC	HL
	INC	DE
	JR	INS_05
;
;End of logon2