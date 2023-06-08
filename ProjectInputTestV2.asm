;CIS-11 Project CASE #1 GRADE CALCULATOR
;By: Filiberto Oceguera-Huizar, Liliana Darch, Ashley Mora Doctor
;This an Assembly LC-3 program that gets three inputs for a grade and a total
;of five grades are needed to get the users average grade, minimum grade
;and max grade, which are displayed to the user.
;The three inputs are supposed to be in the fashion of 000, an example for a
;grade of B would be 080 - 089.

.ORIG x3000
LD R6, GBASE		;Dont mess with register 6 until after the UNSTACK
LEA R0, PROMPT		;LOAD PROMPT STRING
PUTS				;DISPLAY PROMPT STRING TO CONSOLE
	
;-------------------------FIRST DIGIT---------------------------
;FOR GETTING GRADES WE CANT HAVE ANYTHING BIGGER THAN 100
;SO WE HAVE TO CHECK IF ITS A 0 OR 1
;IF ITS A 1 WE MULT IT BY 100 AND MOVE ONTO THE NEXT GRADE.
;IF ITS A 0 WE GO ONTO THE NEXT DIGIT IN THE NUMBER.
GLOOP
AND R0, R0, #0		;CLEAR R0
AND R1, R1, #0		;CLEAR R1
AND R2, R2, #0		;CLEAR R2
AND R3, R3, #0		;CLEAR R3
AND R4, R4, #0		;CLEAR R4
AND R5, R5, #0		;CLEAR R5


GETC			;GET CHAR FROM USER
ADD R4,R0,#0		;COPY INPUT TO R4
LD  R5, HEXN30		;LOAD -48 TO CONVERT
ADD R5, R4, R5		;CONVERT COMPLETE
STI R5, IN1		;STORE R5(0) INTO IN1
BRz SKIPZ		;IF THE USER PUTS A ZERO WE GO TO DISPLAY
ADD R3,R4,#-1		;INPUT VALIDATION FOR THE FIRST INPUT, IT CAN ONLY BE 1
;BRnp INERR		;ERROR
ADD R1, R5, #0		;COPY
JSR HUNS
AND R1, R1, #0		;CLEAR R1
ADD R1, R5, #0		;R1 SHOULD HAVE VALUE 100
STI R1, IN1		;STORE R1(100) INTO IN1
AND R3, R3, #0		;CLEAR R3
LEA R0, HUNP		;LOAD 100 STRING TO SHOW USER
PUTS
BR NXTG			;GO TO THE NEXT GRADE BECAUSE USER HAS 100 ALREADY.

SKIPZ
LEA R0, NUM		;LOAD NUM CHARS TO R0

ADD R3,R5,x0		;COPY R5 TO R3 FOR CHAR DISPLAYING
ADD R3,R3,x0		;R3=0, SET UP FOR ZERO BRANCHING, INITIALIZE LOOP TO START AT 0
MIRROR1 		;USING SOME OF THE DISPLAY LOGIC FROM LAB 5.
BRz DISPM1		;LOOP LABEL, IF=0 GO TO DISPLAY
ADD R0,R0,#2		;R0+=#2, 11 CHARS FOR NUMBERS INCLUDING NULL TEMINATED
ADD R3,R3,#-1		;R3-OFFSET 1, UPDATE VAL FOR INCREMENT LOOP
BR MIRROR1		;GO BACK TO MIRROR 1 TO START

DISPM1 	
PUTS			;SHOW NUM ON CONSOLE
BR NXTD2		;NEXT NUM (NEXT DIGIT INPUT)

;-------------------------SECOND DIGIT---------------------------
;SECOND DIGIT IS SIMPLER THAT THE OTHER FOR IT CAN BE ANY NUMBER
;BETWEEN 0-9, WE JUST CONVERT IT TO THE TENS PLACE.
NXTD2
AND R0, R0, #0		;CLEAR R0
AND R1, R1, #0		;CLEAR
AND R3, R3, #0		;CLEAR
AND R4, R4, #0		;CLEAR
AND R5, R5, #0		;CLEAR
LD R5, HEXN30		;LOAD -48 TO CONVERT
GETC
ADD R4, R0, #0		;COPY
ADD R5, R4, R5		;COMPLETE CONVERSION
ADD R1, R5, #0		;COPY
JSR TENS		;CONVERT TO TENS PLACE
STI R5, IN2		;STORE R1 INTO INPUT 2


LEA R0, NUM		;LOAD NUM CHARS TO R0

ADD R3,R1,x0		;COPY R5 TO R3 FOR CHAR DISPLAYING
ADD R3,R3,x0		;R3=0, SET UP FOR ZERO BRANCHING, INITIALIZE LOOP TO START AT 0
MIRROR2 		;USING SOME OF THE DISPLAY LOGIC FROM LAB 5.
BRz DISPM2		;LOOP LABEL, IF=0 GO TO DISPLAY
ADD R0,R0,#2		;R0+=#2, 11 CHARS FOR NUMBERS INCLUDING NULL TEMINATED
ADD R3,R3,#-1		;R3-OFFSET 1, UPDATE VAL FOR INCREMENT LOOP
BR MIRROR2		;GO BACK TO MIRROR 1 TO START
DISPM2 	
PUTS			;SHOW NUM ON CONSOLE
BR NXTD3		;NEXT NUM (NEXT DIGIT INPUT)

;-------------------------THIRD DIGIT---------------------------
NXTD3
AND R0, R0, #0		;CLEAR R0
AND R1, R1, #0		;CLEAR
AND R3, R3, #0		;CLEAR
AND R4, R4, #0		;CLEAR
AND R5, R5, #0		;CLEAR
LD R5, HEXN30		;LOAD -48 TO CONVERT
GETC
ADD R4, R0, #0		;COPY
ADD R5, R4, R5		;COMPLETE CONVERSION
ADD R1, R5, #0		;COPY
STI	R1, IN3		;STORE R1 INTO INPUT 2

LEA R0, NUM		;LOAD NUM CHARS TO R0

ADD R3,R5,x0		;COPY R5 TO R3 FOR CHAR DISPLAYING
ADD R3,R3,x0		;R3=0, SET UP FOR ZERO BRANCHING, INITIALIZE LOOP TO START AT 0
MIRROR3 		;USING SOME OF THE DISPLAY LOGIC FROM LAB 5.
BRz DISPM3		;LOOP LABEL, IF=0 GO TO DISPLAY
ADD R0,R0,#2		;R0+=#2, 11 CHARS FOR NUMBERS INCLUDING NULL TEMINATED
ADD R3,R3,#-1		;R3-OFFSET 1, UPDATE VAL FOR INCREMENT LOOP
BR MIRROR3		;GO BACK TO MIRROR 1 TO START
DISPM3 	
PUTS			;SHOW NUM ON CONSOLE


;-------------------------Input Grade---------------------------
;we want to be able to use a stack to be able to loop through our
;input code so we can store all our grades for the up coming code.
NXTG
AND R0, R0, #0
AND R1, R1, #0		;CLEAR
AND R2, R2, #0		;CLEAR
AND R3, R3, #0		;CLEAR

LDI R1, IN1
LDI R2, IN2
LDI R3, IN3
ADD R1, R1, R2
ADD R1, R1, R3		;R1 has our grade

AND R2, R2, #0		;CLEAR
AND R3, R3, #0		;CLEAR
AND R4, R4, #0 		;CLEAR

;This is our STACK where we put our temp grades to later put them in
;a permenant location.

ADD R0, R1, #0
JSR PUSH
AND R0, R0, #0
LEA R0, NL		;NEW LINE
PUTS			;DISPLAY NEW LINE
AND R1, R1, #0		;CLEAR
AND R2, R2, #0		;CLEAR
AND R3, R3, #0		;CLEAR
STI R1, IN1
STI R2, IN2
STI R3, IN3
AND R2, R2, #0		;CLEAR
LD R2, GC		;LOAD GRADE COUNTER(5) INTO R2
ADD R2, R2, #-1		;DECREMENT
ST R2, GC		;STORE GRADE COUNTER
BRz GDEND		;IF ZERO ITS END OF GRADES
BR GLOOP		;GO BACK TO GRADE LOOP

GDEND

AND R0, R0, #0

;UNSTACK 
;This is where we unstack using the POP SR to store it into an address
;for later use on the math portion.

JSR ISEMPTY		;ISEMPTY SR
BRp CONT 		;IS POS GO TO CONT, ELSE KEEP GOING
JSR POP			;POP SR
STI R0, GRADE5
JSR ISEMPTY		;ISEMPTY SR
BRp CONT 		;IS POS GO TO CONT, ELSE KEEP GOING
JSR POP			;POP SR
STI R0, GRADE4
JSR ISEMPTY		;ISEMPTY SR
BRp CONT 		;IS POS GO TO CONT, ELSE KEEP GOING
JSR POP			;POP SR
STI R0, GRADE3
JSR ISEMPTY		;ISEMPTY SR
BRp CONT 		;IS POS GO TO CONT, ELSE KEEP GOING
JSR POP			;POP SR
STI R0, GRADE2
JSR ISEMPTY		;ISEMPTY SR
BRp CONT 		;IS POS GO TO CONT, ELSE KEEP GOING
JSR POP			;POP SR
STI R0, GRADE1		
BRp CONT

CONT
HALT

;+++++++++++++++++++++++++SUBROUTINES+++++++++++++++++++++++++++
;This SUBROUTINE makes the tenths place using multiplication.
TENS 	AND R5, R5, #0		;clear
		ADD R2, R2, #10 	; to make it in the 10ths place
MTLOOP	ADD R5, R5, R1
		ADD R2, R2, #-1
		BRp MTLOOP
		RET
		
;This SUBROUTINE is to make the 1st input 100 if the user puts a 1		
HUNS	AND R5, R5, #0		;clear
		ADD R2, R2, #15 	; to make it in the 100ths place
		ADD R2, R2, #15 
		ADD R2, R2, #15 
		ADD R2, R2, #15 
		ADD R2, R2, #15 
		ADD R2, R2, #15 
		ADD R2, R2, #10
MHLOOP	ADD R5, R5, R1
		ADD R2, R2, #-1
		BRp MHLOOP
		RET

;THESE ARE THE POP AND PUSH SR'S FOR THE STACK
;THE IS AND ISEMPTY CHECK THE STACK.
PUSH 	ADD R6, R6, #-1
		STR R0, R6, #0
		RET

POP		LDR R0, R6, #0
		ADD R6, R6, #1
		RET

ISEMPTY LD R0, EMPTY
		ADD R0, R6, R0
		BRz IS
		ADD R0, R0, #0
		RET

IS 		AND R0, R0, #0
		ADD R6, R6, #1
		RET


;********************************************************	
;-------------------------Idea---------------------------		
		
;To get the highest and lowest grade. 
;Initialize the array with grade 1-5. 
;Need 2 labels to store the maxgrade, mingrade.
;For maxgrade: add the values if negative then store that new number as max grade
;If its positive or zero no need to change maxgrade
;Repeat until all numbers are checked.

;The same steps for mingrade but If its positive we change mingrade 
;If its negative or zero we don’t change grade.

;Ex. For max 20 – 30 = (-) so that means 30 is bigger so 30 is the new maximum grade
;For min 10 – 5 = (+) so that new number must be smaller so 5 is new minimum grade 		
	
;-----------------------------------------------------------
;***********************************************************


; ----------------------Create grades array-----------------

GRADES 	ST R0, GRADE1	; R0 = GRADE1, STORE VALUE TO GRADE LOCATIONS
	ST R1, GRADE2	; R1 = GRADE2
	ST R2, GRADE3
	ST R3, GRADE4
	ST R4, GRADE5

;-------------------------Calculate Maxgrade-----------------


CAL_MAX
	LD R1, GRADE_COUNT 	; R1 holds the number of tests (5)
 	LEA R2, GRADES 		; R2 holds the array address
	LD R4, GRADES		
	ST R4, MAX_GRADE        ; Store that new number as max grade
	ADD R2, R2, #1

LOOP 	LDR R5, R2, #0		; Access pointer value in the array
	ADD R5, R5, R4
	BRp POS
	LEA R0, MAX
	PUTS
	LD R3, MAX_GRADE	; Load max grade
	AND R1, R1, #0
	OUT

POS 	LDR R4, R2, #0
	ST R4, MAX_VALUE	; Store that new number as max grade
	ADD R2, R2, #1		; The array moves to the next value
	ADD R1, R1, #-1		; counter -1
	BRp LOOP



;-------------------------Calculate Mingrade-----------------


CAL_MIN
	LD R1, GRADE_COUNT 	; R1 holds the number of tests (5)
 	LEA R2, GRADES 		; R2 holds the array address
	LD R4, GRADES		
	ST R4, MIN_GRADE        ; Store that new number as min grade
	ADD R2, R2, #1

LOOP 	LDR R5, R2, #0		; Access pointer value in the array
	ADD R4, R4, #1
	ADD R5, R5, R4
	BRn NEG
	LEA R0, MIN
	PUTS
	LD R3, MIN_GRADE	; Load min grade
	AND R1, R1, #0
	OUT


NEG 	LDR R4, R2, #0
	ST R4, MIN_GRADE	; Store that new number as min grade
	ADD R2, R2, #1		; The array moves to the next value
	ADD R1, R1, #-1		; counter -1
	BRp LOOP


;+++++++++++++++++++++++++++Data++++++++++++++++++++++++++++++++
PROMPT 	.STRINGZ "Input Five grade scores "	
HEXN30 	.FILL xFFD0
HEX30  	.FILL x0030
IN1    	.FILL x3102
IN2		.FILL x3103
IN3		.FILL x3104
GRADE1 	.FILL x3105
GRADE2 	.FILL x3106
GRADE3 	.FILL x3107
GRADE4 	.FILL x3108
GRADE5 	.FILL x3109
GC		.FILL #5
HUNP	.STRINGZ "100"
NUM		.STRINGZ "0"
		.STRINGZ "1"
		.STRINGZ "2"
		.STRINGZ "3"
		.STRINGZ "4"
		.STRINGZ "5"
		.STRINGZ "6"
		.STRINGZ "7"
		.STRINGZ "8"
		.STRINGZ "9"
GBASE	.FILL x4000
EMPTY	.FILL xC000
NL		.STRINGZ "\n"


GRADE_COUNT	.FILL #5
MAX		.STRINGZ "MAX "
MAX_VALUE	.BLKW #1



.END
