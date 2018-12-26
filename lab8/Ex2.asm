;********************************************************************
;
; Authors       : Noam Solan & Ronen Rozin
;
; Date          : 26/12/18
;
; File          : mpl.lab8.ex2.asm
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
	MOV ADCCON1, #0BAH ;setting adc with correct settings
	CLR CCONV ; no continuous conversion
	ANL ADCCON2,#090H ;adc on
	ANL T2CON, #044H ;config for timer 2
	SETB TR2; enable timer2
	ANL DACCON , #07FH ;config for dac
	ORL DACCON , #2DH
	SETB EADC ; adc int
	SETB EA ;all ints
	JMP $	;looping

ADC_INT:
		MOV DAC0L,ADCDATAL ;fetching data to dac
		MOV DAC0H,ADCDATAH
RETI

END
