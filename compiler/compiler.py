import sys
import getopt
from constants import *
import re

def get_args(argv: list) -> tuple:
    """
    Returns command-line arguments with options:
        -i,--ifile : input file name
        -o,--ofile : output file name
    """
    input_file = ''
    output_file = ''
    try:
        opts, _ = getopt.getopt(argv, "hi:o:", ["ifile=", "ofile="])
    except getopt.GetoptError:
        print('Command line argument syntax error.\nCorrect command format is:\n\tpython interpreter.py -i <inputfile> -o <outputfile>')
        sys.exit(CLI_ERROR_CODE)
    for opt, arg in opts:
        if opt == '-h':
            print('python interpreter.py -i <inputfile> -o <outputfile>')
            sys.exit()
        elif opt in ("-i", "--ifile"):
            input_file = arg
        elif opt in ("-o", "--ofile"):
            output_file = arg
    return input_file, output_file

def get_instructions(input_file_name : str) -> tuple:
    """
    Returns list of instructions and labels' dictionary
    """
    try:
        with open(input_file_name, mode="r") as f:
            instructions = clean_instructions(f)
            instructions, labels = get_labels(instructions)
        return (instructions, labels)

    except Exception as e:
        print(e)

def write_binary(instructions: list, output_file: str):
    with open(output_file, 'w') as f:
        for instr in instructions:
            f.write(f"{instr}\n")

def clean_instructions(file) -> list:
    """
    Remove empty lines and trailing white spaces
    """
    instructions = []
    for line in file:
        line = line.split('#')[0] #remove comments
        line = line.strip()
        if line:
            line = re.split(r'[,\s]+', line) #remove white space or ','
            instructions.append(line)
    return instructions

def get_labels(instructions: list) -> tuple:
    """
    Sets labels' dictionary and removes labels from instructions list
    """
    labels = {}
    for i, instr in enumerate(instructions):
        if len(instr) == 1:
            label = instr[0].replace(":","")
            labels[label] = i
            instructions.pop(i)
    return (instructions, labels)

def get_binary(instructions: list, labels: dict) -> list:
    """
    Transforms every assembly instruction to its equivalent in binary
    """
    bin_instr = []
    for i, instr in enumerate(instructions):
        mnemonic = instr[0]
        try:
            instr_type = isa[mnemonic]['type']
            
            if instr_type == R:
                bin_i = get_r_type(instr)

            if instr_type == I:
                bin_i = get_i_type(i, instr, labels)
            
            if instr_type == J:
                bin_i = get_j_type(instr, labels)

          #  if instr_type == None:
           #     bin_i = isa[mnemonic]['opcode'] + '0' * ADDR_SIZE

            bin_instr.append(bin_i)
        
        except KeyError:
            raise Exception(f'Error: instruction "{mnemonic}" does not exist.')
    
    return bin_instr

def get_register(reg_name):
    try:
        reg = registers[reg_name]
        return reg
    except KeyError:
      raise Exception(f'Error: register "{reg_name}" does not exist.')

#-----------------------------------------------------------------------
# Methods to convert instructions to binary

def get_r_type(instruction: list) -> str:
    """
    Transforms R type instruction to binary
    """
    mnemonic = instruction[0]
    opcode = isa[mnemonic]['opcode']
    s1 = isa[mnemonic]['S1']
    funct = isa[mnemonic]['funct']
    s0 = isa[mnemonic]['S0']

    if (mnemonic == ADD or mnemonic == SUB or mnemonic == MULT or 
        mnemonic ==  ADDF or mnemonic == SUBF or mnemonic == MULTF
        or mnemonic == ADDV or mnemonic == SUBV or mnemonic == MULTV
        or mnemonic == ADDVF or mnemonic == SUBVF or mnemonic == MULTVF
        or mnemonic == GETV):
        rd = get_register(instruction[1])
        rs = get_register(instruction[2])
        rt = get_register(instruction[3])
        shamt = '0000'
    
    if (mnemonic == SLL or mnemonic == SRL):
        rd = get_register(instruction[1])
        rs = get_register(instruction[2])
        rt = '0000'
        shamt = to_bin(instruction[3], 4)

    return opcode  + s1 +  rd + rs + rt  + shamt  + funct  + s0
    #return opcode + ',' + s1 + ',' + rd + ',' + rs + ',' + rt + ',' + shamt + ',' + funct + ',' + s0


def get_i_type(i: int, instruction: list, labels: dict) -> str:
    """
    Transforms I type instruction to binary
    """
    mnemonic = instruction[0]
    opcode = isa[mnemonic]['opcode']
    s1 = isa[mnemonic]['S1']
    s0 = isa[mnemonic]['S0']

    if (mnemonic == ADDI or mnemonic == SUBI or mnemonic == MULTI or mnemonic == SDLV):
        rd = get_register(instruction[1])
        rs = get_register(instruction[2])
        imm = to_bin(instruction[3], 11)

    if (mnemonic == BEQ or mnemonic == BGT or mnemonic == BNQ):
        rd = get_register(instruction[1])
        rs = get_register(instruction[2])
        imm = branch_imm(i, instruction[3], labels) 
        #imm = to_bin(instruction[3], 11)

    #Load y store solo sirven sin inmediato de momento (arreglar)

    if (mnemonic == STR or mnemonic == LDR or
        mnemonic == STRV or mnemonic == LDRV):
        rd = get_register(instruction[1])
        rs = get_register(instruction[2])
        imm = to_bin(instruction[3], 11)

    return opcode  + s1  + rd  + rs  + imm + s0
    #return opcode + ',' + s1 + ',' + rd + ',' + rs + ',' + imm + ',' + s0


def get_j_type(instruction: list, labels: dict) -> str:
    """
    Transforms J type instruction to binary
    """
    mnemonic = instruction[0]
    opcode = isa[mnemonic]['opcode']
    s1 = isa[mnemonic]['S1']
    s0 = isa[mnemonic]['S0']

    if (mnemonic == B):
        addr = jump_imm(instruction[1], labels)
        #addr = to_bin(instruction[1], 19)

    if (mnemonic == END or mnemonic == DNT):
        #addr = jump_imm(instruction[1], labels)
        addr = '1' * ADDR_SIZE

    #return opcode + ',' + s1 + ',' + addr + ',' + s0
    return opcode + s1 + addr + s0

#-----------------------------------------------------------------------
# Methods to compute immediate binary values for different types of instructions

def branch_imm(index, label, labels):
    try:
        b_dest = labels[label]
        imm = b_dest - (index + 1)
        return to_bin(imm, IMM_SIZE)

    except KeyError:
       raise Exception(f'Error: label "{label}" does not exist.')

def jump_imm(label, labels):
    try:
        imm = labels[label]
        bin_str = to_bin(imm, ADDR_SIZE)
    except KeyError:
        raise Exception(f'Error: label "{label}" does not exist.')
    return bin_str

def to_bin(num: str, bits:int) -> list:
    """
    Transforms 'num' integer in hex or decimal base to binary
    Returns binary as string with the amount of characters specified by 'bits'
    """
    try:
        num = int(num)
    except ValueError:
        num = int(num,16)
    
    if num >= 0:
        bin_str = bin(num)[2:]
        bin_str = bin_str.rjust(bits, '0') 
    else:
        bin_str = bin(2**bits + num)[2:]

    return bin_str

#-----------------------------------------------------------------------

if __name__ == "__main__":
    try:
        input_file, output_file = get_args(sys.argv[1:])
        if input_file == '' or output_file == '':
            raise Exception("Missing argument(s).\nCorrect command format is:\n\tpython interpreter.py -i <inputfile> -o <outputfile>")
        else:
            instr, labels = get_instructions(input_file)
            bin_intr = get_binary(instr, labels)
            write_binary(bin_intr, output_file)
    except Exception as e:
        print(e)