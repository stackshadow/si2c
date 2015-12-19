
.global si2cSlaveReadByte
si2cSlaveReadByte:
    ldi	rTemp1, 0					    ; temporary byte
	ldi rTemp2, 8					    ; temporary byte
	ldi rReturnState, 0				    ; Clean return bit

si2cSlaveReadBit:
; ################## wait for SCL high ##################
si2cSlaveRB001:
    sbic IS_SCL_ASM                     ; if 1
    rjmp si2cSlaveRB002                 ; then
    rjmp si2cSlaveRB001                 ; else


; ################## read SDA ##################
si2cSlaveRB002:
    sbic IS_SDA_ASM                     ; if 1
    sbr rTemp1, 1                       ; then


; ################## wait for SCL low ##################
si2cSlaveRB003:
    sbis IS_SCL_ASM                     ; if 0
    rjmp si2cSlaveRBNext                ; then


; from here we must check if SDA changes
    sbic IS_SDA_ASM                     ; if 1
    rjmp si2cSlaveRB004                 ; then
    rjmp si2cSlaveRB005                 ; else

; SDA is now 1
si2cSlaveRB004:
    sbrs rTemp1, 0                      ; if 0 ( SDA was low before )
    rjmp si2cSlaveRBStop                ; then
    rjmp si2cSlaveRB003                 ; else

; SDA is now 0
si2cSlaveRB005:
    sbrc rTemp1, 0                      ; if 1 ( SDA was high before )
    rjmp si2cSlaveRBRestart             ; then
    rjmp si2cSlaveRB003                 ; else


si2cSlaveRBNext:
    dec rTemp2
    cpi rTemp2, 0
    breq si2cSlaveRBFinish              ; jump if 0
    lsl rTemp1                          ; shift to next bit
    rjmp si2cSlaveReadBit

si2cSlaveRBStop:
	ldi rReturnState, 3				    ; return stop
    ret

si2cSlaveRBRestart:
	ldi rReturnState, 2				    ; return restart
    ret
    
si2cSlaveRBFinish:
    sts si2cByte,rTemp1
	ldi rReturnState, 1				    ; return finish
    ret
