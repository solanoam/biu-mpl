;********************************************************************
;
; Authors       : Noam Solan & Ronen Rozin
;
; Date          : 19/12/18
;
; File          : mpl.lab7.ex1.asm
;
; Hardware      : 8051 based processor
;
; Description   : DACs
;
;********************************************************************
#include <ADUC841.h>
<<<<<<< HEAD
LED     EQU     P3.4
CSEG AT 0000H
	JMP MAIN

CSEG AT 000BH ; timer0 address
	CPL LED ; led toggle
RETI

CSEG AT 0023H ; serial int address
CLR ES ; disable serial port int
SETB UARTF
=======
LED	 EQU     P3.4
CSEG AT 0000H
	JMP MAIN

CSEG AT 000BH ; change timer0 int
	CPL LED ; activate led
RETI

CSEG AT 0023H ; serial int
CLR ES ; disable serial int
SETB FLAG_UART
>>>>>>> 58c6afe56832b56b8de90dbcc8f2576bab8c29b2
RETI

CSEG AT 0100H ; MAIN

MAIN:
<<<<<<< HEAD
	MOV T3FD , #32D ; SET T3FD TO 32 AS CACULATE
	ANL T3CON , #11111011B ; turn on T3BUADEN
	ORL T3CON , #10000011B
	CLR SM0  ;  set uart to 8bit mode
	SETB SM1
	SETB REN ; enable data receiving
	ANL TMOD , #0F0H ; timer0 in to mode 1
	ORL TMOD , #02H
=======
	MOV T3FD , #00100000B ; param according to calculation
	ANL T3CON , #11111011B ; param according to calculation
	ORL T3CON , #10000011B ;REPRESENT DIV=3, TURN ON BIT7 - T3BAUDEN
	CLR SM0  ;TURN OFF BIT 7 IN SCON - UART AT 8 BIT MODE
	SETB SM1 ;TURN ON BIT 6 IN SCON - UART AT 8 BIT MODE
	SETB REN ;TURN ON BIT 4 SCON - RECIVE DATA ENABLE
	ANL TMOD , #0F0H ; TURN ON BIT 0 TO SET TIMER0 TO MODE 1
	ORL TMOD , #02H ; TURN OFF BIT 1 TO SET TIMER0 TO MODE 1
>>>>>>> 58c6afe56832b56b8de90dbcc8f2576bab8c29b2
	MOV TH0 , #000D
	SETB TR0

	SETB ET0 ; enable timer0 int
	SETB ES ; enable serial port int
	SETB EA ; enable interrupts
	MOV DPTR , #PRINT ; print options
	SETB TI ; printing interrupt

PLOOP:
	JNB UARTF,$
	CLR UARTF
	JBC RI,RI_ON
	CLR TI ;
	SETB ES ; enable serial port int
	PUSH ACC ;save acc value
	CLR A
	MOVC A , @A+DPTR
	JZ endS ; don't print if string is finished
	MOV SBUF , A
	INC DPTR ; get next letter of string
endS:
	POP ACC
JMP PLOOP

RI_ON:
	SETB ES ; ; enable serial port int
	MOV R2 , SBUF ; get input value from sbuf
	CJNE R2 , #'1' ,CHECK_2 ;input checks
	MOV TH0 , #234D ; from calculation
	JMP LOOPER
	CHECK_2:
		CJNE R2 , #'2' , CHECK_3
		MOV TH0 , #145D
	JMP LOOPER
	CHECK_3:
		CJNE R2 , #'3' , PRTERROR
		MOV TH0 , #000D
	JMP LOOPER
	PRTERROR:
		MOV DPTR , #ERR_TXT
		SETB TI
	JMP PLOOP

CSEG AT 0200H ;

ERR_TXT:
DB 'ERROR - WRONG KEY PRESSED'
DB 13
DB 10
DB 0

<<<<<<< HEAD
PRINT:
DB '1. period of 4 us'
DB 13 ; carriege return
DB 10 ; new line
DB '2. period of 20 us '
DB 13 ; carriege return
DB 10 ; new line
DB '3. period of 46 us'
DB 13 ; carriege return
DB 10 ; new line
DB 0
=======
ERR_MSG:   DB 'ERROR - WRONG KEY PRESSED'
		   DB 13 ; CARRIAGE RETURN
		   DB 10 ; NEW LINE
		   DB 0 ; NULL

TO_SCREEN: DB '1. period of 4 us'
		   DB 13 ; CARRIAGE RETURN
		   DB 10 ; NEW LINE
		   DB '2. period of 20 us '
		   DB 13 ; CARRIAGE RETURN
		   DB 10 ; NEW LINE
		   DB '3. period of 46 us'
		   DB 13 ; CARRIAGE RETURN
		   DB 10 ; NEW LINE
		   DB 0 ; NULL

BSEG
FLAG_UART: DBIT 1

END
>>>>>>> 58c6afe56832b56b8de90dbcc8f2576bab8c29b2

BSEG
UARTF: DBIT 1

END
