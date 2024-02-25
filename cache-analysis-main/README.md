# Cache-analysis
#### Activity of Architecture and Organization of Processors II taught by Thiago Felski Pereira

### Description

Implement a program that performs the sum of two square matrices and stores the result in a third matrix, with the option to traverse the matrices in row-column and column-row, and analyze the hit rates of the different organization possibilities from the data cache. Requirements:
1. In the variable declaration (.data) section, each array must be declared with a space for 100 elements. They must be clearly identified with names like Matrix_A, Matrix_B and Matrix_C, for example.

2. The program must request the number of rows/columns of the matrices accepting in the maximum 10 elements. For reading, a message should be displayed requesting the entry of this value, indicating its maximum limit. For example: “Enter with
the index size of the arrays (max = 10).”.

3. The program must ask for the input of the number of elements until it is greater than 1 and less than or equal to 10. That is, it must implement a mechanism for filtering that does not accept input other than the one specified. in the case of entry invalid, the program must print a warning message before request entry again. For example: “Invalid value”.

4. The contents of the arrays, before executing the sum function, must correspond to the following structure:
Matrix_A = 0 0 0 0 0 0 0 ... 0
Matrix_B = 1 1 1 1 1 1 1 ... 1
Matrix_C = 0 1 2 3 4 5 6 ... 99

5. The contents of arrays can be declared in the data segment (.data) or then populated through code before executing the operations of sum.

6. The program must request the way in which the matrices will be traversed, being '0' for row-column and '1' for column-row. In case of invalid entry, the program must print a warning message before requesting input again. For example: “Invalid value”.

7. Programs must be written respecting the ASM programming style, using tabs to organize code into columns (labels, mnemonics, operands and comments).

8. Try to comment your code as much as possible. This is a programming habit assembly.
Analysis:
After implementation, analyze the hit rate of ALL cache combinations possible for a cache of 1024 bytes (Cache size (bytes) = 1024) in the tool MARS “Data Cache Simulator” while maintaining the LRU replacement policy. For the analysis, consider matrices with 10 rows/columns and vary the in-line access. column and column-row. Display the hit rate in ALL combinations.

Analysis: After implementation, analyze the hit rate of ALL cache combinations possible for a cache of 1024 bytes (Cache size (bytes) = 1024) in the tool MARS “Data Cache Simulator” while maintaining the LRU replacement policy. For the analysis, consider matrices with 10 rows/columns and vary the in-line access. column and column-row. Display the hit rate in ALL combinations.
