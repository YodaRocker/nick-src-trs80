;GRANULES: FINDS # FREE GRANULES ON A DISK.
; ALSO PRINTS 'AUTO' MESSAGE FOR MULTIPLE DISKS.
; Assembled OK 30-Mar-85.
	ORG	5200H
DIRT	LD	HL,MESS2
	CALL	4467H
	LD	A,'*'
	LD	(3C3FH),A
	CALL	0049H
	CP	1
	JP	Z,402DH
	LD	A,32
	LD	(3C3FH),A
	LD	A,0
	CALL	490AH
	LD	HL,42D0H
	LD	DE,DNAME
	LD	BC,8
	LDIR
	LD	HL,DNAME
	CALL	4467H
	LD	HL,MESS
	CALL	4467H
	LD	HL,4200H
	LD	B,5FH
	LD	C,0
LOOP	LD	A,(HL)
	RRCA
	JR	C,P1
	INC	C
P1	RRCA
	JR	C,P2
	INC	C
P2	INC	HL
	DJNZ	LOOP
	LD	L,C
	LD	H,0
	LD	DE,100
	CALL	GET
	LD	DE,10
	CALL	GET
	LD	DE,1
	CALL	GET
	LD	A,0DH
	CALL	33H
	LD	HL,42E0H
	CALL	4467H
	LD	A,'*'
	LD	(3C3FH),A
	JR	DIRT
GET	LD	B,2FH
GETV01	INC	B
	OR	A
	SBC	HL,DE
	JR	NC,GETV01
	ADD	HL,DE
	LD	A,B
	CALL	0033H
	RET
MESS	DEFM	':  GRANULES FREE ='
	DEFB	03H
DNAME	DEFM	'NOTNAMED'
	DEFB	03H
MESS2	DEFM	'HIT A KEY TO READ DISK, OR <BREAK>'
	DEFB	0DH
	END	DIRT