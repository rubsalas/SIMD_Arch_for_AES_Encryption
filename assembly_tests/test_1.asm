;
; Assembly Test 1
;

; addi 2 a $e0 
    addi $e0, $e0, 2 # $e0 = 0 + 2 = 2      ; 0x00 -> 21080002

; addi 3 a $e1
    addi $e1, $e1, 3 # $e1 = 0 + 3 = 3      ; 0x04 -> 21290003 

; addi 6 a $e6 
    addi $e6, $e6, 6 # $e6 = 0 + 6 = 6      ; 0x08 -> 21ce0006

; addi 5 a $e5 
    addi $e5, $e5, 5 # $e5 = 0 + 5 = 5      ; 0x0c -> 21ad0005 

; beq entre $e0 y $e1 y salta a direccion b1_1100, pero No son iguales, no deberia saltar 
    beq $e0, $e1, b1_1100                   ; 0x10 -> 3109001c

; addi de 1 a $e0
    addi $e0, $e0, 1 # $e0 = 2 + 1 = 3      ; 0x14 -> 21080001

; beq entre $e0 y $e1 y salta a direccion b10_0000 (mul), Son iguales, deberia saltar 
    beq $e0, $e1, b10_0000                  ; 0x18 -> 31090020   

; addi de 16 a $e0
    addi $e3, $e3, 16 # $e0 = 0 + 16 = 16   ; 0x1c -> 216b0010

; mul de 1 a $e0
    mul $e2, $e1, $e0  # $e2 = 3 * 3 = 9    ; 0x20 -> 1494002

; b 
    b b0000                                 ; 0x24 -> 10000000



;
; Bitstream divided
;
; 001000 01000 01000 0000 0000 0000 0010        // addi @ 0x00

; 001000 01001 01001 0000 0000 0000 0011        // addi @ 0x04

; 001000 01110 01110 0000 0000 0000 0110        // addi @ 0x08

; 001000 01101 01101 0000 0000 0000 0101        // addi @ 0x0c

; 001100 01000 01001 0000 0000 0001 1100        // beq  @ 0x10

; 001000 01000 01000 0000 0000 0000 0001        // addi @ 0x14

; 001100 01000 01001 0000 0000 0010 0000        // beq  @ 0x18

; 001000 01011 01011 0000 0000 0001 0000        // addi @ 0x1c

; 000000 01010 01001 01000 0000 0000 010        // mul  @ 0x20

; 000100 000000 0000 0000 0000 0000 0000        // b    @ 0x24



;
; Bitstream divided
;
; 00100001 00001000 00000000 00000010        // addi

; 00100001 00101001 00000000 00000011        // addi

; 00100001 11001110 00000000 00000110        // addi

; 00100001 10101101 00000000 00000101        // addi

; 00110001 00001001 00000000 00011100       // beq

; 00100001 00001000 00000000 00000001        // addi

; 00110001 00001001 00000000 00100000       // beq

; 00100001 01101011 00000000 00010000        // addi

; 00000001 01001001 01000000 00000010        // mul

; 00010000 00000000 00000000 00000000       // b



;
; Bitstream for instruction memory
;
00000010
00000000
00001000
00100001

00000011
00000000
00101001
00100001

00000110
00000000
11001110
00100001

00000101
00000000
10101101
00100001

00011100
00000000
00001001
00110001

00000001
00000000
00001000
00100001

00100000
00000000
00001001
00110001

00010000
00000000
01101011
00100001

00000010
01000000
01001001
00000001

00000000
00000000
00000000
00010000
