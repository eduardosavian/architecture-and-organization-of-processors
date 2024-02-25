# Data-Conflict-Mitigation-in-the-MIPS-Pipeline

Computer Organization activity

## Description

Design a program that, upon input from an instruction memory file, (ROM) in machine language (hexadecimal/binary), generate a new ROM with the solution for data conflict by the method of inserting NOPS and sorting instructions.

Insertion of NOPs: NOP is a pseudo-instruction that does not modify the state of any processor register (except the PC).It can be implemented by an instruction of arithmetic or logic that has register $zero as destination. When entering nops delays the search for instructions that generate data conflict which results in performance degradation.

Instruction reordering: Instead of NOPs, the execution of instructions can be anticipated after statements that have no dependency on any before statements them and that they do not modify any registers read by such instructions. This is a more complex implementation, but which degrades performance much less.