;
; Assembly Test 2
;


; addi 1 a $e0
    agsumi $e0, $e0, 1

; addi 2 a $e1
    agsumi $e1, $e1, 2

; add $0 y $e1
    agsum $e2, $e0, $e1

; muli
    agmuli $e3, $e2, 4

; sub
    agsub $e4, $e2, $e0

; sll
    agsll $e5, $e3, 2

; srl
    agsrl $e5, $e5, 1
