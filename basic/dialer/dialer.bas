00010   CLS : PRINT "AUTOMATIC TELEPHONE DIALER": CLEAR 10000: DIM S$(100),NO$(500),NA$(500):NUM = 1
00012   : REM ' REVISION XX.1
00013   PRINT "COPYRIGHT 9/3/82 NICK ANDREW"
00015   J = 1
00020   IF J = 1 THEN INPUT "NAME,NUMBER OR FUNCTION";A$ : ELSE GOTO 5000
00022   IF LEFT$(A$,1) = "*" THEN R = R + 1:S$(R) = A$: GOTO 15
00023   IF LEFT$(A$,1) = "$" THEN J = 0:Q = R + 1:K = 0:R = 0: GOTO 20
00025   IF LEFT$(A$,1) = "%" THEN GOTO 2040
00027   IF LEFT$(A$,1) = "#" THEN A$ = RIGHT$(A$, LEN(A$) - 1): GOTO 2010
00030   IF ASC(A$)> 64 THEN GOTO 1000
00032   IF LEFT$(A$,1) = "/" THEN A$ = RIGHT$(A$, LEN(A$) - 1): GOTO 40
00035   : REM ' DIALING ROUTINE
00036   L = 0:O = 0:U = 0
00038   FOR T = 1 TO 100: NEXT : OUT 255,4: FOR T = 1 TO 400: NEXT : OUT 255,0: FOR T = 1 TO 600: NEXT
00039   PRINT A$
00040   FOR T = 1 TO LEN(A$)
00050   IF MID$(A$,T,1) = "-" THEN FOR I = 1 TO 300: NEXT I: GOTO 100
00060   N = VAL(MID$(A$,T,1)): IF N = 0 THEN N = 10
00070   FOR Y = 1 TO N
00080   OUT 255,4: FOR L = 1 TO 9: NEXT L: OUT 255,0
00090   FOR U = 1 TO 18: NEXT U,Y
00100   FOR O = 1 TO 310: NEXT O: NEXT T: GOTO 20
01000   : REM ' DIALING-BY NAME ROUTINE
01010   FOR T = 1 TO NUM
01020   IF A$ = NA$(T) THEN 1100
01030   NEXT T
01040   PRINT "NAME NOT ON FILE, HIT <RETURN> TO ADD TO FILE"
01050   PRINT "OR <SPACEBAR> TO TYPE NAME AGAIN."
01060   C$ = INKEY$ : IF C$ = "" THEN 1060 : ELSE IF C$ = " " THEN GOTO 20 : ELSE IF C$ = CHR$(13) THEN GOTO 1070 : ELSE GOTO 1060
01070   NUM = NUM + 1:NA$(NUM) = A$
01080   PRINT "TYPE IN ";A$;"'S PHONE NUMBER";: INPUT NO$(NUM)
01090   GOTO 20
01100   A$ = NO$(T): PRINT NA$(T);": ";
01110   GOTO 40
02000   : REM ' HANG-UP ROUTINE.
02010   SEC = VAL(A$)
02020   FOR T = 1 TO SEC
02022   IF PEEK(14400) = 128 THEN GOTO 15
02025   PRINT @0, STRING$(63,32);: PRINT @0, USING "### SECONDS TILL CUTOFF";SEC - T
02027   IF INKEY$ = CHR$(13) THEN T = SEC + 2:F = - 1
02030   FOR U = 1 TO 320: NEXT U,T
02035   IF F = - 1 THEN F = 0: CLS : PRINT @64,"";: GOTO 20
02040   OUT 255,4: FOR U = 1 TO 2000: NEXT : OUT 255,0
02045   CLS : PRINT @64,"";
02050   FOR T = 1 TO 500: NEXT T: GOTO 20
05000   K = K + 1: IF K = Q THEN GOTO 15
05010   A$ = RIGHT$(S$(K), LEN(S$(K)) - 1): GOTO 25
