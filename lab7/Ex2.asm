;********************************************************************
;
; Authors       : Noam Solan & Ronen Rozin
;
; Date          : 19/12/18
;
; File          : mpl.lab7.ex2.asm
;
; Hardware      : 8051 based processor
;
; Description   : DACs
;
;********************************************************************
#INCLUDE <ADUC841.H>
cseg at 0000h
	jmp main

cseg at 000bh ; timer0 interupt
	jmp timer0_int ;
	reti

cseg at 001bh ; timer1 interupt
	jmp timer1_int ;
	reti

cseg at 0003h ; int0 interupt
	jmp ex_int0 ;
	reti

cseg at 0100h
main:
	anl tmod , #022h ; timers to auto reload
	orl tmod , #022h ;
	mov th1 , #206d ; 50 ticks
	mov th0 , #6d ;  250 ticks
	mov curcosval1,#0
	mov curcosval0,#0
	mov dptr , #cosine ;dptr hold the address of the beginning of the table
	setb tr1 ;turn on timer1
	setb tr0 ; turn on timer0
	setb et1 ; timer1 interrupt
	setb et0 ; timer0 interrupt
	mov daccon , #0ffh ;set daccon to required value
	setb ea
	INF_LOOP:
	jnb P3.2,$
	jnb flag, inf_loop
	mov th0 , #6d ;set timer0 to 250 tickes again
	clr flag
	jmp inf_loop

timer1_int:
	push acc ;storing value
	mov a ,curcosval1 ;getting current offset
	movc a ,@a+dptr ;getting the value in the current index in the table
	mov dac1l , a ;setting dac to table value
	inc pointer1 ; setting index to the next value in the table
	pop acc	;restoring value
	reti

timer0_int:
	push acc ;storing value
	mov a , curcosval0 ;getting current offset
	movc a ,@a+dptr ;getting the value in the current index in the table
	mov dac0l , a ;setting dac to table value
	inc curcosval0 ; setting index to the next value in the table
	pop acc ;restoring value
	reti

EX_INT0:
	mov th0 , #5D
	setb flag
	reti

dseg at 30h;
	curcosval0: ds 1
	curcosval1: ds 1
bseg at 35h
		flag: dbit 1

cseg at 0200h
	#include "table1.asm"
end
