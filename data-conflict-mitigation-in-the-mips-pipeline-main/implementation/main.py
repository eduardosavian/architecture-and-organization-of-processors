from file_interactions import read_file, write_file_nops, write_file_reorder
from nops import insertion_of_nops
from reorderer import instruction_reorderer

if __name__ == '__main__':
    file = 'test_binaries'
    instructions = read_file(file)
    # instructions_nops = insertion_of_nops(instructions)
    # write_file_nops(file, instructions_nops)

    instructions_reorder = instruction_reorderer(instructions)
    write_file_reorder(file, instructions_reorder)
    instructions_nops = insertion_of_nops(instructions_reorder)
    write_file_nops(file, instructions_nops)
