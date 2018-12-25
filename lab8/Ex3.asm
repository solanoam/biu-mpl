;********************************************************************
;
; Authors       : Noam Solan & Ronen Rozin
;
; Date          : 26/12/18
;
; File          : mpl.lab8.ex3.asm
;
; Hardware      : 8051 based processor
;
; Description   : DACs
;
;********************************************************************
#include <ADUC841.h>
CSEG AT 0000H
	JMP MAIN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CSEG AT 0033H ; ADDRESS OF ADC INTERUPT
	JMP ADC_INT ;
RETI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CSEG AT 0100H ; MAIN

MAIN:

	MOV ADCCON1, #0B8H ; DEFINE ADC AS  10111000
    ;[EN(1)][ACCORDING TO V REFFERNCE(0)][DIVIDE BY 2(11)][AMOUNT OF CYCLES TO SAMPLE(10)][ACCORDING TO TIMER2(0)][OUTER(0)]
	CLR CCONV ; CLR BIT 5 OF ADCCON2
	ANL ADCCON2,#090H ;TURN ON ADC
	SETB CCONV; CONTINUOUS CONVERSION
	ANL DACCON , #07FH ;DAC CONFIG
	ORL DACCON , #2DH
	;-----SET INTERUPTS-----
	SETB EADC ; TURN ON ADC INTERRUPT
	SETB EA ; GLOBAL INTERRUPT ENABLE
	SETB SCONV
	JMP $	;INF LOOP

ADC_INT:
		MOV DAC0L,ADCDATAL ; COPY ADC OUTPUT TO DAC INPUT
		MOV DAC0H,ADCDATAH
RETI

END
