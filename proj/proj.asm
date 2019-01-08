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
JMP SER
RETI

CSEG AT 0100H ; main

MAIN:
	;uart setup
	CLR SM0
	SETB SM1
	SETB REN
	CLR TI
	;initialize flags
	CLR DevideFlag
	CLR RestoreFlag

	ANL PCON , #01111111b ;set SMOD
	ORL TMOD , #00100010b ;set timer 0 and timer 1 to autoreload mode
	ANL TMOD , #11111010B

	MOV TH1 , #250d
	SETB TR1 ; timer1 is on
	CLR ET1 ; disable timer1 int

	MOV TH0, #145d
	SETB TR0 ; timer1 is on
	SETB ET0 ; enable timer0 int

	SETB ES ; enable port int
	SETB EA ; enable all int

Loop:
	JB DevideFlag, devideClock
	JB RestoreFlag, restoreClock
	JMP Loop ; inf loop

devideClock:
	ANL PLLCON, ,#00000000b ;divide cpu clock by 2
	ORL PLLCON, #00000001b
	MOV TH1 , #253d ;reconfigure baud rate for new cpu clock
	CLR DevideFlag ;restore flag
	JMP Loop

restoreClock:
	ANL PLLCON, #00000000b ;multiply cpu clock by 2
	MOV TH1 , #250d ;reconfigure baud rate
	CLR RestoreFlag
	JMP Loop

SER:
  	CLR TI ; clear transmit for uart
  	JBC RI,CheckChar ;turn RI off and send back the value
  	RETI
CheckChar:
  	MOV A,SBUF
  	CJNE A ,#'!',notDevide ;check if value is '!'. If not, jump to "notDevide"
  	SETB DevideFlag ;if it does, set flag
  	RETI
notDevide:
  	CJNE A, #')', EchoChar ;check if value is ')'. If not, jump to "EchoChar"
  	SETB RestoreFlag ;if it does, set flag
  	RETI
EchoChar:
  	MOV SBUF, A ;write value to SBUF
  	CLR RI
  	RETI


BSEG
DevideFlag: DBIT 1
RestoreFlag: DBIT 1
END
