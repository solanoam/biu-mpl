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
#include <ADUC841.h>
LED     EQU   P3.4
CSEG AT 0000H
JMP MAIN

CSEG AT 000BH
CPL LED
RETI

CSEG AT 0023H ; change serial int
SETB SerFlag
RETI

CSEG AT 0100H ; main

MAIN:
	CLR SM0
	SETB SM1
	SETB REN
	CLR DevideFlag
	CLR RestoreFlag
	CLR SerFlag
	ANL PCON , #07FH ; baud rate set to 19200
	ANL TMOD , #02FH
	ORL TMOD , #020H
	MOV TH1 , #00FAH
	SETB TR1 ; timer1 is on
	CLR ET1 ; disable timer1 int
	MOV TH0, #00FAH
	SETB TR0 ; timer1 is on
	SETB ET0 ; disable timer1 int
	SETB ES ; enable port int
	SETB EA ; enable all int
Loop:
	JB SerFlag, SER
	JB DevideFlag, devideClock
	JB RestoreFlag, restoreClock
	JMP Loop ; inf loop
	
devideClock:
	ANL PLLCON, #00H
	ORL PLLCON, #01H
	MOV TH1 , #00FDH
	CLR DevideFlag
	JMP Loop

restoreClock:
	ANL PLLCON, #00H
	ORL PLLCON, #01H
	MOV TH1 , #00FAH
	CLR RestoreFlag
	JMP Loop
  
SER:
  CLR TI ; clear transmit for uart
  JBC RI,TRANS_INT ;turn RI off and send back the value
  PUSH PSW
  PUSH ACC
CheckChar:
  JB DevideFlag, ClockChange
  JB RestoreFlag, ClockChange
EchoChar:
  MOV A, SBUF
  MOV SBUF, A
ClockChange:
  POP ACC
  POP PSW
JMP Loop


TRANS_INT:
	CLR RI ;no other interupts from uart while sending
	MOV R2 , SBUF ; store input from uart
	;swtich case for letters a-d
  changeSpeedHandler:
    CJNE R2 , #'!' ,restoreSpeedHandle
    SETB DevideFlag
  restoreSpeedHandle:
		CJNE R2 , #'(' , TRANS_INT_END
		SETB RestoreFlag
	TRANS_INT_END:
		SETB TI
JMP CheckChar



BSEG
DevideFlag: DBIT 1
RestoreFlag: DBIT 1
SerFlag: DBIT 1
END