;********************************************************************
;
; Authors       : Noam Solan & Ronen Rozin
;
; Date          : 07/11/18
;
; File          : mpl.lab3.part2.asm
;
; Hardware      : 8051 based processor
;
; Description   : Changin Timer 1 each overflow to a shorter
;               : counter time
;
;********************************************************************
LED     EQU   P3.4      ; P3.4 is red LED on eval board
SHW     EQU   P3.3

CSEG    AT    0000h
        JMP   MAIN

CSEG    AT    0003h     ; address of the interrupt
        CPL   P3.4      ; toggles the LED
        SETB  FLAG      ; flag bit
        CLR   EX0        ; disabling interrupts
        RETI

CSEG    AT    0100h
MAIN:
		CLR   FLAG
		SETB  IT0       ; setting interrupt to edge trigged
		SETB  P3.2      ; Pulling the switch up
		SETB  EX0       ; Enable exact interrupt 0
		SETB  EA        ; Enable interrupts
LOOP:
		JB    FLAG , LOOPBEG ;checking flag bit
		JMP   LOOP
LOOPBEG:
        CLR		FLAG			; clear flag
        CALL 	DELAY			; call 200ms delay
        CLR		IE0
        SETB	EX0
        JMP		LOOP	    ; loop
DELAY:
        MOV     R7,#16          ; 16 * 12.41ms = 198.56ms
        MOV     R6,#200         ; 200 * 62.1us = 12.42ms
        MOV     R5,#229         ; 229 * 0.271us = 62.1us
DLY:    DJNZ    R5,$            ;
		    MOV		  R5, #229        ; repeat 229 times (62.1us)
        DJNZ    R6,DLY          ;
        MOV		  R6, #200        ; repeat 200 times (12.4ms delay)
		    DJNZ    R7,DLY          ; repeat 160 times (200ms delay)
        RET
BSEG
FLAG: 	DBIT 1

END
