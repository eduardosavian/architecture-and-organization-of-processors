from common_functions import identify_type, initialize_queue, decrement_queue


def insertion_of_nops(instructions):
    nop = '0' * 32
    nop_instructions = []
    queue = initialize_queue(instructions)
    i = 0

    while i < len(instructions):
        instruction = instructions[i]
        instruction_type = identify_type(instruction)
        if instruction_type == 'R':
            rs = instruction[6:11]
            rt = instruction[11:16]
            rd = instruction[16:21]
            if queue[rd] == 0 and queue[rt] == 0 and queue[rs] == 0:
                nop_instructions.append(instruction)
                queue.update({rd: 3})
            else:
                nop_instructions.append(nop)
                i -= 1

        if instruction_type == 'I':
            rt = instruction[11:16]
            rs = instruction[6:11]
            if queue[rt] == 0 and queue[rs] == 0:
                nop_instructions.append(instruction)
                queue.update({rt: 3})
            else:
                nop_instructions.append(nop)
                i -= 1

            # Branch add 1 nop after
        if instruction_type == 'B':
            rs = instruction[6:11]
            rt = instruction[11:16]
            if queue[rt] == 0 and queue[rs] == 0:
                nop_instructions.append(instruction)
                nop_instructions.append(nop)
            else:
                nop_instructions.append(nop)
                i -= 1

        if instruction_type == 'SW':
            rt = instruction[11:16]
            rs = instruction[6:11]
            if queue[rt] == 0 and queue[rs] == 0:
                nop_instructions.append(instruction)
                queue.update({rt: 2})
            else:
                nop_instructions.append(nop)
                i -= 1

        if instruction_type == "SYS":
            if queue['000010'] == 0:
                nop_instructions.append(instruction)
                queue.update({'000010': 1})
            else:
                nop_instructions.append(nop)
                i -= 1

        if instruction_type == 'NOP':
            nop_instructions.append(instruction)
        queue = decrement_queue(queue)

        i += 1
    return nop_instructions
