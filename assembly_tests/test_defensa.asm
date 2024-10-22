;
; Assembly Test Defensa
; Date: 05/10/24
;


; vector load a $v0 de los datos en la posicion 0 en memoria.   ----- 0x00 -> e6000000
    vagldr $v0, 00($zero)

; vector load a $v1 de los datos en la posicion 32 en memoria.  ----- 0x04 -> e6200020
    vagldr $v1, 32($zero)

; vector xor entre los datos de $v0 y $v1 recien obtenidos.     ----- 0x08 -> 82508805
    vagxor $v2, $v0, $v1

; vector add entre los datos de $v2 y $v1.                      ----- 0x0c -> 82728800
    vagadd $v3, $v2, $v1

; vector store del dato operado en el xor.                      ----- 0x10 -> e2400040
    vagst $v2, 64($zero)

; vector load a $v4 de los datos en la posicion 64 en memoria.  ----- 0x14 -> e6800040
    vagldr $v4, 64($zero)



;
; Bitstream divided
;

; 111001 10000 00000 0000 0000 0000 0000        // vagldr @ 0x00

; 111001 10001 00000 0000 0000 0010 0000        // vagldr @ 0x04

; 100000 10010 10000 10001 0000 0000 101        // vagxor @ 0x08

; 100000 10011 10010 10001 0000 0000 000        // vagadd @ 0x0c

; 111000 10010 00000 0000 0000 0100 0000        // vagstr @ 0x10

; 111001 10100 00000 0000 0000 0100 0000        // vagldr @ 0x14



;
; Bitstream divided in bytes
;

; 11100110 00000000 00000000 00000000        // vagldr @ 0x00

; 11100110 00100000 00000000 00100000        // vagldr @ 0x04

; 10000010 01010000 10001000 00000101        // vagxor @ 0x08

; 10000010 01110010 10001000 00000000        // vagadd @ 0x0c

; 11100010 01000000 00000000 01000000        // vagstr @ 0x10

; 11100110 10000000 00000000 01000000        // vagldr @ 0x14




;
; Bitstream from compiler
;
; 00000000        ; vagldr @ 0x00
; 00000000
; 00000000
; 11100110

; 00100000        ; vagldr @ 0x04
; 00000000
; 00100000
; 11100110

; 00000101        ; vagxor @ 0x08
; 10001000
; 01010000
; 10000010

; 00000000        ; vagadd @ 0x0c
; 10001000
; 01110010
; 10000010

; 01000000        ; vagstr @ 0x10
; 00000000
; 01000000
; 11100010

; 01000000        ; vagldr @ 0x14
; 00000000
; 10000000
; 11100110