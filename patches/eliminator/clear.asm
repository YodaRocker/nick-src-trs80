; THIS ROUTINE	LETS THE 'X' KEY SUBSTITUTE FOR 'CLEAR'
; IN ELIMINATOR.

	ORG	9026H
	LD	A,(3880H)
	LD	B,A
	AND	(HL)
	BIT	0,A
	JP	NZ,5755H
	BIT	0,B
	JP	NZ,57A7H
	LD	(HL),1
	JP	57A7H
	END	816EH