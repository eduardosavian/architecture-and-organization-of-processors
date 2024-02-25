import re


def not_nop(instruction):
    return not re.match('^0{32}', instruction)


def not_syscall(instruction):
    return not re.match('^0{6}.*001100$', instruction)


def identify_type(instruction):
    instructions = {'r_type': '000000',
                    'beq': '000100', 'bne': '000101', 'j': '000010', 'jal': '000011', 'jr': '001000',
                    'lw': '100011', 'sw': '101011'}
    # Instructions that are all 0 (32) are NOP and start with 000000 and ends with 001100 are syscall
    if not_nop(instruction) and not_syscall(instruction):
        # All R-type starts with 000000
        if re.match(f"^{instructions['r_type']}", instruction):
            return 'R'
        # beq and bne start with 000100 and 000101
        if re.match(f"^{instructions['bne']}", instruction) or re.match(f"^{instructions['beq']}", instruction):
            return 'B'
        # lw start with 100011
        if re.match(f"^{instructions['sw']}", instruction):
            return 'SW'
        else:
            return 'I'
    elif not not_syscall(instruction):
        return 'SYS'
    else:
        return 'NOP'



def initialize_queue(instructions):
    queue = {}
    for instruction in instructions:
        if identify_type(instruction) == 'R':
            for i in range(6, 21, 5):
                queue.update({instruction[i:i + 5]: 0})
        if identify_type(instruction) == 'I':
            for i in range(6, 16, 5):
                queue.update({instruction[i:i + 5]: 0})
    return queue


def decrement_queue(queue):
    decremented_queue = queue
    for key in decremented_queue:
        if decremented_queue[key] > 0:
            decremented_queue[key] -= 1
    return decremented_queue
