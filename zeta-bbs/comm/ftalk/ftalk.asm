;Ftalk:  Send mail packet (and file attaches)
DOS_WRITE_EOF	EQU	4451H
;
*GET	DOSCALLS.HDR
*GET	EXTERNAL.HDR
*GET	ASCII.HDR
*GET	RS232.HDR
*GET	FIDONET.HDR
;
	ORG	PROG_START
	DEFW	BASE
	DEFW	THIS_PROG_END
	DEFW	0
	DEFW	0	;Was fido_lost
;End of program load info.
;
	COM	'<FTalk 1.2f 23-Apr-89>'
	ORG	BASE+100H
START	LD	SP,START
;
	LD	A,(PRIV_1)
	BIT	IS_SYSOP,A
	JP	Z,TERMINATE
;
;Usage: Ftalk  [-cd] net/node
	LD	A,(HL)
	CP	'-'
	JR	NZ,ST_00C
	INC	HL
	LD	A,(HL)
	INC	HL
	INC	HL
	AND	5FH
	CP	'D'
	JR	NZ,ST_00A
	LD	A,1
	LD	(D_FLAG),A
	JR	ST_00C
ST_00A
	CP	'C'
	JR	NZ,ST_00B
	LD	A,1
	LD	(C_FLAG),A
	JR	ST_00C
ST_00B
ST_00C
	CALL	CONVFILE	;Change n/n to filename
;
	CALL	IS_MAIL		;make mail packet
;
	XOR	A
	LD	(FATAL),A
;
	LD	HL,M_DIAL1	;Ftalk...
	CALL	LOG_MSG_2
;
	CALL	DIAL_FIDO	;Dial 'im up
	CALL	WHACK_CR	;Connection stuff
	CALL	MAIL_SEND	;Send mail packet
	CALL	FILE_SEND	;Send file attaches
;
	LD	A,(D_FLAG)	;If we dialled, or
	LD	B,A
	LD	A,(C_FLAG)	;If we connected
	OR	B
	CALL	NZ,PICK_FIDO	;Then pickup.
;
	CALL	SAVE_PACKET	;Save old outgoing mail
	CALL	DISC_FIDO	;Disconnect
	XOR	A
;
EXIT_FTALK
	JP	TERMINATE
;
CONVFILE
	EX	DE,HL
	LD	HL,0
	CALL	GETINT
	LD	(TO_NET),HL
	LD	A,(DE)
	CP	'/'
	RET	NZ
	INC	DE
	LD	HL,0
	CALL	GETINT
	LD	(TO_NODE),HL
;
	LD	HL,(TO_NET)
	LD	DE,PKTNAME
	CALL	TO_HEX
	LD	A,(PKTNAME)
	ADD	A,11H
	LD	(PKTNAME),A
;
	LD	HL,(TO_NODE)
	LD	DE,PKTNAME+4
	CALL	TO_HEX
	LD	A,(PKTNAME+4)
	ADD	A,11H
	LD	(PKTNAME+4),A
;
	XOR	A
	LD	(PKTNAME+8),A
	RET
;
GETINT	LD	A,(DE)
	CP	'9'+1
	RET	NC
	CP	'0'
	RET	C
	SUB	'0'
	PUSH	HL
	POP	BC
	ADD	HL,HL
	ADD	HL,HL
	ADD	HL,BC
	ADD	HL,HL
	LD	C,A
	LD	B,0
	ADD	HL,BC
	INC	DE
	JR	GETINT
;
TO_HEX	LD	A,H
	CALL	TO_HEX_1
	LD	A,L
	CALL	TO_HEX_1
	RET
;
TO_HEX_1
	LD	C,A
	AND	0F0H
	SRL	A
	SRL	A
	SRL	A
	SRL	A
	CALL	TO_HEX_2
	LD	A,C
	AND	0FH
	CALL	TO_HEX_2
	RET
;
TO_HEX_2
	CP	10
	JR	C,TO_HEX_3
	ADD	A,7
TO_HEX_3
	ADD	A,'0'
	LD	(DE),A
	INC	DE
	RET
;
IS_MAIL
	LD	HL,PKTNAME
	LD	DE,PKT_FCB
	CALL	STRCPY
	LD	HL,FILE_TRAIL1
	CALL	STRCAT
	LD	A,CR
	LD	(DE),A
;
	LD	HL,PKTNAME
	LD	DE,FA_FCB
	CALL	STRCPY
	LD	HL,FILE_TRAIL2
	CALL	STRCAT
	LD	A,CR
	LD	(DE),A
;
	LD	DE,PKT_FCB
	LD	HL,PKT_BUF
	LD	B,60
	CALL	DOS_OPEN_NEW
	RET	NC		;Existing
	LD	HL,(TO_NET)
	LD	(DUMMY_NET),HL
	LD	HL,(TO_NODE)
	LD	(DUMMY_NODE),HL
;
	LD	HL,DUMMY_PKT
	LD	DE,PKT_FCB
	CALL	DOS_WRIT_SECT
	JP	NZ,ERROR
	CALL	DOS_WRITE_EOF
	JP	NZ,ERROR
	RET
;
ERROR
	LD	A,2
	JP	TERMINATE
;
DIAL_FIDO
	LD	A,(D_FLAG)
	OR	A
	RET	Z		;Return if not dialling
	RET
;
;Whack CRs to the remote end if we dialled or we connect
WHACK_CR
	LD	A,(D_FLAG)
	LD	B,A
	LD	A,(C_FLAG)
	OR	B
	RET	Z		;Neither -d nor -c
	LD	HL,M_WHACK
	CALL	LOG_MSG_1
;
	LD	B,5		;Whack CR 5 times
;
CONN_01
	PUSH	BC
	LD	A,' '
	CALL	PUT_BYTE
	LD	A,CR
	CALL	PUT_BYTE
	LD	A,2
	CALL	SEC10
	LD	A,CR
	CALL	PUT_BYTE
;
	LD	B,80		;2 secs
	LD	A,(TICKER)
	LD	C,A
CONN_02A
	PUSH	BC
	CALL	SER_INP
	POP	BC
	CP	CR
	JR	Z,CONN_03A
	LD	A,(TICKER)
	CP	C
	LD	C,A
	JR	Z,CONN_02A
	DJNZ	CONN_02A
	POP	BC
	DJNZ	CONN_01		;2 sec over
				;try again...
	LD	HL,M_NOCRS
	CALL	LOG_MSG_2
;
;just assume it was accepted anyway!
	JR	CONN_04
;
	LD	A,11
	JP	EXIT_FTALK
;
CONN_03A
	POP	BC
;
CONN_04
	LD	B,1
	CALL	GET_BYTE
	JR	NC,CONN_04	;Wait till no input
;
	LD	A,TSYNC
	CALL	PUT_BYTE
;
	LD	HL,M_SAWTS
	CALL	LOG_MSG_1
	LD	A,TSYNC
	CALL	PUT_BYTE
	RET
;
MAIL_SEND
	LD	HL,CMD_XMF
	LD	DE,STRING
	CALL	STRCPY
	LD	HL,PKTNAME
	CALL	STRCAT
	LD	HL,FILE_TRAIL1
	CALL	STRCAT
	CALL	XMF_S
	JR	NZ,MAIL_01
	LD	HL,G_MAILOK
	CALL	LOG_MSG_1
	LD	A,1
	LD	(SENTPKT),A
	RET
MAIL_01
	LD	HL,M_MAILBAD
	CALL	LOG_MSG_2
	LD	A,1
	LD	(FATAL),A
	RET
;
XMF_S
	LD	HL,STRING
	CALL	CALL_PROG
	LD	A,(LASTCC)
	OR	A
	RET
;
; Send any attached files (or queued files here)
FILE_SEND
	LD	A,(FATAL)
	OR	A
	RET	NZ		;If failed.
;
	XOR	A
	LD	(FILES),A
;
	LD	DE,FA_FCB
	LD	HL,PKT_BUF
	LD	B,0
	CALL	DOS_OPEN_EX
	JR	NZ,FS_01
	LD	A,1
	LD	(FILES),A
	LD	HL,M_ISFILES
	CALL	LOG_MSG_1
FS_01	XOR	A
	LD	(TRIES),A
FS_02
	LD	HL,MT_1
	CALL	LOG_MSG_1
	LD	A,(TRIES)
	INC	A
	LD	(TRIES),A
	CP	20
	JR	Z,FF_03		;Gave up
	LD	B,2
	CALL	GET_BYTE
	JR	C,FS_02		;Timed out
	CP	NAK
	JR	Z,FS_03		;Got Nak
	CP	ACK
	JR	Z,FF_05
	CP	TSYNC
	JR	Z,FF_02		;Tsync
	CP	'C'
	JR	Z,FF_04		;CRCnak
	LD	L,A
	LD	H,0
	PUSH	HL
	LD	HL,MT_3
	CALL	LOG_MSG_1
	POP	HL
	LD	DE,$DO
	CALL	PRINT_NUMB
	JR	FS_02
;
FS_03	LD	HL,MT_2		;Rcvd nak
	CALL	LOG_MSG_1
	JR	FF_06
;
FF_02	LD	HL,MT_4		;Rcvd Tsync
	CALL	LOG_MSG_1
	RET
;
FF_03	LD	HL,MT_5		;Gave up
	CALL	LOG_MSG_1
	LD	A,1
	LD	(FATAL),A
	RET
;
FF_04	LD	HL,MT_6		;Rcvd C
	CALL	LOG_MSG_1
	JR	FF_06
FF_05
	LD	HL,MT_7		;Rcvd ACK
	CALL	LOG_MSG_1
	JR	FS_02
;
FF_06
	LD	A,(FILES)
	OR	A
	JR	NZ,FF_07
;
FF_08
	LD	A,EOT
	CALL	PUT_BYTE
	LD	HL,MT_8
	CALL	LOG_MSG_1
	JR	FS_02
;
FF_07
	CALL	READFN
	JR	NZ,FF_08	;No more files / error
	LD	HL,FA_FILE
	LD	A,(HL)
	CP	'*'
	JR	Z,FF_07		;Try again
	CALL	CONVFN		;Blank pad
	CALL	MODEM7_FNAME
	JR	NZ,FF_07A	;Fn send failed
	LD	HL,CMD_XMF
	LD	DE,STRING
	CALL	STRCPY
	LD	HL,FA_FILE
	CALL	STRCAT
	CALL	XMF_S
	JP	Z,FS_01		;File send OK
	LD	HL,M_FTFAIL
	CALL	LOG_MSG_1
	LD	A,1
	LD	(FATAL),A
	RET
;
FF_07A
	LD	HL,M_FNFAIL
	CALL	LOG_MSG_1
	LD	A,1
	LD	(FATAL),A
	RET
;
MODEM7_FNAME
	XOR	A
	LD	(TRIES),A
FS_MS0
	LD	A,(TRIES)
	INC	A
	LD	(TRIES),A
	CP	20
	JR	NZ,MF_00A	;was mf_01
	LD	HL,M7_TRY	;Tried 20 times
	CALL	LOG_MSG_2
	LD	A,3
	CP	0
	RET	;nz
;
MF_00A	;Must WAIT for a Nak ... no good just sending ACK!
	LD	B,3
	CALL	GET_BYTE
	JR	C,FS_MS0	;Timeout
	CP	NAK
	JR	NZ,FS_MS0	;Retry
MF_01	LD	A,ACK
	CALL	PUT_BYTE
	LD	HL,TEMPFN
	LD	A,(HL)
	LD	C,A
	PUSH	BC
	INC	HL
	PUSH	HL
	CALL	PUT_BYTE
FS_MS1
	LD	B,2
	CALL	GET_BYTE
	JR	NC,MF_03
MF_02	LD	A,'u'
	CALL	PUT_BYTE
	POP	HL		;Discard
	POP	BC
	LD	HL,M7_U
	CALL	LOG_MSG_1
	JR	FS_MS0
MF_03
	CP	ACK
	JR	NZ,MF_02
	POP	HL
	LD	A,(HL)
	OR	A
	JR	Z,MF_04
	PUSH	HL
	CALL	PUT_BYTE
	POP	HL
	POP	BC
	LD	A,(HL)
	ADD	A,C
	LD	C,A
	PUSH	BC
	INC	HL
	PUSH	HL
	JR	FS_MS1
MF_04	LD	A,SUB
	CALL	PUT_BYTE
	LD	A,SUB
	POP	BC
	ADD	A,C
	LD	C,A
FS_MS2
	LD	B,2
	CALL	GET_BYTE
	JR	C,FS_MS0
	CP	C
	JR	NZ,FS_MS0
	LD	A,ACK
	CALL	PUT_BYTE
	CP	A
	RET
;
CONVFN
	LD	DE,TEMPFN
	PUSH	DE
	LD	A,' '
	LD	B,11
CV_00	LD	(DE),A		;Fill with blanks
	INC	DE
	DJNZ	CV_00
	XOR	A
	LD	(DE),A
	POP	DE
	LD	B,8
	CALL	ZAPNUMBER	;Zap around 0-9 to a-j
CV_01	LD	A,(HL)
	OR	A
	JR	Z,CV_06
	CP	'.'
	JR	Z,CV_02
	CP	':'
	JR	Z,CV_06
	CP	'/'
	JR	Z,CV_06
	CALL	TO_UPPER_C
	LD	(DE),A
	INC	HL
	INC	DE
	DJNZ	CV_01
CV_02
	LD	DE,TEMPFN+8
	LD	A,(HL)
	CP	'.'
	JR	NZ,CV_06
	INC	HL
	LD	B,3
	CALL	ZAPNUMBER
CV_03	LD	A,(HL)
	OR	A
	JR	Z,CV_06
	CP	':'
	JR	Z,CV_06
	CP	'/'
	JR	Z,CV_06
	CALL	TO_UPPER_C
	LD	(DE),A
	INC	HL
	INC	DE
	DJNZ	CV_03
;
CV_06
	LD	DE,$DO
	LD	A,''''
	CALL	$PUT
	LD	HL,TEMPFN
	LD	B,11
CV_07	LD	A,(HL)
	CALL	$PUT
	INC	HL
	DJNZ	CV_07
	LD	A,''''
	CALL	$PUT
	LD	A,CR
	CALL	$PUT
	RET
;
ZAPNUMBER
	LD	A,(HL)
	CP	'0'
	RET	C
	CP	'9'+1
	RET	NC
	LD	(DE),A		;Zap as is!
	ADD	A,31H		;Change to a-j
	LD	(HL),A
	INC	DE
	INC	HL
	DEC	B		;One less time through
	RET
;
READFN
	LD	HL,FA_FILE
	LD	DE,FA_FCB
	LD	B,31
RF_01	CALL	$GET
	RET	NZ
	CP	CR
	JR	Z,RF_02
	LD	(HL),A
	INC	HL
	DJNZ	RF_01
RF_02	LD	(HL),0
	CP	A
	RET
;
DISC_FIDO
	LD	A,20
	CALL	SEC10
	LD	HL,M_HANG1
	CALL	LOG_MSG_2
	XOR	A
	RET
;
PICK_FIDO
	LD	A,(FATAL)
	OR	A
	RET	NZ		;Connection failed
	LD	HL,GETPKT_CMD
	CALL	CALL_PROG
	RET
;
FIDO_LOST
	LD	HL,M_LOST1
	CALL	LOG_MSG_2
	LD	A,127
	JP	TERMINATE
	JP	LOST_CARRIER
;
;If the mail packet was sent, copy then remove it.
SAVE_PACKET
	LD	A,(SENTPKT)
	OR	A
	RET	Z
	LD	HL,CMD_CP
	LD	DE,STRING
	CALL	STRCPY
	LD	HL,PKTNAME
	CALL	STRCAT
	LD	HL,FILE_TRAIL1
	CALL	STRCAT
	LD	HL,SPCS
	CALL	STRCAT
	PUSH	DE
	LD	HL,PKTNAME
	CALL	STRCAT
	LD	HL,FILE_TRAIL1
	CALL	STRCAT
;
	POP	DE
	LD	A,'Q'		;for old
	LD	(DE),A
;
	LD	HL,STRING
	CALL	CALL_PROG	;copy file
	OR	A
	JR	NZ,NO_COPY
;
	LD	DE,PKT_FCB	;Open mail packet
	CALL	DOS_KILL
	RET	Z
	LD	HL,M_NORM
	CALL	LOG_MSG_2
	RET
;
NO_COPY
	LD	HL,M_NOCOPY
	CALL	LOG_MSG_2
	RET
;
GET_BYTE
	PUSH	DE
GB_1	LD	D,40		;=1 sec
	LD	A,(TICKER)
	LD	E,A
GB_2	LD	A,(CD_STAT)
	BIT	1,A
	JR	NZ,GB_3
	IN	A,(RDSTAT)
	BIT	DAV,A
	JR	NZ,GB_4
	LD	A,(TICKER)
	CP	E
	LD	E,A
	JR	Z,GB_2
	DEC	D
	JR	NZ,GB_2
	DJNZ	GB_1
GB_3	POP	DE
	SCF		;If timeout or carrier loss
	RET	
;
GB_4	IN	A,(RDDATA)
	POP	DE
	OR	A
	RET
;
;send character
PUT_BYTE
	PUSH	AF
BS_1	LD	A,(CD_STAT)
	BIT	1,A
	JR	NZ,BS_2		;Carrier check.
	IN	A,(RDSTAT)
	BIT	CTS,A
	JR	Z,BS_1
BS_2
	POP	AF
	OUT	(WRDATA),A
	RET
;
LOG_MSG_2
	PUSH	HL
	LD	DE,$DO
	CALL	MESS_0
	POP	HL
	CALL	LOG_MSG
	RET
;
LOG_MSG_1
	LD	DE,$DO
	CALL	MESS_0
	RET
;
TO_UPPER_C
	CP	'a'
	RET	C
	CP	'z'+1
	RET	NC
	AND	5FH
	RET
;
*GET	ROUTINES.LIB
;
C_FLAG	DEFB	0	;1=Already connected
D_FLAG	DEFB	0	;1=Dial out
FATAL	DEFB	0	;1 = Connection failed somewhere
SENTPKT DEFB	0	;1 = Outgoing packet was sent
TRIES	DEFB	0	;Count of file send attempts
;
TO_NET	DEFW	0	;Calling/called net
TO_NODE	DEFW	0	;Calling/called node
FILES	DEFB	0	;1 = Files to send
;
M_ISFILES
	DEFM	'We have files to send',CR,0
M_WHACK
	DEFM	'Whacking CR',CR,0
MT_1	DEFM	'Waiting for their question',CR,0
MT_2	DEFM	'Received nak',CR,0
MT_3	DEFM	'Received other: ',0
MT_4	DEFM	'Received early Tsync',CR,0
MT_5	DEFM	'Gave up on no file send',CR,0
MT_6	DEFM	'Saw "C"',CR,0
MT_7	DEFM	'Received ack',CR,0
MT_8	DEFM	'Sent EOT',CR,0
M_DIAL1	DEFM	CR,'FTalk...',CR,CR,0
M_DIAL2	DEFM	'Fido carrier detected',CR,0
M_DIAL3	DEFM	'** No carrier found',CR,0
M_SAWTS	DEFM	'TSYNC sent',CR,0
M_NOCRS	DEFM	'** No response to whacking CR',CR,0
M_MAILBAD
	DEFM	'Could not send mail packet',CR,0
G_MAILOK
	DEFM	'Mail packet sent successfully',CR,0
M_FILE1	DEFM	'File send ignored',CR,0
M_FNFAIL
	DEFM	'Modem7 filename send failed',CR,0
M_FTFAIL
	DEFM	'File send transfer failed',CR,0
;
M7_TRY	DEFM	'FileNAME send failed ... 20 tries',CR,0
M7_U	DEFM	'Sending U',CR,0
M_HANG1	DEFM	'Ftalk: Exiting',CR,0
M_LOST1	DEFM	'** Lost Fido carrier',CR,0
M_NOPKT
	DEFM	'** No packet to send to it',CR,0
M_NOCOPY
	DEFM	'** could not copy packet contents',CR,0
M_NORM
	DEFM	'** could not delete packet',CR,0
;
CMD_XMF	DEFM	'xmodem -qcs ',0
CMD_CP	DEFM	'cp ',0
CMD_RM	DEFM	'rm ',0
GETPKT_CMD
	DEFM	'Getpkt -d',0
SPCS	DEFM	' ',0
FILE_TRAIL1	DEFM	'.out/poof:2',0
FILE_TRAIL2	DEFM	'.fa/poof:2',0
;
;;MAILCC	DEFB	0
STRING	DEFS	64
PKTNAME	DEFS	64
FA_FILE	DEFS	32
TEMPFN	DEFS	12
;
PKT_FCB	DEFS	32
FA_FCB	DEFS	32
PKT_BUF	DEFS	256
;
DUMMY_PKT
		DEFW	ZETA_NODE
DUMMY_NODE	DEFW	0
		DEFW	1987
		DEFW	7	;Aug
		DEFW	30	;Day
		DEFW	8	;Hr
		DEFW	30	;Min
		DEFW	55	;Sec
		DEFW	0	;Baud
		DEFW	2	;Packet version
		DEFW	ZETA_NET
DUMMY_NET	DEFW	0
		DEFW	1	;Product code
		DC	33,0	;Fill
		DEFW	0	;No messages
;--- End of dummy packet data
;
THIS_PROG_END	EQU	$
;
	END	START
