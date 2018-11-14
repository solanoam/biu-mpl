;********************************************************************
;
; Authors       : Noam Solan & Ronen Rozin
;
; Date          : 14/11/18
;
; File          : mpl.lab4.asm
;
; Hardware      : 8051 based processor
;
; Description   : Transmitting and receiving from UART
;
;********************************************************************
CSEG AT 0h
JMP MAIN

CSEG AT 023h ; serial interrupt address
JMP SERINT

CSEG AT 0100h
MAIN:
  CLR SM0 ; turn off SM0
  SETB SM1 ; turn on SM1
  SETB REN ; turn on REN
  CLR RI ; must be reset after every input
  CLR ET1 ; clear timer1 interrupt
  ANL PCON, #01111111b
  ANL TMOD , #00101111b ; timer mode 2
  ORL TMOD , #00100000b ; timer mode 2
  MOV TH1 , #112d ;  setting baud rate to 2400
  SETB ES ; enable serial interrupt
  SETB TR1 ; enable timer1
  SETB EA ; enable interrupts
  JMP $ ; loop

SERINT:
  JBC RI, INPUT ; clear RI and continue getting input
  RETI

INPUT:
  PUSH ACC ;preserving ACC
  MOV ACC, SBUF ; get value from SBUF
  XRL A, #00100000b  ;convert case
  MOV SBUF, ACC ; send value to SBUF
  POP ACC ;restoring ACC
  RETI

END
