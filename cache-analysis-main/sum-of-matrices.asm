################################################################
# Disciplina: Arquitetura e Organização de Computadores II
# Atividade: Avaliação 03 – Hierarquia de Memória
# Programa 01
# Grupo: - Eduardo Savian de Oliveira
#        - Marcos Augusto Fehlauer Pereira
#        - Vini Ritzel

.macro scan_int () # escaneia int
	li $v0, 5
	syscall
.end_macro

.macro print_int_array (%x) # print a posicao de um array
	li $v0, 1
	lw $a0, 0(%x)
	syscall
.end_macro

.macro var_plus_plus (%x) # incrementa em 1 o registrador
	addi %x, %x, 1
.end_macro

.macro print_str (%str) # printar frase
.data
myLabel: .asciiz %str
.text
	li $v0, 4
	la $a0, myLabel
	syscall
.end_macro

.macro print_array (%array, %i) # printa a posiçaõ do array
	addi $sp, $sp, -8
	sw %array, 4($sp)
	sw %i, 0($sp)
	
	increment_array (%array, %i)
	
	print_int_array (%array)
	
	sub %array, %array, %i 
	
	lw %i, 0($sp)
	lw %array, 4($sp)
	addi $sp, $sp, 8
.end_macro

.macro save_x_array (%arrayWB, %arrayA, %arrayB, %x, %y %z)
	addi $sp, $sp, -12
	sw %z, 8($sp)
	sw %y, 4($sp)
	sw %x, 0($sp)
	
	lw %y, 0(%arrayA) # y = arraA[i]
	lw %z, 0(%arrayB) # Z = arraB[i]
	
	add %x, %y, %z # X = matrixA[j] + matrizB[j]
	
	sw %x, 0(%arrayWB) # # matrizC[j] = matrixA[i] + matrizB[i]
	
	lw %x, 0($sp)
	lw %y, 4($sp)
	lw %z, 8($sp)
	addi $sp, $sp, 12
.end_macro

.macro increment_array (%array, %i)
	addi $sp, $sp, -4
	sw %i, 0($sp)
	
	sll %i, %i, 2 # i * 4
	add %array, %array, %i # array++
	
	lw %i, 0($sp)
	addi $sp, $sp, 4
.end_macro

.macro init_var (%var)
	addi %var, $zero, 0 # var = 0
.end_macro

.data
	matrix_A: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100
	matrix_B: 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
	matrix_C: .space 400 # 100 INTs
	
.text
	j main
	
tamanho_Matriz:
	print_str ("\n Digite um número maior que 1 e menor ou igual a 10 para ser o tamalho da linha e coluna da matriz!\n Número:")
	
loop_Tamanho_Matriz:
	scan_int ()
	
	ble $v0, 1, aviso_Tamanho_Matriz # if n <= 1 mensagem de número inválido
	bgt $v0, 10, aviso_Tamanho_Matriz # if n > 10 mensagem de número inválido
	
	jr $ra # volta pro main
	
aviso_Tamanho_Matriz:
	print_str ("\n Valor inválido! O número deve ser n > 1 e n <= 10\n Número:") 

	j loop_Tamanho_Matriz # volta pro loop
	
tipo_soma:
	addi $sp, $sp, -64
	sw $ra, 60($sp)
	sw $s4, 56($sp)
	sw $s3, 52($sp)
	sw $s2, 48($sp)
	sw $s1, 44($sp)
	sw $s0, 40($sp)
	sw $t9, 36($sp)
	sw $t8, 32($sp)
	sw $t7, 28($sp)
	sw $t6, 24($sp)
	sw $t5, 20($sp)
	sw $t4, 16($sp)
	sw $t3, 12($sp)
	sw $t2, 8($sp)
	sw $t1, 4($sp)
	sw $t0, 0($sp)
	
	la $s0, matrix_C
	la $s1, matrix_A
	la $s2, matrix_B
	init_var ($t0)
	init_var ($t1)
	init_var ($t2)
	init_var ($t3)
	init_var ($t4)
	init_var ($t5)
	init_var ($t6)
	init_var ($t7)
	init_var ($t8)
	init_var ($t9)
	
	add $s3, $zero, $a0 # i e j size
	add $s4, $zero, $a1 # matriz size
	
	print_str ("\n Digite ‘0’ para linha-coluna e ‘1’ para coluna-linha!\n Número:")
	
loop_tipo_soma:
	scan_int ()
	
	add $t8, $zero, $v0
	
	beq $v0, 0, linha_Coluna # if n == 0
	beq $v0, 1, coluna_Linha # if n == 1
	
	print_str ("\n Valor inválido!\n O número deve ser 0 ou 1\n Número:")
	
	j loop_tipo_soma
	
linha_Coluna:
	init_var ($t2)
	
	addi $sp, $sp, -12
	sw $s2, 8($sp) # matrizB
	sw $s1, 4($sp) # matrizA
	sw $s0, 0($sp) # matrizC 
	
	increment_array ($s0, $t1) # linha++ 
	increment_array ($s1, $t1)
	increment_array ($s2, $t1)
	
	var_plus_plus ($t1)
	
loop_linha_Coluna:
	save_x_array ($s0, $s1, $s2, $t3, $t4, $t5)  # salva no array c, array a[i] + array b[i]
	
	increment_array ($s0, $s3) # coluna++
	increment_array ($s1, $s3)
	increment_array ($s2, $s3)
	
	var_plus_plus ($t0) # i++
	var_plus_plus ($t2) # k++
	
	bge $t2, $s3, reiniciar_Pilha # if k == lado_size
	
	blt $t0, $a1, loop_linha_Coluna # if i < matrix _seze loop
	
	j reiniciar_Pilha # vai para saida (arrumar a pilha)
	
reiniciar_Pilha:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	
	bge $t0, $a1, exit_Soma # if i == matrix size exit
	
	j linha_Coluna

coluna_Linha:
	save_x_array ($s0, $s1, $s2, $t2, $t3, $t4)  # salva no array c, array a[i] + array b[i]
	
	addi $t2, $zero, 1 # vai ser multiplicado por 4
	
	increment_array ($s0, $t2) # desloca o endereço base do array para próxima "linha"
	increment_array ($s1, $t2)
	increment_array ($s2, $t2) 
	
	var_plus_plus ($t0) # i++
	
	blt $t0, $s4, coluna_Linha # if i < matrix_size loop
	
	j exit_Soma # vai para saida (arrumar a pilha)
	
exit_Soma:
	add $v0, $zero, $t8
	
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)
	lw $t4, 16($sp)
	lw $t5, 20($sp)
	lw $t6, 24($sp)
	lw $t7, 28($sp)
	lw $t8, 32($sp)
	lw $t9, 36($sp)
	lw $s0, 40($sp)
	lw $s1, 44($sp)
	lw $s2, 48($sp)
	lw $s3, 52($sp)
	lw $s4, 56($sp)
	lw $ra, 60($sp)
	addi $sp, $sp, 64
	
	jr $ra # volta para o main
	
imprimir:
	addi $sp, $sp, -28 
	sw $ra, 24($sp)
	sw $t4, 20($sp)
	sw $t3, 16($sp)
	sw $t2, 8($sp)
	sw $t1, 4($sp)
	sw $t0, 0($sp)
	
	beq $v0, 0, Imprimir_Linha_Coluna
	beq $v0, 1, Imprimir_Coluna_Linha

Imprimir_Linha_Coluna:
	init_var ($t2) # seta k = 0
	
	addi $sp, $sp, -4
	sw $a3, 0($sp) # base adress matriz C 
	
	increment_array ($a3, $t1) # coluna++
	
	var_plus_plus ($t1) # j++
	
loop_Imprimir_linha_Coluna:
	print_int_array ($a3) # printa posição
	
	print_str (" ")
	
	increment_array ($a3, $a1) # linha++
	
	var_plus_plus ($t0) # i++
	var_plus_plus ($t2) # j++
	
	bge $t2, $a1, reiniciar_Pilha_Imprimir # if k == lado_size
	
	blt $t0, $a2, loop_Imprimir_linha_Coluna # if i < matrix _size loop
	
	j reiniciar_Pilha_Imprimir # vai para saida (arrumar a pilha)
	
reiniciar_Pilha_Imprimir:
	lw $a3, 0($sp) # base adress matriz C 
	addi $sp, $sp, 4 
	
	print_str ("\n")
	
	bge $t0, $a2, saida_Imprimir # if i >= matrix size exit
	
	j Imprimir_Linha_Coluna
	
Imprimir_Coluna_Linha:
	init_var ($t1) # j = 0
	
	print_str ("\n")
	
	bge $t0, $a2, saida_Imprimir
	
loop_Imprimir_Coluna_Linha:
	print_str (" ")
	
	print_array ($a3, $t0) # print matriz[i]
	
	var_plus_plus ($t0) # i++
	var_plus_plus ($t1) # j++
	
	bge $t1, $a1, Imprimir_Coluna_Linha
	
	blt $t0, $a2, loop_Imprimir_Coluna_Linha
	
	j saida_Imprimir
	
saida_Imprimir:

	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $ra, 24($sp)
	addi $sp, $sp, 28
	
	jr $ra

main:
	addi $sp, $sp, -36
	sw $ra, 32($sp)
	sw $v0, 28($sp)
	sw $v0, 24($sp)
	sw $t0, 20($sp)
	sw $s1, 16($sp)
	sw $s0, 12($sp)
	sw $a3, 8($sp)
	sw $a1, 4($sp)
	sw $a0, 0($sp)
	
	jal tamanho_Matriz
	
	add $s0, $zero, $v0 # tamanho do lado
	mul $s1, $v0, $v0 # tamanho da matriz
	
	add $a0, $zero, $s0 # tamanho do lado
	add $a1, $zero, $s1 # tamanho da matriz
	
	jal tipo_soma
	
	add $a1, $zero, $s0
	add $a2, $zero, $s1
	
	la $a3, matrix_C
	
	jal imprimir
	
	j exit
	
exit:
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a3, 12($sp)
	lw $s0, 16($sp)
	lw $s1, 20($sp)
	lw $t0, 24($sp)
	lw $v0, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
	
	nop
