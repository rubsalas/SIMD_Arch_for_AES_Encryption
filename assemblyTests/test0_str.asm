;
;Assembly Test 0 - str instruction
;

; addi 2 a $e0
    addi $e6, $e6, 6 # $e6 = 0 + 6 = 6

; addi 2 a $e0
    addi $e5, $e5, 5 # $e5 = 0 + 5 = 5

; addi 2 a $e0
    addi $e4, $e4, 4 # $e4 = 0 + 4 = 4

; addi 2 a $e0
    addi $e3, $e3, 3 # $e3 = 0 + 3 = 3

; addi 2 a $e0
    addi $e2, $e2, 2 # $e2 = 0 + 2 = 2

; addi 1 a $e0
    addi $e1, $e1, 1 # $e1 = 0 + 1 = 1



; add entre los registros $e6 y $e5
    str $e6, 3($e0) # Guarda el valor de $e6 en la posicion 0x2003



; addi 2 a $e0
    addi $e6, $e6, 6 # $e0 = 6 + 6 = c

; addi 2 a $e0
    addi $e5, $e5, 5 # $e0 = 5 + 5 = a

; addi 2 a $e0
    addi $e4, $e4, 4 # $e0 = 4 + 4 = 8

; addi 2 a $e0
    addi $e3, $e3, 3 # $e0 = 3 + 3 = 6

; addi 2 a $e0
    addi $e2, $e2, 2 # $e0 = 2 + 2 = 4

; addi 1 a $e0
    addi $e1, $e1, 1 # $e1 = 1 + 1 = 2


;
; Bitstream divided
;
; 001000 01110 01110 0000 0000 0000 0110
; 001000 01101 01101 0000 0000 0000 0101
; 001000 01100 01100 0000 0000 0000 0100
; 001000 01011 01011 0000 0000 0000 0011
; 001000 01010 01010 0000 0000 0000 0010
; 001000 01001 01001 0000 0000 0000 0001
;
; 011000 01110 01000 0000000000000011
;
; 001000 01110 01110 0000 0000 0000 0110
; 001000 01101 01101 0000 0000 0000 0101
; 001000 01100 01100 0000 0000 0000 0100
; 001000 01011 01011 0000 0000 0000 0011
; 001000 01010 01010 0000 0000 0000 0010
; 001000 01001 01001 0000 0000 0000 0001
;



;
; Bitstream divided
;
; 00100001110011100000000000000110  => 21CE0006
; 00100001101011010000000000000101  => 21AD0005
; 00100001100011000000000000000100  => 218C0004
; 00100001011010110000000000000011  => 216B0003
; 00100001010010100000000000000010  => 214A0002
; 00100001001010010000000000000001  => 21290001
;
; 01100001110010000000000000000011  => 61C80003             // str $e6, 3($e0)
;
; 00100001110011100000000000000110  => 21CE0006
; 00100001101011010000000000000101  => 21AD0005
; 00100001100011000000000000000100  => 218C0004
; 00100001011010110000000000000011  => 216B0003
; 00100001010010100000000000000010  => 214A0002
; 00100001001010010000000000000001  => 21290001
;



;
; Bitstream divided
;
; 00100001 11001110 00000000 00000110
; 00100001 10101101 00000000 00000101
; 00100001 10001100 00000000 00000100
; 00100001 01101011 00000000 00000011
; 00100001 01001010 00000000 00000010
; 00100001 00101001 00000000 00000001
;
; 01100001 11001000 00000000 00000011           // str $e6, 3($e0)
;
; 00100001 11001110 00000000 00000110
; 00100001 10101101 00000000 00000101
; 00100001 10001100 00000000 00000100
; 00100001 01101011 00000000 00000011
; 00100001 01001010 00000000 00000010
; 00100001 00101001 00000000 00000001
;



;
; Bitstream for instruction memory
;
00000110
00000000
11001110
00100001

00000101
00000000
10101101
00100001

00000100
00000000
10001100
00100001

00000011
00000000
01101011
00100001

00000010
00000000
01001010
00100001

00000001
00000000
00101001
00100001




01100001
11001000
00000000
00000011




00000110
00000000
11001110
00100001

00000101
00000000
10101101
00100001

00000100
00000000
10001100
00100001

00000011
00000000
01101011
00100001

00000010
00000000
01001010
00100001

00000001
00000000
00101001
00100001





;
; Bitstream for .txt
;
00000110
00000000
11001110
00100001
00000101
00000000
10101101
00100001
00000100
00000000
10001100
00100001
00000011
00000000
01101011
00100001
00000010
00000000
01001010
00100001
00000001
00000000
00101001
00100001
01100001 //instr start
11001000
00000000
00000011 //instr end
00000110
00000000
11001110
00100001
00000101
00000000
10101101
00100001
00000100
00000000
10001100
00100001
00000011
00000000
01101011
00100001
00000010
00000000
01001010
00100001
00000001
00000000
00101001
00100001
