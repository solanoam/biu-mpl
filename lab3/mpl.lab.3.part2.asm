;********************************************************************
;
; Authors       : Noam Solan & Ronen Rozin
;
; Date          : 31/10/18
;
; File          : mpl.lab3.part2.asm
;
; Hardware      : 8051 based processor
;
; Description   : Overide EX0 intrupt, such that
;               : the LED is toggoled at every call
;
;********************************************************************

CSEG    AT    0000h
        JMP   MAIN

CSEG    AT    0003h     ; address of the interrupt
        CPL   P3.4      ; toggles the LED
        SETB  07Fh      ; flag bit
        CLR   EA        ; disabling interrupts
        RETI

CSEG    AT    0100h
MAIN:
				SETB  IT0       ; setting interrupt to edge trigged
				SETB  P3.2      ; Pulling the switch up
				SETB  EA        ; Enable interrupts
				SETB  EX0       ; Enable exact interrupt 0
LOOP:
        JNB   07fh , LOOPBEG ;checking flag bit
LOOPBEG:
        CLR		07fh			; clear flag
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
		    DJNZ    R7,DLY          ; repeat 16 times (200ms delay)
        RET
