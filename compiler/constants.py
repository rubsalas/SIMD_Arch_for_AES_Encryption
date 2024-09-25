CLI_ERROR_CODE = 2

# types
R = 'R'
I = 'I'
J = 'J'

IMM_SIZE = 11
ADDR_SIZE = 19

#mnemonics
#Intrucciones tipo R
ADD = 'som'
SUB = 'sou'
MULT = 'mlt'
SLL = 'cori'
ADDF = 'somf'
SUBF = 'souf'
MULTF = 'mltf'
SRL = 'cord'
ADDV = 'somv'
SUBV = 'souv'
MULTV = 'mltv'
ADDVF = 'somvf'
SUBVF = 'souvf'
MULTVF = 'mltvf'


#Instruccines tipo I
ADDI = 'somi'
SUBI = 'soui'
MULTI = 'mlti'
STR = 'gar'
LDR = 'car'
STRV = 'garv'
LDRV = 'carv'
BEQ = 'cmpe'
BNQ = 'cmpn'
BGT = 'cmpm'
SDLV = 'sdlv'
GETV = 'getv'

#Instrucciones tipo J
B = 'sau'
DNT = 'dnt'
END = 'fin'

isa = {
    ADD : {'type': R, 'opcode': '000', 'S1':'0', 'funct': '000', 'S0':'0'},
    SUB : {'type': R, 'opcode': '000', 'S1':'0', 'funct': '001', 'S0':'0'},
    MULT : {'type': R, 'opcode': '000', 'S1':'0', 'funct': '010', 'S0':'0'},
    SLL : {'type': R, 'opcode': '000', 'S1':'0', 'funct': '011', 'S0':'0'},
    ADDF : {'type': R, 'opcode': '000', 'S1':'0', 'funct': '100', 'S0':'0'},
    SUBF : {'type': R, 'opcode': '000', 'S1':'0', 'funct': '101', 'S0':'0'},
    MULTF : {'type': R, 'opcode': '000', 'S1':'0', 'funct': '110', 'S0':'0'},
    SRL : {'type': R, 'opcode': '000', 'S1':'0', 'funct': '111', 'S0':'0'},
    GETV : {'type': R, 'opcode': '100', 'S1':'0', 'funct': '11', 'S0':'0'},


    ADDV : {'type': R, 'opcode': '001','S1':'0', 'funct': '000','S0':'0'},
    SUBV : {'type': R, 'opcode': '001', 'S1':'0','funct': '001','S0':'1'},
    MULTV : {'type': R, 'opcode': '001', 'S1':'1', 'funct': '010','S0':'0'},
    ADDVF : {'type': R, 'opcode': '001','S1':'0', 'funct': '100','S0':'0'},
    SUBVF : {'type': R, 'opcode': '001','S1':'0', 'funct': '101','S0':'1'},
    MULTVF : {'type': R, 'opcode': '001','S1':'1', 'funct': '110','S0':'0'},

    ADDI : {'type': I, 'opcode': '010','S1':'0','S0':'0'},
    SUBI : {'type': I, 'opcode': '010','S1':'0','S0':'1'},
    MULTI : {'type': I, 'opcode': '010','S1':'1','S0':'0'},

    LDR : {'type': I, 'opcode': '011','S1':'0','S0':'0'},
    STR : {'type': I, 'opcode': '011','S1':'0','S0':'1'},
    LDRV : {'type': I, 'opcode': '101','S1':'0','S0':'0'},
    STRV : {'type': I, 'opcode': '101','S1':'0','S0':'1'},

    BEQ : {'type': I, 'opcode': '110','S1':'0','S0':'0'},
    BNQ : {'type': I, 'opcode': '110','S1':'0','S0':'1'},
    BGT : {'type': I, 'opcode': '110','S1':'1','S0':'0'},
    SDLV : {'type': I, 'opcode': '100','S1':'0','S0':'0'},

    B : {'type': J, 'opcode': '110','S1':'1','S0':'1'},
    DNT : {'type': J, 'opcode': '111','S1':'1','S0':'1'},
    END: {'type': J, 'opcode': '111','S1':'0','S0':'0'}
}

#Registers names
registers = {
    '$zero': '0000', 
    '$sp'  : '0001', 
    '$lr'  : '0010', 
    '$cpsr': '0011', 
    '$r0'  : '0100', 
    '$r1'  : '0101', 
    '$r2'  : '0110', 
    '$r3'  : '0111', 
    '$e0'  : '1000', 
    '$e1'  : '1001', 
    '$e2'  : '1010', 
    '$e3'  : '1011', 
    '$e4'  : '1100', 
    '$e5'  : '1101', 
    '$e6'  : '1110', 
    '$pc'  : '1111',
    '$v0'  : '0000',
    '$v1'  : '0001',
    '$v2'  : '0010',
    '$v3'  : '0011',
    '$v4'  : '0100',
    '$v5'  : '0101',
    '$v6'  : '0110',
    '$v7'  : '0111'
}