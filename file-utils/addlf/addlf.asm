;addlf.asm: Add LF after CR for CPM files, and ^Z
;
*GET	DOSCALLS
*GET	EXTERNAL
*GET	ASCII
;
	ORG	PROG_START
	DEFW	BASE
	DEFW	THIS_PROG_END
	DEFW	TERMINATE
	DEFW	TERMINATE
;End of program load info.
;
	COM	'<addlf 1.0  07-Aug-86>'
	ORG	BASE+100H
START	LD	SP,START
;
	LD	A,(HL)
	CP	CR
	JP	Z,USAGE
;
ADDLF	LD	A,(HL)
	OR	A
	JR	Z,EXIT
	CP	CR
	JR	Z,EXIT
	LD	(ARG),HL
;;	CP	'-'
;;	JR	Z,PARAM
	CALL	CONVFILE
NEXT	LD	HL,(ARG)
	CALL	BYP_WORD
	JR	ADDLF
;
;;PARAM	JR	NEXT
;
EXIT
	LD	A,1AH		;add a control Z
	LD	DE,($STDOUT)
	CALL	$PUT
;
	XOR	A
	JP	TERMINATE
;
CONVFILE
	LD	DE,FCB_ADDLF
	CALL	EXTRACT
	JP	NZ,NOFILE
	LD	HL,BUF_ADDLF
	LD	B,0
	CALL	DOS_OPEN_EX
	JP	NZ,NOFILE
;
LOOP	LD	DE,FCB_ADDLF
	CALL	$GET
	JP	NZ,EOF
	CP	CR
	JR	Z,LFADD
	LD	DE,($STDOUT)
	CALL	$PUT
	JR	LOOP
;
LFADD	LD	A,CR
	LD	DE,($STDOUT)
	CALL	$PUT
	LD	A,LF
	CALL	$PUT
	JR	LOOP
;
EOF	CP	1CH
	RET	Z
	CP	1DH
	RET	Z
	PUSH	AF
	OR	80H
	CALL	DOS_ERROR
	POP	AF
	JP	TERMINATE
;
USAGE	LD	HL,M_USAGE
	LD	DE,($STDOUT_DEF)
	CALL	MESS_0
	LD	A,1
	JP	TERMINATE
;
NOFILE	LD	HL,M_NOFILE
	LD	DE,($STDOUT_DEF)
	CALL	MESS_0
	LD	HL,(ARG)
	CALL	MESS_WORD
	LD	A,CR
	CALL	$PUT
	RET			;go for next file.
;
BYP_SP	LD	A,(HL)
	CP	' '
	RET	NZ
	INC	HL
	JR	BYP_SP
;
BYP_WORD
	LD	A,(HL)
	CP	CR
	RET	Z
	OR	A
	RET	Z
	CP	' '
	JR	Z,BYP_SP
	INC	HL
	JR	BYP_WORD
;
MESS_WORD
	LD	A,(HL)
	CP	CR
	RET	Z
	CP	' '
	RET	Z
	OR	A
	RET	Z
	CALL	$PUT
	INC	HL
	JR	MESS_WORD
;
*GET	ROUTINES
;
M_ADDLF	DEFM	'addlf: ',0
M_NOFILE	DEFM	'addlf: Cannot open ',0
M_USAGE	DEFM	'addlf: add an LF after every CR to files.',CR
	DEFM	'usage: addlf files ...',CR
	DEFM	'eg:    addlf myfile.txt >',CR,0
;
ARG	DEFW	0	;current file.
;
FCB_ADDLF	DEFS	32
BUF_ADDLF	DEFS	256
;
THIS_PROG_END	EQU	$
;
	END	START
