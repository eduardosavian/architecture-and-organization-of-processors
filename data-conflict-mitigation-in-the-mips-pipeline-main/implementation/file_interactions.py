def read_file(filename):
    instructions = []
    with open(filename+'.txt', 'r') as file:
        for line in file:
            instructions.append(line.strip())
    return instructions


def write_file_nops(filename, instructions):
    with open(filename+'_rn.txt', 'w') as file:
        for instruction in instructions:
            file.write(instruction + '\n')


def write_file_reorder(filename, instructions):
    with open(filename+'_rr.txt', 'w') as file:
        for instruction in instructions:
            file.write(instruction + '\n')
