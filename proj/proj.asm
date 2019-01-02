;********************************************************************
;
; Authors       : Noam Solan & Ronen Rozin
;
; Date          : 09/01/19
;
; File          : proj.asm
;
; Hardware      : 8051 based processor
;
; Description   : Power Managment
;
;********************************************************************
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
NULL:
	POP ACC
RETI

TRANS_INT:
		CLR RI ;no other interupts from uart while sending
		MOV R2 , SBUF ; store input from uart
		;swtich case for letters a-d
		CJNE R2 , #'!' ,restoreSpeedHandle
		JMP devideClock
  restoreSpeed:
		CJNE R2 , #'(' , TRANS_INT_END
		JMP restoreClock
	TRANS_INT_END:
		SETB TI
RETI

CSEG AT 0200H
devideClock:
  ANL PLLCON, 
  JMP TRANS_INT_END

CSEG AT 0300H
restoreClock:

  JMP TRANS_INT_END
