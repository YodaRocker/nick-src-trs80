;unpack: Newdos version of Unix unpack utility
;
*GET	DOSCALLS
*GET	ASCII
;
RS	EQU	1EH	;magic numbers
US	EQU	1FH	;magic numbers
;
	COM	'<Unpack version 0.1 - 21-Sep-86>'
	ORG	5300H
START	LD	SP,START
	LD	A,(HL)
	CP	CR
	JP	Z,USAGE
	LD	(FILENAME),HL
	LD	DE,Z_FCB
	CALL	DOS_EXTRACT
	JP	NZ,ERROR
;
	LD	DE,OUT_FCB
	CALL	DOS_EXTRACT
	JP	NZ,ERROR
;
	LD	DE,Z_FCB
	LD	HL,Z_BUF
	LD	B,0
	CALL	DOS_OPEN_EX
	JP	NZ,ERROR
;
	LD	DE,OUT_FCB
	LD	HL,OUT_BUF
	LD	B,0
	CALL	DOS_OPEN_NEW
	JP	NZ,ERROR
	CALL	GETDICT		;read dictionary
	JP	NZ,UNPACK_ERR
	CALL	DECODE		;decode the file.
	JP	NZ,UNPACK_ERR
;
	LD	DE,OUT_FCB
	CALL	DOS_CLOSE
	JP	NZ,ERROR
	XOR	A
	JP	DOS
;
;getdict: read in the dictionary.
GETDICT
	CALL	GETZ
	CP	US
	JP	NZ,NOT_PACKED
	CALL	GETZ
	CP	US
	JP	Z,OLD_PACKED
	CP	RS
	JP	NZ,NOT_PACKED
;
	LD	HL,ORIGSIZE
	CALL	GETZ
	LD	(HL),A
	INC	HL
	CALL	GETZ
	LD	(HL),A
	INC	HL
	CALL	GETZ
	LD	(HL),A
	INC	HL
	CALL	GETZ
	LD	(HL),A
;
	CALL	GETZ
	LD	(MAXLEV),A
;
	LD	B,A
	LD	HL,INTNODES
PC_A1	CALL	GETZ
	LD	(HL),A
	INC	HL
	LD	(HL),0
	INC	HL
	DJNZ	PC_A1
;
	LD	HL,TREE
	LD	(TREEPTR),HL
	LD	HL,INTNODES
	LD	(INTNPTR),HL
	LD	A,(MAXLEV)
	LD	B,A
	LD	HL,CHARACTERS
PC_A2	PUSH	BC
	EX	DE,HL
	LD	HL,(TREEPTR)
	LD	(HL),E
	INC	HL
	LD	(HL),D
	INC	HL
	LD	(TREEPTR),HL
	LD	HL,(INTNPTR)
	LD	C,(HL)
	INC	HL
	INC	HL
	LD	(INTNPTR),HL
	EX	DE,HL
	LD	A,C
	OR	A
	JR	Z,PC_A4
PC_A3	CALL	GETZ
	LD	(HL),A
	INC	HL
	DEC	C
	JR	NZ,PC_A3
PC_A4	POP	BC
	DJNZ	PC_A2
;
	CALL	GETZ
	LD	(HL),A
	INC	HL
	LD	(EOF),HL
;
	LD	HL,(INTNPTR)
	DEC	HL
	LD	D,(HL)
	DEC	HL
	LD	E,(HL)
	INC	DE
	INC	DE		;add 2
	LD	(HL),E
	INC	HL
	LD	(HL),D
;
;convert intnodes{i} to be number of internal nodes
;possessed by level i.
	LD	HL,0
	LD	(NCHILDREN),HL
;
	LD	A,(MAXLEV)
	DEC	A
	LD	C,A
	LD	B,0		;bc=maxlev-1
	LD	HL,INTNODES
	ADD	HL,BC
	ADD	HL,BC
	LD	(INTNPTR),HL	;=intnodes(maxlev-1)
;
	LD	B,C
	INC	B		;do it MAXLEV times
PC_A5	PUSH	BC
	LD	HL,(INTNPTR)
	LD	E,(HL)
	INC	HL
	LD	D,(HL)		;de=intnodes(i-1)
	PUSH	DE
	LD	HL,(NCHILDREN)
	SRL	H
	RR	L
	LD	(NCHILDREN),HL
	EX	DE,HL		;nchildren in DE
	LD	HL,(INTNPTR)
	LD	(HL),E
	INC	HL
	LD	(HL),D
	DEC	HL
	DEC	HL
	DEC	HL
	LD	(INTNPTR),HL
	LD	HL,(NCHILDREN)
	POP	DE
	ADD	HL,DE
	LD	(NCHILDREN),HL
	POP	BC
	DJNZ	PC_A5
;
	XOR	A
	RET
;End of GETDICT
;
DECODE
	LD	HL,0
	LD	(LEV),HL	;(in C is level 1)
	LD	HL,0
	LD	(_I),HL
DEC_LP
	CALL	GETZ
	LD	L,A
	LD	H,0
	LD	(_C),HL
	LD	A,8
	LD	(BITSLEFT),A
DEC_LP2
	LD	A,(BITSLEFT)
	DEC	A
	LD	(BITSLEFT),A
	JP	M,DEC_ELP2
;level 3
	LD	HL,(_I)
	ADD	HL,HL
	LD	(_I),HL
	LD	HL,(_C)
	LD	A,128		;bit 7 of char
	AND	L
	JR	Z,DEC_01
	LD	HL,(_I)
	INC	HL
	LD	(_I),HL		;i++
DEC_01	LD	HL,(_C)		;c <<= 1;
	ADD	HL,HL
	LD	(_C),HL
;
	LD	HL,INTNODES
	LD	DE,(LEV)
	ADD	HL,DE
	ADD	HL,DE
	LD	E,(HL)		;intnodes(lev)
	INC	HL
	LD	D,(HL)
	LD	HL,(_I)
	OR	A
	SBC	HL,DE		;i-intnodes(lev)
	LD	(J),HL
	JP	C,DEC_ELSE	;j<0
;
	LD	HL,TREE
	LD	DE,(LEV)
	ADD	HL,DE
	ADD	HL,DE
	LD	E,(HL)
	INC	HL
	LD	D,(HL)
	EX	DE,HL		;hl=tree(lev)
	LD	DE,(J)
	ADD	HL,DE
	LD	(_P),HL		;&tree(lev)(j)
;
	LD	DE,(EOF)
	OR	A
	SBC	HL,DE
	JP	Z,TRUE_EOF
;*** test here for eof .... ***
	LD	HL,(_P)
	LD	A,(HL)
	CALL	OUTPUT
	LD	HL,ORIGSIZE
	CALL	LONGDEC
	LD	HL,0
	LD	(LEV),HL
	LD	HL,0
	LD	(_I),HL
	JR	DEC_EELSE
;
DEC_ELSE
	LD	HL,(LEV)
	INC	HL
	LD	(LEV),HL
DEC_EELSE
	JP	DEC_LP2
DEC_ELP2
	JP	DEC_LP
;
TRUE_EOF
	XOR	A
	RET
;
OLD_PACKED
	LD	HL,M_OLD
	CALL	MESS
	JP	RET_NZ
NOT_PACKED
	LD	HL,M_NOT
	CALL	MESS
	JP	RET_NZ
USAGE	LD	HL,M_USAGE
	CALL	MESS
	JP	DOS
ERROR	PUSH	AF
	OR	80H
	CALL	DOS_ERROR
	POP	AF
	JP	DOS
UNPACK_ERR
	LD	HL,M_ERR
	CALL	MESS
	JP	DOS
;
MESS	LD	A,(HL)
	OR	A
	RET	Z
	CALL	33H
	INC	HL
	JR	MESS
;
OUTPUT
	LD	DE,OUT_FCB
	CALL	$PUT
	RET
;
LONGDEC
	INC	HL
	INC	HL
	INC	HL
	DEC	(HL)
	RET	NZ
	DEC	HL
	DEC	(HL)
	RET	NZ
	DEC	HL
	DEC	(HL)
	RET	NZ
	DEC	HL
	DEC	(HL)
	RET
;
RET_NZ	OR	A
	RET	NZ
	CP	1
	RET
;
GETZ	PUSH	DE
	LD	DE,Z_FCB
	CALL	$GET
	POP	DE
	RET	Z
	JP	ERROR
;
ORIGSIZE	DC	4,0	;long
EOF		DEFW	0	;eof position.
MAXLEV		DEFW	0	;int
INTNODES	DC	50,'I'	;25 x int
TREE		DC	48,'T'	;24 x ptr to char
CHARACTERS	DEFS	256	;256 x char
;
INTNPTR		DEFW	0	;pointer to intnodes
TREEPTR		DEFW	0	;pointer to tree
;
NCHILDREN	DEFW	0
;
_I	DEFW	0
J	DEFW	0
_C	DEFW	0
_P	DEFW	0
BITSLEFT	DEFB	0
LEV	DEFW	0
;
M_OLD	DEFM	'Oldstyle packing not supported',CR,0
M_NOT	DEFM	'Not packed',CR,0
M_USAGE	DEFM	'Usage: unpack infile outfile',CR,0
M_ERR	DEFM	'unpack: could not unpack',CR,0
;
FILENAME	DEFW	0	;pointer
;
Z_FCB	DEFS	32
OUT_FCB	DEFS	32
Z_BUF	DEFS	256
OUT_BUF	DEFS	256
;
	END	START