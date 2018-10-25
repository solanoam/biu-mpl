;********************************************************************
;
; Author        : ADI - Apps            www.analog.com/MicroConverter
; Revised by	: Shlomo Engelberg
;
; Date          : 28 May 1999
; Rev. Date:	: 23 May 2002
; Rev. Date:    : 27 August 2006
; Rev. Date:	: 8 October 2006
;
; File          : blse841.asm
;
; Hardware      : Any 8052 based MicroConverter (ADuC8xx)
;
; Description   : Blinks LED continuously.
;                 The LED is kept on for 1s and off for 100ms.
;
;********************************************************************

LED     EQU     P3.4            ; P3.4 is red LED on eval board

;____________________________________________________________________
                                                       ; MAIN PROGRAM
CSEG

ORG  0000h

CLR 		LED					     ; clear the LED
BLINK:  CPL     LED             ; flash (complement) the red LED
        CALL    DELAY1          ; call short software delay
		CPL      LED				; comp. the LED
		CALL	DELAY1			; call long delay
        JMP      BLINK           ; repeat indefinately

;____________________________________________________________________
                                                        ; SUBROUTINES

DELAY:                          ; delay of approx. 100ms
        MOV     R7,#78          ; 8 * 12.41ms = 99.4ms. multiplied by 78, we get 1 seconds
        MOV     R6,#200         ; 200 * 62.1us = 12.42ms
			MOV     R5,#229         ; 229 * 0.271us = 62.1us
DLY:   	DJNZ    R5,$            ; sit here for 0.271 us
		MOV		R5,#229
        DJNZ    R6,DLY          ; repeat 200 times (12.4ms delay)
        MOV		R6,#200
		DJNZ    R7,DLY          ; repeat 80 times (1sec delay)
        RET

DELAY1:                         ; delay approx. 1s

        MOV     R4,#5          ; as we use the same deley for on and of, we get the deley of 1sec * 5 = 5sec 
DLY1:	CALL	DELAY
        DJNZ    R4,DLY1         ; repeat 10 times (1s delay)
        RET

;____________________________________________________________________

END
