
#include <ADuC841.H>
LED equ p3.4

cseg at 00h  
jmp main

cseg at 000bh   ;timer 0 interupt address
cpl p3.4        ;negating state of led to validate code
reti

cseg at 0023h ; serial interrupt address
jmp eisr      ;jumping to interrupt handler
reti

cseg at 0100h  ;main
main:
clr ti
orl TMOD , #00100010b ;timer 0 and timer 1 in autoreload mode
ANL TMOD , #11111010B
anl PCON , #01111111b ;set the SMOD bit for the baud rate
mov TH1 , #250d ;initialize the timer 1 overflow rate for the baud rate
mov TL1 , #250d
mov th0,#145d   ;initialze timer zero to negate cpl in rate requested
mov tl0,#145d
;uart set up
clr SM0
setb SM1    
setb REN
;end set up uart
setb tr0        ; start timer0
setb TR1        ; start timer 1
clr ET1         ;do not enable the external interrupt timer 1
setb et0        ;enable timer0 interrupt
setb ES         ; enable serial interrupt
setb EA         ;enable "all" the interrupt
jmp $           ;initiate infinite loop

eisr:
clr ti          ;prepare the transmission of the next byte
jbc RI,receive  ;if we receive the data
reti
receive:
mov A,SBUF             ; read the data from the SBUF
mov r0,A               ;move accumulator value into register
cjne r0,#'!',notreduce ;checking if input was '!'
anl pllcon,#00000000b  ;if indeed input was '!'
orl pllcon,#00000001b  ;lowering the cpu clock by half
mov th1,#253d          ;reconfiguring baud rate to new cpu clock    
mov tl1,#253d          ;preventing change in baud rate after transition
reti

notreduce:
cjne r0,#')',regular   ;checking if input was ')' if so
anl pllcon,#00000000b  ;setting cpu clock back to 11.0592
mov th1,#250d          ;setting baud rate according to new clock 
mov tl1,#250d          ;preventing change in baud rate after transition
reti
regular:       
mov SBUF,A             ;write accumulator value into SBUF 
clr RI                 ; signal that we finish the reception
reti
end



