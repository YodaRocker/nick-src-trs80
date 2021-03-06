;preshell: Before the shell.
;
*GET	DOSCALLS
*GET	EXTERNAL
*GET	ASCII
;
	ORG	PROG_START
	DEFW	BASE
	DEFW	THIS_PROG_END
	DEFW	0
	DEFW	TERMINATE
;End of program load info.
;
	COM	'<Preshell 1.0f 10 Apr 90>'
	ORG	BASE+100H
START	LD	SP,START
;
;.login files etc...
	CALL	DOT_LOGIN
;
LOOP	CALL	SHELL
	LD	HL,M_BYE
	LD	DE,$2
	CALL	MESS_0
	JR	LOOP
;
DOT_LOGIN
;;	LD	HL,CMD_NOTE
;;	CALL	CALL_PROG
;;	LD	HL,CMD_WISDOM
;;	CALL	CALL_PROG
	RET
;
SHELL
	LD	A,(PRIV_2)
	BIT	IS_VISITOR,A
	JR	Z,SHELL_1
;
	LD	HL,CMD_MENU
	CALL	CALL_PROG
	JP	TERMINATE
SHELL_1
	LD	HL,CMD_SHELL
	CALL	CALL_PROG
	RET	Z
	JP	TERMINATE
;
*GET	ROUTINES
;
CMD_NOTE	DEFM	'note -r',CR,0
CMD_SHELL	DEFM	'shell',CR,0
CMD_MENU	DEFM	'menu -',CR,0
CMD_WISDOM	DEFM	'wisdom',CR,0
;
M_BYE	DEFM	'Use "logout" to logout.',CR,0
;
THIS_PROG_END	EQU	$
;
	END	START
