;more: Assemble more, file paginator
;
ZETA		EQU	1
DEBUGF		EQU	0	;Function call debugging
DEBUGG		EQU	0	;Loop at start debug
SYSOPONLY	EQU	1	;Only the Sysop may run
REDIRDIS	EQU	1	;1 to disable redirection
STACKSIZE	EQU	100H	;Size of the stack
;
*GET	DOSCALLS
;
	IF	ZETA
*GET	EXTERNAL
*GET	ASCII
;
	COM	'<More 1.1b 18-Jan-88>'
	ORG	PROG_START
	DEFW	BASE
	DEFW	THIS_PROG_END
	DEFW	0
	DEFW	TERMINATE
;End of program load info.
	ORG	BASE+STACKSIZE
	ELSE
	ORG	5200H+STACKSIZE
;
	ENDIF
;
TOPSTACK	EQU	$
;
	IF	DEBUGF
*GET	DEBUGF
	ELSE
DEBUG	MACRO	#$STR
	ENDM
	ENDIF
;
START
	IF	ZETA
START1	DEC	HL
	LD	A,(HL)
	CP	' '
	JR	NC,START1
	INC	HL		;Pseudo start of cmd line
;
	LD	SP,TOPSTACK	;There is plenty of stack
	LD	(_CMDLINE),HL	;Save cmd line pointer
	LD	HL,1		;Disable redirection
	LD	(_NOREDIR),HL
;
	IF	SYSOPONLY
	LD	A,(PRIV_1)
	BIT	IS_SYSOP,A
	LD	A,0
	JP	Z,TERMINATE
	ENDIF
;
	ELSE
;
	LD	HL,(HIMEM)
	LD	SP,HL
;
	ENDIF
;
	IF	DEBUGG
DB_LOOP
	JP	DB_LOOP
	ENDIF
;
*GET	CINIT
*GET	CALL
;
*GET	MORE1
;
*GET	INDEX
*GET	STRCMP
*GET	STRLEN
;
	IF	ZETA
*GET	ROUTINES
*GET	LIBCZ
	ELSE
*GET	LIBC:1
	ENDIF
;
_CMDLINE	DEFW	4318H
_NOREDIR	DEFW	0
_BRKSIZE	DEFW	$+2
;
	IF	ZETA
THIS_PROG_END	EQU	$
	ENDIF
;
	END	START
