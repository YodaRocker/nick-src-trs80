;ptrlog: Log all output from LOG_MSG to disk.
;
*GET	DOSCALLS.HDR
*GET	EXTERNAL.HDR
*GET	ASCII.HDR
*GET	PROGNUMB.HDR
;
	COM	'<Ptrlog 1.3b 02-Apr-88>'
	ORG	BASE+100H
START	LD	SP,START
;
;Allocate a page for the 1k buffer.
	LD	A,NUM_PTRLOG
	CALL	ALLOC_PAGE
	LD	(BUFF_PAGENUM),A
	LD	HL,TEMP_RAM
	LD	(BUFF_PTR),HL
;
	LD	HL,LOG_BYTE
	SET	ON_DISK,(HL)
;
	LD	HL,(HIMEM)
	LD	DE,EN_CODE-ST_CODE
	OR	A
	SBC	HL,DE
	LD	(HIMEM),HL
	INC	HL
;
	LD	(LOG_MSG+1),HL		;set hook.
	LD	A,0C3H
	LD	(LOG_MSG),A
;
	PUSH	HL
	LD	DE,ST_CODE
	OR	A
	SBC	HL,DE
	EX	DE,HL
;
	LD	HL,(RELOC1+1)
	ADD	HL,DE
	LD	(RELOC1+1),HL
;
	LD	HL,(RELOC2+1)
	ADD	HL,DE
	LD	(RELOC2+1),HL
;
	LD	HL,(RELOC3+1)
	ADD	HL,DE
	LD	(RELOC3+1),HL
;
	LD	HL,(RELOC4+1)
	ADD	HL,DE
	LD	(RELOC4+1),HL
;
	LD	HL,(RELOC5+1)
	ADD	HL,DE
	LD	(RELOC5+1),HL
;
	LD	HL,(RELOC6+1)
	ADD	HL,DE
	LD	(RELOC6+1),HL
;
	LD	HL,(RELOC7+1)
	ADD	HL,DE
	LD	(RELOC7+1),HL
;
	LD	HL,(RELOC8+1)
	ADD	HL,DE
	LD	(RELOC8+1),HL
;
	LD	HL,(RELOC9+1)
	ADD	HL,DE
	LD	(RELOC9+1),HL
;
	LD	HL,(RELOC10+1)
	ADD	HL,DE
	LD	(RELOC10+1),HL
;
	LD	HL,(RELOC11+1)
	ADD	HL,DE
	LD	(RELOC11+1),HL
;
	LD	HL,(RELOC12+1)
	ADD	HL,DE
	LD	(RELOC12+1),HL
;
	LD	HL,(RELOC13+1)
	ADD	HL,DE
	LD	(RELOC13+1),HL
;
	LD	HL,(RELOC14+1)
	ADD	HL,DE
	LD	(RELOC14+1),HL
;
	LD	HL,(RELOC15+1)
	ADD	HL,DE
	LD	(RELOC15+1),HL
;
	LD	HL,(RELOC16+1)
	ADD	HL,DE
	LD	(RELOC16+1),HL
;
	LD	HL,(RELOC17+1)
	ADD	HL,DE
	LD	(RELOC17+1),HL
;
	LD	HL,(RELOC18+2)	;it is LD DE,(nn)...
	ADD	HL,DE
	LD	(RELOC18+2),HL
;
	LD	HL,(RELOC19+1)
	ADD	HL,DE
	LD	(RELOC19+1),HL
;
	POP	DE
	LD	HL,ST_CODE
	LD	BC,EN_CODE-ST_CODE
	LDIR
;
	LD	DE,(RELOC14+1)	;fcb addr.
	LD	HL,(RELOC15+1)	;buffer addr.
	LD	B,0
	CALL	DOS_OPEN_NEW
	JR	NZ,CANT_OPEN
	INC	DE
	LD	A,(DE)
	AND	0F8H		;unprotect file.
	LD	(DE),A
	DEC	DE
	CALL	DOS_POS_EOF
	JP	DOS		;Auth.
;
CANT_OPEN
	LD	HL,LOG_BYTE
	RES	ON_DISK,(HL)
	JP	DOS		;Auth.
;
ST_CODE				;Relocatable routine.
;
_LOG_MSG
RELOC1	LD	A,(BUFF_PAGENUM)
	LD	B,TEMP_PAGEX
	PUSH	HL
	CALL	SWAP_PAGE
	POP	HL
	LD	A,C
RELOC2	LD	(OLD_PAGE),A
;
_LOG_MSG_1
	LD	A,(HL)
	OR	A
	JR	Z,_LOG_MSG_2
	LD	C,A
	PUSH	HL
RELOC3	CALL	_LOG_ONE
	POP	HL
	INC	HL
	JR	_LOG_MSG_1
;
_LOG_MSG_2
RELOC4	LD	A,(OLD_PAGE)
	LD	B,TEMP_PAGEX
	CALL	SWAP_PAGE
	RET
;
_LOG_ONE
	LD	A,C
	CP	1		;close & re-open
	JR	Z,CLOSE_OPEN
	CP	3		;close file only
	JR	Z,CLOSE_ONLY
	CP	4		;Open file only.
	JR	Z,OPEN_ONLY
;
	LD	A,(LOG_BYTE)	;anything else.
	BIT	ON_DISK,A
	RET	Z		;ignore.
;
	LD	A,C
RELOC5	LD	HL,(BUFF_PTR)	;Put in buffer.
	LD	(HL),A
	INC	HL
RELOC6	LD	(BUFF_PTR),HL
	LD	A,L		;Check if page full
	OR	A
	RET	NZ
	LD	A,H
	AND	3
	RET	NZ
RELOC7	CALL	FLUSH		;If it is full.
	RET
;
CLOSE_ONLY
RELOC8	CALL	DISK_CLOSE
	JR	_LOG_MSG_2
OPEN_ONLY
RELOC9	CALL	DISK_REOPEN
	JR	_LOG_MSG_2
CLOSE_OPEN
RELOC10	CALL	DISK_CLOSE
RELOC11	CALL	DISK_REOPEN
	JR	_LOG_MSG_2
;
DISK_CLOSE
RELOC12	CALL	FLUSH
RELOC13	LD	DE,LOG_FCB
	CALL	DOS_CLOSE
	JR	SET_NO_DISK
;
DISK_REOPEN
RELOC14	LD	DE,LOG_FCB
RELOC15	LD	HL,LOG_BUF
	LD	B,0
	CALL	DOS_OPEN_EX
	JR	NZ,NO_DISK
;
	INC	DE		;Unprotect
	LD	A,(DE)
	AND	0F8H
	LD	(DE),A
	DEC	DE
;
	CALL	DOS_POS_EOF
	LD	HL,LOG_BYTE
	SET	ON_DISK,(HL)
	LD	HL,TEMP_RAM
RELOC19	LD	(BUFF_PTR),HL
	RET
;
NO_DISK
	CALL	DOS_POS_EOF
	CALL	DOS_CLOSE
SET_NO_DISK
	LD	HL,LOG_BYTE
	RES	ON_DISK,(HL)
	RET
;
FLUSH	LD	HL,TEMP_RAM
FLUSH_1
	PUSH	HL
RELOC18	LD	DE,(BUFF_PTR)
	OR	A
	SBC	HL,DE
	POP	HL
	JR	Z,FLUSH_2
	LD	A,(HL)
	INC	HL
RELOC16	LD	DE,LOG_FCB
	CALL	$PUT
	JR	NZ,NO_DISK
	JR	FLUSH_1
;
FLUSH_2
	LD	HL,TEMP_RAM
RELOC17	LD	(BUFF_PTR),HL
	RET
;
;Data follows.
BUFF_PTR	DEFW	0
BUFF_PAGENUM	DEFB	0
OLD_PAGE	DEFB	0
;
LOG_FCB	DEFM	'printer.log',CR
	DC	32-12,0
LOG_BUF	DC	256,0
;
EN_CODE	NOP
;
	END	START