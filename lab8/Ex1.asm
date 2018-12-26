;********************************************************************
;
; Authors       : Noam Solan & Ronen Rozin
;
; Date          : 26/12/18
;
; File          : mpl.lab8.ex1.asm
;
; Hardware      : 8051 based processor
;
; Description   : ADCs
;
;********************************************************************
#include <ADUC841.h>
CSEG AT 0000H
JMP MAIN

CSEG AT 002BH; timer1 int location
JMP TIMER2_INT
RETI

CSEG AT 0033H; adc int location
JMP ADC_INT
RETI


CSEG AT 0100H
MAIN:
	MOV ADCCON1, #0B8H;setting adc with correct settings
	CLR CCONV;no continuous conversion
	ANL ADCCON2,#090H ;adc on
	ANL T2CON, #044H; config for timer2
	ANL DACCON , #07FH;config for dac
	ORL DACCON , #2DH
	SETB TR2; timer2 enable
	SETB EADC; adc int
	SETB ET2; timer2 int
	SETB EA;all ints
	JMP $; looping

ADC_INT:
		MOV DAC0L,ADCDATAL;fetching data to dac
		MOV DAC0H,ADCDATAH
RETI

TIMER2_INT:
	CLR TF2
	SETB SCONV
RETI

END
