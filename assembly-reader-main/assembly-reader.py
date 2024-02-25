import re

# Função que vai ler em binário e contar a quantidade instrução, de acordo com o Dicionario, no documento e vai armazenar em outro dicionáro a contagem
def instructions_counter(file, instructions, instructions_size):

    print(f"\nArquivo: \n{file}")

   # Para cada instrução, o algoritmo irá percorrer o arquivo inteiro, linha por linha instrução por instrução, 
   # atrás de correspondentes e irá incrementar se ocorrer match
    with open(file, 'r') as file:
        for line in file:
            for instruction in instructions:
                if re.search(r'\b' + instruction, line):
                    instructions[instruction] += 1
                    
                    # o nop não é uma instrução e seu formato são 32 0s, 
                    # tem que ser decrementado para não ser confundido com um Rtype
                    if re.search(r'^0+$', line):
                        instructions[instruction] -= 1

                    # System Call não é uma instrução, seu OpCode é 000000 e termina 001100, 
                    # tem que ser decrementado para não ser confundido com um Rtype
                    if re.search(r'^000000.*001100$', line):
                        instructions[instruction] -= 1

    print('\nTipos de instruções\n')

    Rtype = '000000'
    ADDI = '001000'
    LW = '100011'
    SW = '101011'
    BEQ = '000100'
    BNE = '000101'
    SLTI = '001010'
    LUI = '001111'
    ORI = '001101'
    JAL = '000011'
    MUL = '011100'
    Jtype = '000010'
    JAL = '000011'
    ANDI = '001100'

    # Para cada tipo de instrução vai calcular a quantidade total
    R = instructions[Rtype]

    I = instructions[MUL] + instructions[BEQ] + instructions[BNE] + instructions[SLTI] + \
        instructions[LUI] + instructions[ORI] + \
        instructions[ADDI] + instructions[LW] + instructions[SW] + instructions[ANDI]

    J = instructions[Jtype] + instructions[JAL]

    #for instruction in instructions:
    #   print(f"{instruction} : {instructions[instruction]}")

    print(f"R: {R}, I: {I} e J: {J}, total de {R + I + J}")

    # Para cada tipo de instrução vai calcular a quantidade de ciclos totais
    R = instructions[Rtype] * instructions_size[Rtype]

    I = instructions[MUL] * instructions_size[MUL] + instructions[BEQ] * instructions_size[BEQ] + \
        instructions[BNE] * instructions_size[BNE] + instructions[SLTI] * instructions_size[SLTI] + \
        instructions[LUI] * instructions_size[LUI] + instructions[ORI] * instructions_size[ORI] + \
        instructions[ADDI] * instructions_size[ADDI] + instructions[LW] * instructions_size[LW] + \
        instructions[SW] * instructions_size[SW] +  instructions[ANDI] * instructions_size[ANDI]

    J = instructions[Jtype] * instructions_size[Jtype] + instructions[JAL] * instructions_size[JAL]

    print(f"\nR: {R}, I: {I} e J: {J}, total de {R + I + J}")

    benchmarking(instructions, instructions_size)

# Função que vai fazer os calculos de CPI
def benchmarking(instructions, instructions_size):

    number_of_clocks_monociclo = 0
    number_of_clocks_multiciclo = 0
    number_of_clocks_pipline = 0
    instruction_counter = 0

    for instruction in instructions:

        instruction_counter += instructions[instruction]

        number_of_clocks_monociclo += instructions[instruction]

        number_of_clocks_multiciclo += instructions[instruction] * instructions_size[instruction]

    number_of_clocks_monociclo *= 5

    number_of_clocks_pipline = 4 + instruction_counter if instruction_counter > 0 else false

    CPI = number_of_clocks_multiciclo / instruction_counter
    
    print(f"\nQuantidade de ciclos de CPU no MIPS monociclo: {number_of_clocks_monociclo}\n")

    print(f"Quantidade de ciclos de CPU no MIPS multiciclo: {number_of_clocks_multiciclo}," + \
            f" melhoria de {100 - number_of_clocks_multiciclo / number_of_clocks_monociclo * 100:.2f}% \n")

    print(f"Quantidade de ciclos de CPU no MIPS pipeline: {number_of_clocks_pipline}," +\
            f" melhoria de {100 - number_of_clocks_pipline / number_of_clocks_monociclo * 100:.2f}% em relação ao monociclo e" + \
            f" melhoria de {100 - number_of_clocks_pipline / number_of_clocks_multiciclo * 100:.2f}% em relação ao multiciclo\n")

    print(f"CPI de: {CPI:.4f} \n")

def programa(file, instructions_size):
    instructions = {}
    for instruction in instructions_size:
        instructions.update({instruction: 0})

    instructions_counter(file, instructions, instructions_size)

# Link com os OpCodes http://mipsconverter.com/opcodes.html
# Link do Artigo do Felski https://en.wikipedia.org/wiki/Cycles_per_instruction

Rtype = '000000'
ADDI = '001000'
LW = '100011'
SW = '101011'
BEQ = '000100'
BNE = '000101'
SLTI = '001010'
MUL = '011100'
LUI = '001111'
ORI = '001101'
Jtype = '000010'
JAL = '000011'
ANDI = '001100'

instructions_sizes = {Rtype: 4, ADDI: 4, MUL: 4, LW: 5, SW: 4,
                      BEQ: 3, BNE: 3, SLTI: 4, LUI: 4, ORI: 4, 
                      Jtype: 3, JAL: 4, ANDI : 4}

file1 = 'Assembly/Programa_01_Binario.txt'
programa(file1, instructions_sizes)