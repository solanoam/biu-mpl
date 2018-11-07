;********************************************************************
;
; Authors       : Noam Solan & Ronen Rozin
;
; Date          : 07/11/18
;
; File          : mpl.lab3.asm
;
; Hardware      : 8051 based processor
;
; Description   : Changin Timer 1 each overflow to a shorter
;               : counter time
;
;********************************************************************
LED     EQU   P3.4      ; P3.4 is red LED on eval board
SWT     EQU   P3.3		; Switch

CSEG    AT    0000h
        JMP   MAIN

CSEG    AT    0013H     ; address of the external intrupt 1
        SETB  FLAG
		RETI

CSEG    AT    001Bh     ; address of the timer 1 interrupt
        CPL   P3.4      ; toggles the LED
        RETI


CSEG    AT    0100h
MAIN:
        ORL   TMOD, #11110000b
		ANL	  TMOD, #00101111b
        CLR   TF1
		SETB  TR1
		MOV   TH1, #00h
		SETB  IT1
        SETB  EX1
		SETB  ET1
		SETB  EA
LOOP:
		JB    FLAG , EI1CONT 
		JMP   LOOP
EI1CONT:
		PUSH  ACC		
        PUSH  PSW
		CLR   FLAG
        MOV   A, TH1
        ADD   A, #05h
        MOV   TH1, A
        POP   PSW
        POP   ACC
        JMP   LOOP

BSEG
FLAG: 	DBIT 1
END