;********************************************************************
;
; Authors       : Noam Solan & Ronen Rozin
;
; Date          : 31/10/18
;
; File          : mpl.lab3.part1.asm
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
        RETI

CSEG    AT    0100h
MAIN:
				SETB  IT0       ; setting interrupt to edge trigged
				SETB  P3.2      ; Pulling the switch up
				SETB  EA        ; Enable interrupts
				SETB  EX0       ; Enable exact interrupt 0
LOOP:   JMP   $         ; Looping