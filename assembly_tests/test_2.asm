;
; Assembly Test 2
;
;



; addi 1 a $e0
    addi $e0, $e0, 1                ; 0x00 -> 

; addi 2 a $e1
    addi $e1, $e1, 2

; add $0 y $e1
    add $e2, $e0, $e1

; muli
    muli $e3, $e2, 4

; sub
    sub $e4, $e2, $e0

; sll
    sll $e5, $e3, 2

; srl
    srl $e5, $e5, 1



;
; Bitstream divided
;
; 001000 01000 01000 0000 0000 0000 0001        // addi @ 0x00
;
; 001000 01001 01001 0000 0000 0000 0010        // addi @ 0x04
;



