;FromCPM: Change CRLF in CP/M file to CR.
;17-Dec-85: Now has 4K buffered input.
;21-Sep-86: Now stops when it sees a ^Z in the file.
;
*GET	DOSCALLS
;
CR	EQU	0DH
LF	EQU	0AH
CTRLZ	EQU	1AH
;
	COM	'<fromcpm ver 1.1 21-Sep-86>'
;
	ORG	5300H
START	LD	SP,START
	LD	DE,FCB_I
	CALL	DOS_EXTRACT
	LD	DE,FCB_O
	CALL	DOS_EXTRACT
	LD	HL,BUF_I
	LD	DE,FCB_I
	LD	B,0
	CALL	DOS_OPEN_EX
	JP	NZ,DOS_ERROR
;
	LD	HL,BUF_O
	LD	DE,FCB_O
	LD	B,0
	CALL	DOS_OPEN_NEW
	JP	NZ,DOS_ERROR
;
LOOP	LD	DE,FCB_I
	CALL	BUF_GET
	JR	NZ,END_OF_FILE
	CP	CTRLZ
	JR	Z,END_OF_FILE
	CP	CR
	JR	NZ,PUTCHAR
	LD	A,CR
	LD	DE,FCB_O
	CALL	$PUT
	JP	NZ,DOS_ERROR
	LD	DE,FCB_I
	CALL	BUF_GET
	JP	NZ,END_OF_FILE
	CP	LF
	JR	Z,LOOP
PUTCHAR
	LD	DE,FCB_O
	CALL	$PUT
	JP	NZ,DOS_ERROR
	JR	LOOP
;
END_OF_FILE
	LD	DE,FCB_O
	CALL	DOS_CLOSE
	JP	NZ,DOS_ERROR
	LD	DE,FCB_I
	CALL	DOS_CLOSE
	JP	NZ,DOS_ERROR
	JP	DOS
;
BUF_GET
	LD	HL,(BUF_POS)
	LD	DE,BUF_END
	CALL	CPHLDE
	CALL	Z,FILL_BUF
	LD	HL,(BUF_POS)
	LD	DE,(BUF_ERR)
	CALL	CPHLDE
	CALL	Z,SET_ERR
	LD	A,(HL)
	LD	HL,ERR_FLAG
	BIT	0,(HL)
	RET	NZ
	LD	HL,(BUF_POS)
	INC	HL
	LD	(BUF_POS),HL
	CP	A
	RET
;
CPHLDE	OR	A
	PUSH	HL
	SBC	HL,DE
	LD	A,H
	OR	L
	POP	HL
	RET
;
SET_ERR	LD	A,1
	LD	(ERR_FLAG),A
	RET
;
FILL_BUF
	LD	HL,BUF_ST
	LD	(BUF_POS),HL
FB_1	LD	DE,BUF_END
	CALL	CPHLDE
	RET	Z
	LD	DE,FCB_I
	CALL	$GET
	LD	(HL),A
	INC	HL
	JR	Z,FB_1
	DEC	HL
	LD	(BUF_ERR),HL
	RET
;
BUF_ERR		DEFW	0
ERR_FLAG	DEFB	0
BUF_POS		DEFW	BUF_END
;
FCB_I	DEFS	32
FCB_O	DEFS	32
BUF_I	DEFS	256
BUF_O	DEFS	256
;
BUF_ST	DEFS	4096
BUF_END	EQU	$
;
	END	START
