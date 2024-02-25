.data
	array: .space 100
.text
	la $t7, array
	addi $t0, $zero, 1
	addi $t1, $zero, 2
	add $t4, $t0, $t1
	addi $t2, $zero, 3
	addi $t3, $zero, 4
	add $t5, $t2, $t3
	sw $t5, 0($t7)
	addi $t5, $t5, 4
