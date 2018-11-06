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
SHW     EQU   P3.3

CSEG    AT    0000h
        JMP   MAIN

CSEG    AT    0013H     ; address of the external intrupt
        PUSH  ACC
        PUSH  PSW
        MOV   A, TH1
        ADD   A, #05h
        MOV   TH1, A
        POP   PSW
        POP   ACC
        RETI

CSEG    AT    001Bh     ; address of the timer 1 interrupt
        CPL   P3.4      ; toggles the LED
        RETI


CSEG    AT    0100h
MAIN:
        MOV   TMOD, #00100000b
        SETB  EX
        SETB  IT1
        SETB  EX1
END
