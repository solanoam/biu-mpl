
CSEG AT 0000H
JMP MAIN

CSEG AT 0023H ; change serial int
JMP SER

CSEG AT 0100H ; main

MAIN:
	CLR SM0
	SETB SM1
	SETB REN
	ANL PCON , #07FH ; baud rate set to 19200
	ANL TMOD , #02FH
	ORL TMOD , #020H
	MOV TH1 , #00EEH
	SETB TR1 ; timer1 is on
	CLR ET1 ; disable timer1 int
	SETB ES ; enable port int
	SETB EA ; enable all int
	JMP $ ; inf loop

SER:
	CLR TI ; clear transmit for uart
	JBC RI,TRANS_INT ;turn RI off and send back the value
	PUSH ACC
	CLR A
	MOVC A , @A+DPTR ; jump to the printing function of the letter that should be printed
	JZ NULL ; when null, skip
	MOV SBUF , A ; print the value of A
	INC DPTR ; get next letter from string
NULL:
	POP ACC
RETI

TRANS_INT:
		CLR RI ;no other interupts from uart while sending
		MOV R2 , SBUF ; store input from uart
		;swtich case for letters a-d
		CJNE R2 , #'a' ,bCheck
		MOV DPTR , #aPress
		JMP TRANS_INT_END
	bCheck:
		CJNE R2 , #'b' , cCheck
		MOV DPTR , #bPress
		JMP TRANS_INT_END
	cCheck:
		CJNE R2 , #'c' , dCheck
		MOV DPTR , #cPress
		JMP TRANS_INT_END
	dCheck:
		CJNE R2 , #'d' , TRANS_INT_END
		MOV DPTR , #dPress
	TRANS_INT_END:
		SETB TI
RETI

//data segment
CSEG AT 0300H
aPress: DB 'Alpha'
		   DB 13
		   DB 10
		   DB 0
bPress: DB 'Beta'
		   DB 13
		   DB 10
		   DB 0
cPress: DB 'Charlie'
		   DB 13
		   DB 10
		   DB 0
dPress: DB 'Delta'
		   DB 13
		   DB 10
		   DB 0
END
