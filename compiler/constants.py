CLI_ERROR_CODE = 2

# types
R = 'R'
I = 'I'
J = 'J'

IMM_SIZE = 16
ADDR_SIZE = 26

#mnemonics
#Intrucciones tipo R
ADD   = 'agsum'
SUB   = 'agsub'
MULT  = 'agmul'
SLL   = 'agsl'
SRL   = 'agsr'
XOR   = 'agxor'
ADDV  = 'vagsum'
SUBV  = 'vagsub'
MULTV = 'vagmul'
XORV  = 'vagxor' 

#Instruccines tipo I
ADDI = 'agsumi'
SUBI = 'agsubi'
MULTI = 'agmuli'
STR = 'agst'
LDR = 'agld'
STRV = 'vagst'
LDRV = 'vagl'
BEQ = 'agbeq'
BGT = 'agbgt'

#Instrucciones tipo J
B = 'agb'
END = 'agend'

isa = {
    ADD   : {'type': R, 'opcode': '000000', 'funct': '000'},
    SUB   : {'type': R, 'opcode': '000000', 'funct': '001'},
    MULT  : {'type': R, 'opcode': '000000', 'funct': '010'},
    SLL   : {'type': R, 'opcode': '000000', 'funct': '011'},
    SRL   : {'type': R, 'opcode': '000000', 'funct': '111'},
    XOR   : {'type': R, 'opcode': '000000', 'funct': '101'},


    ADDV  : {'type': R, 'opcode': '100000', 'funct': '000'},
    SUBV  : {'type': R, 'opcode': '100000', 'funct': '001'},
    MULTV : {'type': R, 'opcode': '100000', 'funct': '010'},
    XORV  : {'type': R, 'opcode': '100000',  'funct': '101'},


    ADDI  : {'type': I, 'opcode': '001000'},
    SUBI  : {'type': I, 'opcode': '001001'},
    MULTI : {'type': I, 'opcode': '001010'},

    STR   : {'type': I, 'opcode': '011000'},
    LDR   : {'type': I, 'opcode': '011001'},
    
    STRV  : {'type': I, 'opcode': '111000'},
    LDRV  : {'type': I, 'opcode': '111001'},

    BEQ   : {'type': I, 'opcode': '001100'},
    BGT   : {'type': I, 'opcode': '001101'},

    B     : {'type': J, 'opcode': '000100'},
    END   : {'type': J, 'opcode': '000101'}
}

#Registers names
registers = {
    '$zero': '00000', 
    '$sp'  : '00001', 
    '$lr'  : '00010', 
    '$cpsr': '00011', 
    '$r0'  : '00100', 
    '$r1'  : '00101', 
    '$r2'  : '00110', 
    '$r3'  : '00111', 
    '$e0'  : '01000', 
    '$e1'  : '01001', 
    '$e2'  : '01010', 
    '$e3'  : '01011', 
    '$e4'  : '01100', 
    '$e5'  : '01101', 
    '$e6'  : '01110', 
    '$pc'  : '01111',
    '$v0'  : '00000',
    '$v1'  : '00001',
    '$v2'  : '00010',
    '$v3'  : '00011',
    '$v4'  : '00100',
    '$v5'  : '00101',
    '$v6'  : '00110',
    '$v7'  : '00111'
}