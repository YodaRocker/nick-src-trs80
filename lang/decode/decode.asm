;DECODE: DECODES A /REL FILE (UPD: 05/01/84).
; Assembled OK 30-Mar-85.
	ORG	8000H
DECODE	LD	HL,4318H
	CALL	NEXTWORD
	INC	HL
	PUSH	HL
	LD	DE,BUFFER1
	CALL	EXTRACT
	POP	HL
	CALL	NEXTWORD
	INC	HL
	LD	DE,BUFFER2
	CALL	EXTRACT
	LD	DE,BUFFER2
	LD	HL,DEFEXT2
	CALL	DEF$EXT
	LD	DE,BUFFER1
	LD	HL,DEFEXT1
	CALL	DEF$EXT
	LD	HL,BUFFER1
	CALL	4467H
	LD	A,20H
	CALL	0033H
	LD	A,'T'
	CALL	33H
	LD	A,'O'
	CALL	33H
	LD	A,' '
	CALL	33H
	LD	HL,BUFFER2
	CALL	4467H
	LD	A,13
	CALL	0033H
	LD	DE,BUFFER1
	LD	HL,BUFFRD1
	LD	B,0
	CALL	OPEN$EXST
	JP	NZ,ERROR
	LD	DE,BUFFER2
	LD	HL,BUFFWR2
	LD	B,0
	CALL	OPEN$NEW
	JP	NZ,ERROR
	LD	HL,MESSAGE
	CALL	4467H
	JP	MLOOP
; ALL CODE UNTIL THIS POINT IS COMMON.
NEXTWORD	INC	HL
	LD	A,(HL)
	CP	21H
	JR	NC,NEXTWORD
	RET
READ1	LD	DE,BUFFER1
	CALL	READBYTE
	RET	Z
	CP	28
	JP	NZ,ERROR
FINISH	LD	DE,BUFFER1
	CALL	CLOSE
	LD	DE,BUFFER2
	CALL	CLOSE
	JP	DOS
	RET
WRITE2	LD	DE,BUFFER2
	CALL	WRITBYTE
	JP	NZ,ERROR
	RET
READBIT	LD	A,(COUNTBIT)
	INC	A
	AND	7
	OR	A
	LD	(COUNTBIT),A
	LD	A,(NBIT)
	JR	NZ,REAV01
	CALL	READ1
REAV01	RLCA
	LD	(NBIT),A
	RET
MESSOUT	LD	A,(HL)
	OR	A
	RET	Z
	INC	HL
	PUSH	AF
	CALL	ALLOUT
	POP	AF
	CP	0DH
	JR	NZ,MESSOUT
	RET
ALLOUT	PUSH	AF
	CALL	0033H
	LD	A,(3840H)
	CP	4
	JP	Z,FINISH
STYX	LD	A,(38FFH)
	OR	A
	JR	NZ,STYX
	POP	AF
	CALL	WRITE2
	RET
MLOOP	CALL	READBIT
	JR	C,REL$ATIVE
	CALL	BITS$8
	CALL	HEX
	JR	MLOOP
BITS$8	LD	B,8
BITV01	PUSH	BC
	CALL	READBIT
	RL	L
	POP	BC
	DJNZ	BITV01
	LD	C,L
	RET
HEX	LD	A,C
	PUSH	AF
	AND	0F0H
	SRL	A
	SRL	A
	SRL	A
	SRL	A
	CP	0AH
	JR	C,HEXV01
	ADD	A,7
HEXV01	ADD	A,30H
	CALL	ALLOUT
	POP	AF
	AND	0FH
	CP	0AH
	JR	C,HEXV02
	ADD	A,7
HEXV02	ADD	A,30H
	CALL	ALLOUT
	LD	A,20H
	CALL	ALLOUT
	RET
REL$ATIVE	CALL	READBIT
	RL	C
	CALL	READBIT
	RL	C
	LD	A,C
	AND	3
	CP	0
	JR	Z,SPEC$ITEM
	CP	1
	JR	NZ,RELV11
	LD	HL,PRO$MES
RELV11	CP	2
	JR	NZ,RELV12
	LD	HL,DAT$MES
RELV12	CP	3
	JR	NZ,RELV13
	LD	HL,COM$MES
RELV13	LD	A,0DH
	CALL	ALLOUT
	CALL	MESSOUT
	CALL	BITS$8
	LD	H,L
	CALL	BITS$8
	LD	A,L
	LD	L,H
	LD	H,A
	LD	C,H
	CALL	HEX
	LD	C,L
	CALL	HEX
	LD	A,0DH
	CALL	ALLOUT
	JP	MLOOP
SPEC$ITEM	LD	A,0DH
	CALL	ALLOUT
	CALL	READBIT
	RL	C
	CALL	READBIT
	RL	C
	CALL	READBIT
	RL	C
	CALL	READBIT
	RL	C
	LD	A,C
	AND	0FH
	CP	15
	JR	NZ,SPEV01
	LD	HL,MENDFIL
	CALL	MESSOUT
	JP	FINISH
SPEV01	CP	5
	JR	NC,SPEV10
	CP	0
	JR	NZ,SPEV02
	LD	HL,ENTRY$MES
SPEV02	CP	1
	JR	NZ,SPEV03
	LD	HL,SELCOM$MES
SPEV03	CP	2
	JR	NZ,SPEV04
	LD	HL,PRONAM$MES
SPEV04	CP	3
	JR	NZ,SPEV05
	LD	HL,REQSER$MES
SPEV05	CP	4
	JR	NZ,SPEV06
	LD	HL,RESER$MES
SPEV06	CALL	MESSOUT
	CALL	PRINT$B
	JP	MLOOP
SPEV10	CP	9
	JR	NC,SPEV20
	CP	5
	JR	NZ,SPEV11
	LD	HL,DEFCOM$MES
SPEV11	CP	6
	JR	NZ,SPEV12
	LD	HL,CHAEXT$MES
SPEV12	CP	7
	JR	NZ,SPEV13
	LD	HL,DEFENT$MES
SPEV13	CP	8
	JR	NZ,SPEV14
	LD	HL,RESER$MES
SPEV14	CALL	MESSOUT
	CALL	PRINT$A
	CALL	PRINT$B
	JP	MLOOP
SPEV20	CP	9
	JR	NZ,SPEV21
	LD	HL,EXTOFF$MES
SPEV21	CP	10
	JR	NZ,SPEV22
	LD	HL,DFSZDA$MES
SPEV22	CP	11
	JR	NZ,SPEV23
	LD	HL,LOADLOC$MES
SPEV23	CP	12
	JR	NZ,SPEV24
	LD	HL,CHADD$MES
SPEV24	CP	13
	JR	NZ,SPEV25
	LD	HL,DEFPSIZ$MES
SPEV25	CP	14
	JR	NZ,SPEV26
	LD	HL,ENDPRG$MES
	CALL	MESSOUT
	CALL	PRINT$A
ZXCV01	LD	A,(38FFH)
	OR	A
	JR	Z,ZXCV01
SPEVV01	LD	A,(COUNTBIT)
	CP	7
	JP	Z,MLOOP
	CALL	READBIT
	JR	SPEVV01
SPEV26	CALL	MESSOUT
	CALL	PRINT$A
	LD	A,0DH
	CALL	ALLOUT
	JP	MLOOP
PRINT$A	CALL	READBIT
	RL	C
	CALL	READBIT
	RL	C
	LD	A,C
	AND	3
	CP	0
	JR	NZ,PRIV01
	LD	HL,ABS$MES
PRIV01	CP	1
	JR	NZ,PRIV02
	LD	HL,PRO$MES
PRIV02	CP	2
	JR	NZ,PRIV03
	LD	HL,DAT$MES
PRIV03	CP	3
	JR	NZ,PRIV04
	LD	HL,COM$MES
PRIV04	CALL	MESSOUT
	CALL	BITS$8
	LD	H,L
	CALL	BITS$8
	LD	A,L
	LD	L,H
	LD	H,A
	LD	C,H
	CALL	HEX
	LD	C,L
	CALL	HEX
	LD	A,20H
	CALL	ALLOUT
	RET
PRINT$B	CALL	READBIT
	RL	C
	CALL	READBIT
	RL	C
	CALL	READBIT
	RL	C
	LD	A,C
	AND	7
	LD	B,A
PRAV01	PUSH	BC
	CALL	BITS$8
	LD	A,L
	CALL	ALLOUT
	POP	BC
	DJNZ	PRAV01
	LD	A,0DH
	CALL	ALLOUT
	RET
ERROR	EQU	4409H
OPEN$NEW	EQU	4420H
OPEN$EXST	EQU	4424H
CLOSE	EQU	4428H
DEF$EXT	EQU	4473H
READBYTE	EQU	0013H
EXTRACT	EQU	441CH
WRITBYTE	EQU	001BH
DOS	EQU	402DH
DEFEXT1	DEFM	'REL'
DEFEXT2	DEFM	'RL2'
BUFFER1	DEFS	32
BUFFER2	DEFS	32
BUFFRD1	DEFS	256
BUFFWR2	DEFS	256
MESSAGE	DEFM	'OPENED FILES O.K.'
	DEFB	0DH
PRO$MES	DEFM	'PROGRAM RELATIVE: '
	DEFB	00H
DAT$MES	DEFM	'DATA RELATIVE: '
	DEFB	00H
COM$MES	DEFM	'COMMON RELATIVE: '
	DEFB	00H
ENTRY$MES	DEFM	'ENTRY SYMBOL: '
	DEFB	0
SELCOM$MES	DEFM	'SELECT COMMON BLOCK: '
	DEFB	0
PRONAM$MES	DEFM	'PROGRAM NAME: '
	DEFB	0
REQSER$MES	DEFM	'REQUEST LIBRARY SEARCH: '
	DEFB	0
RESER$MES	DEFM	'RESERVED: '
	DEFB	0
MENDFIL	DEFM	'END OF FILE.'
	DEFB	0DH
DEFCOM$MES	DEFM	'DEFINE COMMON SIZE: '
	DEFB	0
CHAEXT$MES	DEFM	'CHAIN EXTERNAL: '
	DEFB	0
DEFENT$MES	DEFM	'DEFINE ENTRY POINT: '
	DEFB	0
EXTOFF$MES	DEFM	'EXTERNAL + OFFSET: '
	DEFB	0
DFSZDA$MES	DEFM	'DEFINE SIZE DATA AREA: '
	DEFB	0
LOADLOC$MES	DEFM	'SET LOAD COUNTER: '
	DEFB	0
CHADD$MES	DEFM	'CHAIN ADDRESS: '
	DEFB	0
DEFPSIZ$MES	DEFM	'DEFINE PROGRAM SIZE: '
	DEFB	0
ENDPRG$MES	DEFM	'END PROGRAM ON BOUNDARY: '
	DEFB	0
ABS$MES	DEFM	'ABSOLUTE: '
	DEFB	0
COUNTBIT	DEFB	7
NBIT	DEFB	0
	END	DECODE
