;Ankhmail : Process files received from Fidonet
;
ZETA	EQU	1
;
*GET	DOSCALLS
;
	IF	ZETA
*GET	EXTERNAL.HDR
*GET	ASCII.HDR
;
	COM	'<Ankhmail 1.1a 28-Jan-88>'
	ORG	PROG_START
	DEFW	BASE
	DEFW	THIS_PROG_END
	DEFW	0
	DEFW	0
;End of program load info.
	ORG	BASE+100H
	ELSE
	ORG	5200H
;
	ENDIF
;
;;*GET	DEBUG:1
DEBUG	MACRO	#$STR
	ENDM
;
START
	IF	ZETA
START1	DEC	HL
	LD	A,(HL)
	CP	' '
	JR	NC,START1
	INC	HL		;Pseudo start of cmd line
;
	LD	SP,START	;There is plenty of stack
	LD	(_CMDLINE),HL	;Save cmd line pointer
	LD	HL,1		;Disable redirection
	LD	(_NOREDIR),HL
;
	LD	A,(PRIV_1)
	BIT	IS_SYSOP,A
	LD	A,0
	JP	Z,TERMINATE
;
	ELSE
;
	LD	HL,(HIMEM)
	LD	SP,HL
;
	ENDIF
;
*GET	CINIT:1
*GET	CALL:1
;
*GET	ANKHMAI1
;
*GET	ARCSUBS
;;*GET	ATOI
;;*GET	CTYPE
*GET	FTELL
;;*GET	FWRITE
;;*GET	INDEX
*GET	STRCMP
;;*GET	STRLEN
*GET	SYSTEM
*GET	UNLINK
*GET	WILD
;
	IF	ZETA
*GET	ROUTINES.LIB
*GET	LIBCZ
	ELSE
*GET	LIBC
	ENDIF
;
_CMDLINE	DEFW	4318H
_NOREDIR	DEFW	0
;
HIGHEST	DEFW	$+2
;
	IF	ZETA
THIS_PROG_END	EQU	$
	ENDIF
;
	END	START
