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
; Description   : ADCs
;
;********************************************************************
#include <ADUC841.h>
CSEG AT 0000H
JMP MAIN

CSEG AT 0033H; adc int location
JMP ADC_INT
RETI

CSEG AT 0100H
MAIN:
	MOV ADCCON1, #0B8H ;setting adc with correct settings
	SETB CCONV; continuous conversion
	ANL ADCCON2, #090H ;adc on
	SETB CCONV; continuous conversion
	ANL DACCON , #07FH ;config for dac
	ORL DACCON , #2DH
	CLR TR2
	SETB EADC ; adc int
	SETB EA ;all ints
	SETB SCONV
	JMP $	;looping

ADC_INT:
		MOV DAC0L,ADCDATAL ;fetching data to dac
		MOV DAC0H,ADCDATAH
RETI

END
