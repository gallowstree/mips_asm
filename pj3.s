.data
	##############PROGRAMA A CODIFICAR################
	programa: .asciiz "addi $t0 $t0 0\nbgtz $t0 mierda\naddi $a0 $0 200\nori $v0 $0 1\nsyscall\nmierda:\naddi $a0 $0 100\nori $v0 $0 1\nsyscall\nori $v0 $0 10\nsyscall"
	##################################################

.align 2
	data: .space 200 #data del programa
	text: .space 700 #espacio para programa compilado

.text
	main:
		la	$a0 programa
		la	$a1 text
		la	$a2 data
		jal	ensamblador	
		
		#la $a0 program_buffer
		#li $v0 4
        	#syscall
		
		#la $a0 palabra
		#jal get_addr_from_st
		#add $a0 $v0 $0
		#li $v0 1
		#syscall
		
		#la $t0 symbol_table
		#lw $a0 0($t0)
		#li $v0 1
		#syscall
		#la $t0 text_counter
		#lw $a0 0($t0)
		#li $v0 1
		#syscall
		
		jr	$v0
		
		j	exit


	exit:
		li	$v0 10
		syscall

	#funcion ensamblador	
	ensamblador:
	.data	#instrucciones
		str_asciiz:	.asciiz	".asciiz"
		str_data:		.asciiz	".data"
		str_text:		.asciiz	".text"
		str_abs:		.asciiz	"abs"
		str_add:		.asciiz	"add"
		str_addi:		.asciiz	"addi"
		str_addiu:	.asciiz	"addiu"
		str_addu:		.asciiz	"addu"
		str_and:		.asciiz	"and"
		str_andi:		.asciiz	"andi"
		str_beq:		.asciiz	"beq"
		str_bgt:		.asciiz	"bgt"
		str_bgtz:		.asciiz	"bgtz"
		str_blt:		.asciiz	"blt"
		str_bne:		.asciiz	"bne"
		str_div:		.asciiz	"div"
		str_divu:		.asciiz	"divu"
		str_j:		.asciiz	"j"
		str_jal:		.asciiz	"jal"
		str_jr:		.asciiz	"jr"
		str_la:		.asciiz	"la"
		str_li:		.asciiz	"li"
		str_lui:		.asciiz	"lui"
		str_lw:		.asciiz	"lw"
		str_mfhi:		.asciiz	"mfhi"
		str_mflo:		.asciiz	"mflo"
		str_move:		.asciiz	"move"
		str_mul:		.asciiz	"mul"
		str_mult:		.asciiz	"mult"
		str_multu:	.asciiz	"multu"
		str_neg:		.asciiz	"neg"
		str_or:		.asciiz	"or"
		str_ori:		.asciiz	"ori"
		str_rol:		.asciiz	"rol"
		str_ror:		.asciiz	"ror"
		str_seq:		.asciiz	"seq"
		str_sll:		.asciiz	"sll"
		str_sllv:		.asciiz	"sllv"
		str_slt:		.asciiz	"slt"
		str_slti:		.asciiz	"slti"
		str_sltiu:	.asciiz	"sltiu"
		str_sltu:		.asciiz	"sltu"
		str_sne:		.asciiz	"sne"
		str_srl:		.asciiz	"srl"
		str_srlv:		.asciiz	"srlv"
		str_sub:		.asciiz	"sub"
		str_subu:		.asciiz	"subu"
		str_sw:		.asciiz	"sw"
		str_syscall:	.asciiz	"syscall"
	#flags and variables
		program_buffer: .space 1000
		reg1:		 .space 30
		reg2:		 .space 30
		value:		 .space 30
		aux_string:	 .space 30
		asm_flag:		 .word 3
		text_counter: 	 .word 39996
		data_counter:   .word -1
		row:			 .word 0
		text_addr:		  .word 0
	#códigos de error:
		err_unknown:	.asciiz "error desconocido \n"
		err_0:		.asciiz "instrucción inválida \n"
		
	#espacios para tabla de simbolos con capacidad de 50 simbolos
		symbol_table:	.word -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
		
	.text	
		#backup a la memoria
		addi	$sp $sp -48
		sw	$a2 44($sp)
		sw	$a1 40($sp)
		sw  	$a0 36($sp)
		sw	$ra 32($sp)
		sw	$s7 28($sp)
		sw	$s6 24($sp)
		sw	$s5 20($sp)
		sw	$s4 16($sp)
		sw	$s3 12($sp)
		sw	$s2 8($sp)
		sw	$s1 4($sp)
		sw	$s0 0($sp)

		#movemos los argumentos a un lugar seguro
		move $s0 $a0
		sw $a1 text_addr
		move $s1 $a2  #copiamos la direccion de .data del programa
		move $s3 $sp
		li $s6 0
		la $s7 program_buffer

	###################### REEMPLAZAMOS INSTRUCCIONES MAL POR TAL #######################################
	asm_pseudo_loop:
		li	$s4 ' '
		li 	$s5 '\n'
		lb	$t0 0($s0)			#primer caracter
		sb   $t0 0($s7)
		addi	$s0 $s0 1				#direccion del caracter siguiente
		addi $s7 $s7 1
		beq	$t0 $0  asm_pseudo_loop_exit		#fin del codigo?
		beq 	$t0 $s4 asm_pseudo_loop	#espacio en blanco
		beq 	$t0 $s5 asm_pseudo_loop	#newline
		beq	$t0 'a' asm_get_pseudo_a		#obtener instrucciones que empiezan con a
		beq  $t0 'b' asm_get_pseudo_b
		beq  $t0 'd' asm_get_pseudo_d
		beq 	$t0 'l' asm_get_pseudo_l
		beq	$t0 'm' asm_get_pseudo_m
		beq	$t0 'n' asm_get_pseudo_n
		beq	$t0 'r' asm_get_pseudo_r
		beq	$t0 's' asm_get_pseudo_s
		beq  $t0 '.' asm_get_segment
		beq  $t0 '#' asm_remove_text_comment
		addi	$s0 $s0 -1 
		addi $s7 $s7 -1
		j asm_check_label
		
	asm_pseudo_data_loop:
		li	$s4 ' '
		li 	$s5 '\n'
		lb	$t0 0($s0)			#primer caracter
		sb   $t0 0($s7)
		addi	$s0 $s0 1				#direccion del caracter siguiente
		addi $s7 $s7 1
		beq	$t0 $0  asm_pseudo_loop_exit		#fin del codigo?
		beq 	$t0 $s4 asm_pseudo_data_loop	#espacio en blanco
		beq 	$t0 $s5 asm_pseudo_data_loop	#newline
		beq  $t0 '.' asm_get_data_segment
		beq  $t0 '#' asm_remove_data_comment
		addi	$s0 $s0 -1 
		addi $s7 $s7 -1
		j asm_check_data_label
	
	asm_remove_text_comment:
		addi	$s0 $s0 -1 
		addi $s7 $s7 -1
		
	asm_remove_text_comment_loop:
		lb $t0 0($s0)
		addi $s0 $s0 1
		bne $t0 '\n' asm_remove_text_comment_loop
		addi $s0 $s0 -1
		j asm_pseudo_loop
		
	asm_remove_data_comment:
		addi	$s0 $s0 -1 
		addi $s7 $s7 -1
		
	asm_remove_data_comment_loop:
		lb $t0 0($s0)
		addi $s0 $s0 1
		bne $t0 '\n' asm_remove_data_comment_loop
		addi $s0 $s0 -1
		j asm_pseudo_data_loop
		
	asm_get_segment:
		addi	$s0 $s0 -1 
		addi $s7 $s7 -1
		
		move $a0 $s0			# verifico si es la directiva .data
		la $a1 str_data
		jal strcmp
		bne $v0 $0 asm_pseudo_data
	
		move $a0 $s0			# verifico si es la directiva .text
		la $a1 str_text
		jal strcmp
		bne $v0 $0 asm_pseudo_text
		
		j asm_check_label
	
	asm_get_data_segment:
		addi	$s0 $s0 -1 
		addi $s7 $s7 -1
		
		move $a0 $s0			# verifico si es la directiva .data
		la $a1 str_asciiz
		jal strcmp
		bne $v0 $0 asm_asciiz
		
		move $a0 $s0			# verifico si es la directiva .data
		la $a1 str_data
		jal strcmp
		bne $v0 $0 asm_pseudo_data
	
		move $a0 $s0			# verifico si es la directiva .text
		la $a1 str_text
		jal strcmp
		bne $v0 $0 asm_pseudo_text
		
		j asm_check_data_label
	
	asm_get_pseudo_a:
		addi	$s0 $s0 -1 
		addi $s7 $s7 -1
		
		move	$a0 $s0		#verificamos si la instruccion es abs
		la 	$a1 str_abs
		jal 	strcmp
		bne 	$v0 $0 asm_pseudo_abs
		
		j asm_check_label
	
	asm_get_pseudo_b:
		addi	$s0 $s0 -1 
		addi $s7 $s7 -1
		
		move	$a0 $s0
		la	$a1 str_bgt
		jal	strcmp
		bnez $v0 asm_pseudo_bgt

		move	$a0 $s0
		la	$a1 str_blt
		jal	strcmp
		bnez $v0 asm_pseudo_blt

		j asm_check_label
	
	asm_get_pseudo_d:
		addi	$s0 $s0 -1 
		addi $s7 $s7 -1
		
		move	$a0 $s0
		la	$a1 str_div
		jal	strcmp
		bnez $v0 asm_pseudo_div

		j asm_check_label
		
	asm_get_pseudo_l:
		addi	$s0 $s0 -1 
		addi $s7 $s7 -1

		move	$a0 $s0
		la	$a1 str_li
		jal	strcmp
		bnez $v0 asm_pseudo_li

		move	$a0 $s0
		la	$a1 str_la
		jal	strcmp
		bnez $v0 asm_pseudo_la
		
		j asm_check_label
	
	asm_get_pseudo_m:
		addi	$s0 $s0 -1 
		addi $s7 $s7 -1
		
		move	$a0 $s0
		la	$a1 str_move
		jal	strcmp
		bnez $v0 asm_pseudo_move

		move	$a0 $s0
		la	$a1 str_mul
		jal	strcmp
		bnez $v0 asm_pseudo_mul
		
		j asm_check_label
		
	asm_get_pseudo_n:
		addi	$s0 $s0 -1 
		addi $s7 $s7 -1
		
		move	$a0 $s0	
		la	$a1 str_neg
		jal	strcmp
		bnez	$v0 asm_pseudo_neg
				
		j asm_check_label
		
	asm_get_pseudo_r:
		addi	$s0 $s0 -1 
		addi $s7 $s7 -1
		
		move	$a0 $s0	
		la	$a1 str_rol
		jal	strcmp
		bnez $v0 asm_pseudo_rol

		move	$a0 $s0	
		la	$a1 str_ror
		jal	strcmp
		bnez $v0 asm_pseudo_ror
				
		j asm_check_label
	
	asm_get_pseudo_s:
		addi	$s0 $s0 -1 
		addi $s7 $s7 -1

		move	$a0 $s0	
		la	$a1 str_seq
		jal	strcmp
		bnez	$v0 asm_pseudo_seq
		
		move	$a0 $s0	
		la	$a1 str_sne
		jal	strcmp
		bnez	$v0 asm_pseudo_sne
		j asm_check_label
	
	asm_asciiz:
		li $t0 '\''
		li $t1 '"'
		addi $s0 $s0 2 #nos corremos 2 para eliminar el espacio y la comilla
	
	asm_asciiz_loop:
		lb $t3 0($s0)
		beq $t3 $t0 end_asciiz_loop
		beq $t3 $t1 end_asciiz_loop
		sb $t3 0($s1)
		addi $s0 $s0 1 #avanzamos 1 en el puntero
		addi $s1 $s1 1 #avanzamos 1 en el puntero
		lw $t4 data_counter #cargamos e incrementamos el contador en 1
		addi $t4 $t4 1
		sw $t4 data_counter
		j asm_asciiz_loop
	
	end_asciiz_loop:
		addi $s0 $s0 1
		sb $0 0($s1)
		addi $s1 $s1 1
		j asm_pseudo_data_loop
		
	
	asm_pseudo_abs:
		jal extract_regs_and_value
		li $t0 's'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'r'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg2
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '3'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '1'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '\n'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'x'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'o'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'r'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg2
		li $t0 '\n'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 's'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'u'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'b'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'u'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		
		#incrementamos el contador de las direcciones 
		la $t0 text_counter
		lw $t1 0($t0)
		addi $t1 $t1 12
		sw $t1 0($t0)
		j asm_pseudo_loop
		
		
	asm_pseudo_bgt:
		jal extract_regs_and_value
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'd'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'd'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'i'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '0'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg2
		li $t0 '\n'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 's'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'l'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 '\n'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'b'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'n'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'e'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '0'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_value
		
		
		#incrementamos el contador de las direcciones 
		la $t0 text_counter
		lw $t1 0($t0)
		addi $t1 $t1 12
		sw $t1 0($t0)
		j asm_pseudo_loop
		
	
	asm_pseudo_blt:
		jal extract_regs_and_value
		li $t0 's'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'l'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'i'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg2
		li $t0 '\n'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'b'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'n'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'e'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '0'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_value
		
		#incrementamos el contador de las direcciones 
		la $t0 text_counter
		lw $t1 0($t0)
		addi $t1 $t1 8
		sw $t1 0($t0)
		j asm_pseudo_loop
		
	asm_pseudo_div:
		jal extract_regs_and_value
		la $t0 value
		lb $t1 0($t0)
		
		beqz $t1 asm_div_tal 			#si solo tiene 2 registros es tal
		bne $t1 '$' asm_pseudo_div_im		#si no empieza con $ el tercer registro es inmediato
		
		li $t0 'd'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'i'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'v'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg2
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_value
		li $t0 '\n'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'm'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'f'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'l'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'o'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		
		#incrementamos el contador de las direcciones 
		la $t0 text_counter
		lw $t1 0($t0)
		addi $t1 $t1 8
		sw $t1 0($t0)
		j asm_pseudo_loop
		
	asm_pseudo_div_im:
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'd'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'd'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'i'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '0'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_value
		li $t0 '\n'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'd'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'i'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'v'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg2
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '\n'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'm'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'f'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'l'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'o'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		
		#incrementamos el contador de las direcciones 
		la $t0 text_counter
		lw $t1 0($t0)
		addi $t1 $t1 12
		sw $t1 0($t0)
		j asm_pseudo_loop
		
	asm_div_tal:
		li $t0 'd'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'i'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'v'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg2
		#incrementamos el contador de las direcciones 
		la $t0 text_counter
		lw $t1 0($t0)
		addi $t1 $t1 4
		sw $t1 0($t0)
		j asm_pseudo_loop
		
	asm_pseudo_li:
		jal extract_regs_and_value
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'd'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'd'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'i'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'u'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '0'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg2
		
		#incrementamos el contador de las direcciones 
		la $t0 text_counter
		lw $t1 0($t0)
		addi $t1 $t1 4
		sw $t1 0($t0)
		j asm_pseudo_loop
		
	asm_pseudo_la:
		jal extract_regs_and_value
		lb $t0 reg2
		beq $t0 '(' la_using_parenthesis
		la $a0 reg2
		li $a1 '('
		jal string_contains_char
		bnez  $v0 la_using_parenthesis_offset
		la $a0 reg2
		jal string_is_number
		beqz $v0 la_using_label
		#numero
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'd'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'd'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'i'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'u'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '0'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg2
		
		#incrementamos el contador de las direcciones 
		la $t0 text_counter
		lw $t1 0($t0)
		addi $t1 $t1 12
		sw $t1 0($t0)
		j asm_pseudo_loop
		
	la_using_parenthesis:
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'd'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'd'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'i'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		lb  $t0 reg2+1
		sb  $t0 0($s7)
		addi $s7 $s7 1
		lb  $t0 reg2+2
		sb  $t0 0($s7)
		addi $s7 $s7 1
		lb  $t0 reg2+3
		sb  $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '0'
		sb $t0 0($s7)
		addi $s7 $s7 1
		
		#incrementamos el contador de las direcciones 
		la $t0 text_counter
		lw $t1 0($t0)
		addi $t1 $t1 4
		sw $t1 0($t0)
		j asm_pseudo_loop
		
	la_using_parenthesis_offset:
		li $t0 'o'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'r'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'i'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '0'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		la $a0 reg2
		jal ascii_to_int_generic
		move $a0 $v0
		jal int_to_ascii
		li $t0 '\n'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'd'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'd'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_extract_reg2
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		
		#incrementamos el contador de las direcciones 
		la $t0 text_counter
		lw $t1 0($t0)
		addi $t1 $t1 8
		sw $t1 0($t0)
		j asm_pseudo_loop
		
	la_using_label:
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'd'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'd'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'i'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'u'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '0'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		j asm_pseudo_loop
		
	asm_pseudo_move:
		jal extract_regs_and_value
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'd'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'd'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'u'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '0'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg2
		
		
		#incrementamos el contador de las direcciones 
		la $t0 text_counter
		lw $t1 0($t0)
		addi $t1 $t1 4
		sw $t1 0($t0)
		j asm_pseudo_loop
		
	asm_pseudo_mul:
		jal extract_regs_and_value
		li $t0 'm'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'u'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'l'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg2
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_value
		li $t0 '\n'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'm'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'f'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'l'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'o'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		
		#incrementamos el contador de las direcciones 
		la $t0 text_counter
		lw $t1 0($t0)
		addi $t1 $t1 12
		sw $t1 0($t0)
		j asm_pseudo_loop
		
	asm_pseudo_neg:
		jal extract_regs_and_value
		li $t0 's'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'u'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'b'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '0'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg2
		
		#incrementamos el contador de las direcciones 
		la $t0 text_counter
		lw $t1 0($t0)
		addi $t1 $t1 4
		sw $t1 0($t0)
		j asm_pseudo_loop
		
	asm_pseudo_seq:
		jal extract_regs_and_value
		lb $t0 value
		beq $t0 '$' seq_using_register
	seq_using_immed:
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'd'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'd'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'i'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '1'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '0'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_value
		li $t0 '\n'
		sb $t0 0($s7)
		addi $s7 $s7 1
		
		#incrementamos el contador de las direcciones 
		la $t0 text_counter
		lw $t1 0($t0)
		addi $t1 $t1 4
		sw $t1 0($t0)
		
	seq_using_register:	
		li $t0 's'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'u'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'b'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'u'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg2
		lb $t0 value
		beq $t0 '$' seq_common_reg
	seq_common_immed:
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '1'
		sb $t0 0($s7)
		addi $s7 $s7 1
		j seq_common
	seq_common_reg:
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_value
	seq_common:
		li $t0 '\n'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'o'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'r'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'i'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '1'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '0'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '1'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '\n'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 's'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'l'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'u'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		
		#incrementamos el contador de las direcciones 
		la $t0 text_counter
		lw $t1 0($t0)
		addi $t1 $t1 12
		sw $t1 0($t0)
		j asm_pseudo_loop
		
	asm_pseudo_sne:
		jal extract_regs_and_value
		lb $t0 value
		beq $t0 '$' sne_using_register
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'd'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'd'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'i'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '0'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_value
		li $t0 '\n'
		sb $t0 0($s7)
		addi $s7 $s7 1
		
		#incrementamos el contador de las direcciones 
		la $t0 text_counter
		lw $t1 0($t0)
		addi $t1 $t1 4
		sw $t1 0($t0)

	sne_using_register:
		li $t0 's'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'u'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'b'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'u'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg2
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		lb $t0 value
		beq $t0 '$' sne_common_using_register
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		j sne_common
	sne_common_using_register:
		jal copy_value
		j sne_common
	sne_common:
		li $t0 '\n'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 's'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'l'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'u'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '0'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		
		#incrementamos el contador de las direcciones 
		la $t0 text_counter
		lw $t1 0($t0)
		addi $t1 $t1 8
		sw $t1 0($t0)
		j asm_pseudo_loop
		
	asm_pseudo_rol:
		jal extract_regs_and_value
		la $t0 value
		lb $t1 0($t0)
		
		bne $t1 '$' asm_pseudo_rol_im
		#si value empieza con $ quiere decir que tiene 3 registros 
		li $t0 's'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'u'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'b'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'u'
		sb $t0 0($s7)
		addi $s7 $s7 1		
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '0'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_value
		li $t0 '\n'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 's'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'r'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'l'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'v'
		sb $t0 0($s7)
		addi $s7 $s7 1		
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg2
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '\n'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 's'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'l'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'l'
		sb $t0 0($s7)
		addi $s7 $s7 1		
		li $t0 'v'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg2
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_value
		li $t0 '\n'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'o'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'r'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		
		#incrementamos el contador de las direcciones 
		la $t0 text_counter
		lw $t1 0($t0)
		addi $t1 $t1 16
		sw $t1 0($t0)
		j asm_pseudo_loop
		
	asm_pseudo_rol_im:
		la $a0 value
		jal ascii_to_int_generic
		add $t1 $0 $v0  #obtenemos el decimal del string
		li $t2 32
		sub $t3 $t2 $t1
		
		#copiamos las instrucciones
		li $t0 's'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'r'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'l'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg2
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		
		add $a0 $0 $t3		
		jal int_to_ascii
		li $t0 '\n'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 's'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'l'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'l'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg2
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_value
		li $t0 '\n'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'o'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'r'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		
		#incrementamos el contador de las direcciones 
		la $t0 text_counter
		lw $t1 0($t0)
		addi $t1 $t1 12
		sw $t1 0($t0)
		j asm_pseudo_loop
		
	asm_pseudo_ror:
		jal extract_regs_and_value
		la $t0 value
		lb $t1 0($t0)
		
		bne $t1 '$' asm_pseudo_ror_im
		#si value empieza con $ quiere decir que tiene 3 registros 
		li $t0 's'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'u'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'b'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'u'
		sb $t0 0($s7)
		addi $s7 $s7 1		
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '0'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_value
		li $t0 '\n'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 's'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'l'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'l'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'v'
		sb $t0 0($s7)
		addi $s7 $s7 1		
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg2
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '\n'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 's'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'r'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'l'
		sb $t0 0($s7)
		addi $s7 $s7 1		
		li $t0 'v'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg2
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_value
		li $t0 '\n'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'o'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'r'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		
		#incrementamos el contador de las direcciones 
		la $t0 text_counter
		lw $t1 0($t0)
		addi $t1 $t1 16
		sw $t1 0($t0)
		j asm_pseudo_loop
		
	asm_pseudo_ror_im:
		la $a0 value
		jal ascii_to_int_generic
		add $t1 $0 $v0  #obtenemos el decimal del string
		li $t2 32
		sub $t3 $t2 $t1
		
		#copiamos las instrucciones
		li $t0 's'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'l'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'l'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg2
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		
		add $a0 $0 $t3		
		jal int_to_ascii
		li $t0 '\n'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 's'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'r'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'l'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg2
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_value
		li $t0 '\n'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'o'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'r'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		jal copy_reg1
		li $t0 ' '
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 '$'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 'a'
		sb $t0 0($s7)
		addi $s7 $s7 1
		li $t0 't'
		sb $t0 0($s7)
		addi $s7 $s7 1
		
		#incrementamos el contador de las direcciones 
		la $t0 text_counter
		lw $t1 0($t0)
		addi $t1 $t1 12
		sw $t1 0($t0)
		j asm_pseudo_loop
		
	asm_pseudo_text:
		#addi $s0 $s0 -5
		j asm_iterate_and_copy_line
	
	asm_pseudo_data:
		#addi $s0 $s0 -5
		j asm_iterate_and_copy_data_line
	
	asm_check_label:
		move $a0 $s0			# verifico si es un label
		jal 	asm_label_check
		bne 	$v0 $0 asm_label
		
		#incrementamos el contador de las direcciones 
		la $t0 text_counter
		lw $t1 0($t0)
		addi $t1 $t1 4
		sw $t1 0($t0)
		j asm_iterate_and_copy_line
		
	asm_check_data_label:
		move $a0 $s0			# verifico si es un label
		jal 	asm_label_check
		bne 	$v0 $0 asm_data_label

		j asm_increment_data_counter
	
	########### copiamos label de text a tabla de simbolos #######################
	asm_label:
		li $s4 ':'
		li $s5 '\n'
		la $t0 text_counter #cargamos el contador de direcciones
		lw $t1 0($t0) 
		la $t6 row
		addi $t1 $t1 4 #le sumamos 4 al contador de direcciones de text
		lw $t2 0($t6)
		addi $sp $sp -1 
		addi $s6 $s6 1
		
		#direcciones de la matriz
		la $t3 symbol_table
		mul $t4 $t2 2 #multiplicamos cantidad de columnas por la fila actual
		add $t4 $t4 $0 #sumamos la columna de la cual queremos saber la direccion, en este caso es la columna 0
		mul $t4 $t4 4 #multiplicamos el size
		add $t4 $t3 $t4
		sw $t1 0($t4) #guardamos el contador actual
		addi $t4 $t4 4 #nos movemos a la siguiente celda
		la $t5 0($sp)
		sw $t5 0($t4) #guardamos la direccion actual del puntero
	
		addi $t2 $t2 1 #le sumamos 1 a las filas
		sw $t2 0($t6) #guardamos la fila actual
		
	asm_pseudo_label_loop:
		lb $t0 0($s0)			# se utiliza para llenar la tabla de simbolos
		sb $t0 0($sp)
		addi $s0 $s0 1
		addi $sp $sp -1
		addi $s6 $s6 1
		bne $t0 $s4 asm_pseudo_label_loop		
		addi $sp $sp 1 #eliminamos los :
		addi  $s6 $s6 -1
		sb $0 0($sp)
		
		
	asm_align_text_sp: #chapuz para alinear la $sp
		li $t1 4
		div $sp $t1  
		mfhi $t0
		beqz $t0 asm_label_nl_loop
		addi $sp $sp -1
		addi $s6 $s6 1 
		sb $0 0($sp)
		j asm_align_text_sp
	
	asm_label_nl_loop: #recorremos hasta encontrar un \n
		lb $t0 0($s0)
		addi $s0 $s0 1
		beq $t0 $0 asm_pseudo_loop_exit
		bne $t0 $s5 asm_label_nl_loop
		j asm_pseudo_loop
		
	########### copiamos label de data a tabla de simbolos #######################
	asm_data_label:
		li $s4 ':'
		li $s5 '\n'
		la $t0 data_counter #cargamos el contador de direcciones
		lw $t1 0($t0) 
		la $t6 row
		lw $t2 0($t6)
		addi $t1 $t1 1 #le sumamos 4 al contador de direcciones de data
		addi $sp $sp -1 
		addi $s6 $s6 1
		
		#direcciones de la matriz
		la $t3 symbol_table
		mul $t4 $t2 2 #multiplicamos cantidad de columnas por la fila actual
		add $t4 $t4 $0 #sumamos la columna de la cual queremos saber la direccion, en este caso es la columna 0
		mul $t4 $t4 4 #multiplicamos el size
		add $t4 $t3 $t4
		sw $t1 0($t4) #guardamos el contador actual
		addi $t4 $t4 4 #nos movemos a la siguiente celda
		la $t5 0($sp)
		sw $t5 0($t4) #guardamos la direccion actual del puntero
		
		addi $t2 $t2 1 #le sumamos 1 a las filas
		sw $t2 0($t6) #guardamos la fila actual
	asm_pseudo_data_label_loop:
		lb $t0 0($s0)			# se utiliza para llenar la tabla de simbolos
		sb $t0 0($sp)
		addi $s0 $s0 1
		addi $sp $sp -1
		addi $s6 $s6 1
		bne $t0 $s4 asm_pseudo_data_label_loop		
		addi $sp $sp 1 #eliminamos los :
		addi  $s6 $s6 -1
		sb $0 0($sp)
		addi $s0 $s0 1 #eliminamos el espacio
		
	asm_align_data_sp: #chapuz para alinear la $sp
		li $t1 4
		div $sp $t1  
		mfhi $t0
		beqz $t0 asm_increment_data_counter
		addi $sp $sp -1
		addi $s6 $s6 1 
		sb $0 0($sp)
		j asm_align_data_sp	

	asm_iterate_and_copy_line:				
		li 	$s4 '#'						#recorremos toda la linea hasta encontrar un new line
		li 	$s5  '\n'
		lb	$t0 0($s0)					#primer caracter
		sb   $t0 0($s7)
		addi	$s0 $s0 1						#direccion del caracter siguiente
		addi $s7 $s7 1
		beq	$t0 $0  asm_pseudo_loop_exit		#fin del codigo?
		beq 	$t0 $s4 asm_remove_text_comment
		beq 	$t0 $s5 asm_pseudo_loop			#newline
		j asm_iterate_and_copy_line
	
	asm_increment_data_counter:
		#incrementamos el contador de las direcciones 
		la $t0 data_counter
		lw $t1 0($t0)
		addi $t1 $t1 1
		sw $t1 0($t0)
		j asm_pseudo_data_loop
	
	asm_iterate_and_copy_data_line:				
		li 	$s4 '#'						#recorremos toda la linea hasta encontrar un new line
		li 	$s5  '\n'
		lb	$t0 0($s0)					#primer caracter
		sb   $t0 0($s7)
		addi	$s0 $s0 1						#direccion del caracter siguiente
		addi $s7 $s7 1
		beq	$t0 $0  asm_pseudo_loop_exit		#fin del codigo?
		beq 	$t0 $s4 asm_remove_data_comment
		beq 	$t0 $s5 asm_pseudo_data_loop			#newline
		j asm_iterate_and_copy_data_line	
	
	asm_pseudo_loop_exit:
		sb $0 0($s7)
		la $s0 program_buffer
	
	########################## CODIFICAMOS INSTRUCCIONES ###############################################
	lw $s1 text_addr
	lw $t0 text_counter #reiniciamos el contador
	addi $t0 $0 39996
	sw $t0 text_counter
	
	asm_text_loop:
		li	$s4 ' '
		li 	$s5 '\n'
		lb	$t0 0($s0)			#primer caracter
		addi	$s0 $s0 1				#direccion del caracter siguiente
		beq	$t0 $0 asm_exit		#fin del codigo?
		beq 	$t0 $s4 asm_text_loop	#espacio en blanco
		beq 	$t0 $s5 asm_text_loop	#newline
		beq	$t0 'a' asm_get_a		#obtener instrucciones que empiezan con a
		beq	$t0 'b' asm_get_b		#obtener instrucciones que empiezan con b
		beq	$t0 'd' asm_get_d		#obtener instrucciones que empiezan con d
		beq	$t0 'j' asm_get_j		#obtener instrucciones que empiezan con j
		beq	$t0 'l' asm_get_l		#obtener instrucciones que empiezan con l
		beq	$t0 'm' asm_get_m		#obtener instrucciones que empiezan con m
		beq	$t0 'o' asm_get_o		#obtener instrucciones que empiezan con o
		beq	$t0 'r' asm_get_r		#obtener instrucciones que empiezan con r
		beq	$t0 's' asm_get_s		#obtener instrucciones que empiezan con s
		li	$a0 0
		j asm_error


	asm_get_a:
		addi	$s0 $s0 -1 	#regresamos a un espacio de memoria anterior para comparar las instrucciones  		

		move	$a0 $s0
		la	$a1 str_add
		jal	strcmp
		li 	$s7 0x20
		move	$a0 $0      	#no hay shamt
		bnez $v0 asm_r_type

		move	$a0 $s0
		la	$a1 str_addi
		jal	strcmp
		li 	$s7 0x08
		bnez $v0 asm_i_type

		move	$a0 $s0
		la	$a1 str_addiu
		jal	strcmp
		li 	$s7 0x09
		bnez $v0 asm_i_type

		move	$a0 $s0
		la	$a1 str_addu
		jal	strcmp
		li 	$s7 0x21
		bnez $v0 asm_r_type

		move	$a0 $s0
		la	$a1 str_and
		jal	strcmp
		li 	$s7 0x24
		bnez $v0 asm_r_type

		move	$a0 $s0
		la	$a1 str_andi
		jal	strcmp
		li 	$s7 0x0c
		bnez $v0 asm_i_type

		j 	asm_error

	asm_get_b:
		addi	$s0 $s0 -1 	#regresamos a un espacio de memoria anterior para comparar las instrucciones  		

		move	$a0 $s0		#verificamos si la instruccion es abs	
		la	$a1 str_beq
		jal	strcmp
		li 	$s7 0x04
		bnez $v0 asm_branch
		
		move	$a0 $s0
		la	$a1 str_bgtz
		jal	strcmp
		li 	$s7 0x07
		bnez $v0 asm_bgtz


		move	$a0 $s0
		la	$a1 str_bne
		jal	strcmp
		li 	$s7 0x05
		bnez $v0 asm_branch

		j 	asm_error

	asm_get_d:
		addi	$s0 $s0 -1 	#regresamos a un espacio de memoria anterior para comparar las instrucciones  		

		move	$a0 $s0		#verificamos si la instruccion es abs
		la	$a1 str_div
		jal	strcmp
		bnez $v0 asm_r_type

		move	$a0 $s0
		la	$a1 str_divu
		jal	strcmp
		li 	$s7 0x1b
		bnez $v0 asm_r_type

		j 	asm_error
	asm_get_j:
		addi	$s0 $s0 -1 	#regresamos a un espacio de memoria anterior para comparar las instrucciones  		

		move	$a0 $s0		#verificamos si la instruccion es abs
		la	$a1 str_j
		jal	strcmp
		li 	$s7 0x02
		bnez $v0 asm_j_type

		move	$a0 $s0
		la	$a1 str_jal
		jal	strcmp
		li 	$s7 0x03
		bnez $v0 asm_j_type

		move	$a0 $s0
		la	$a1 str_jr
		jal	strcmp
		li 	$s7 0x08
		bnez $v0 asm_jr

		j	asm_error
	asm_get_l:
		addi	$s0 $s0 -1 	#regresamos a un espacio de memoria anterior para comparar las instrucciones  		

		move	$a0 $s0
		la	$a1 str_lui
		jal	strcmp
		li 	$s7 0x0F
		bnez $v0 asm_i_type

		move	$a0 $s0
		la	$a1 str_lw
		jal	strcmp
		li 	$s7 0x23
		bnez $v0 asm_i_type

		j 	asm_error

	asm_get_m:
		addi	$s0 $s0 -1 	#regresamos a un espacio de memoria anterior para comparar las instrucciones  		

		move	$a0 $s0	
		la	$a1 str_mfhi
		jal	strcmp
		li 	$s7 0x10
		bnez $v0 asm_r_type

		move	$a0 $s0
		la	$a1 str_mflo
		jal	strcmp
		li 	$s7 0x12
		bnez $v0 asm_r_type

		move	$a0 $s0
		la	$a1 str_mult
		jal	strcmp
		li $s7 0x18
		bnez $v0 asm_r_type

		move	$a0 $s0
		la	$a1 str_multu
		jal	strcmp
		li 	$s7 0x18
		bnez $v0 asm_r_type
		
		li	$a0 0
		j asm_error

	asm_get_o:
		addi	$s0 $s0 -1 	#regresamos a un espacio de memoria anterior para comparar las instrucciones  		

		move	$a0 $s0	
		la	$a1 str_or
		jal	strcmp
		li 	$s7 0x25
		bnez $v0 asm_r_type

		move	$a0 $s0	
		la	$a1 str_ori
		jal	strcmp
		li 	$s7 0x0d
		bnez $v0 asm_i_type
		
		li	$a0 0
		j asm_error

	asm_get_r:
		addi	$s0 $s0 -1 	#regresamos a un espacio de memoria anterior para comparar las instrucciones  		
		
		li	$a0 0
		j asm_error

	asm_get_s:
		addi	$s0 $s0 -1 	#regresamos a un espacio de memoria anterior para comparar las instrucciones  		

		move	$a0 $s0	
		la	$a1 str_sll
		jal	strcmp
		li 	$s7 0x20
		li	$a0 1
		bnez $v0 asm_r_type

		move	$a0 $s0	
		la	$a1 str_sllv
		jal	strcmp
		li 	$s7 0x04
		bnez $v0 asm_r_type

		move	$a0 $s0	
		la	$a1 str_slt
		jal	strcmp
		li 	$s7 0x2a
		bnez $v0 asm_r_type

		move	$a0 $s0	
		la	$a1 str_slti
		jal	strcmp
		li 	$s7 0x0a
		bnez $v0 asm_i_type

		move	$a0 $s0	
		la	$a1 str_sltiu
		jal	strcmp
		li 	$s7 0x0b
		bnez $v0 asm_i_type

		move	$a0 $s0	
		la	$a1 str_sltu
		jal	strcmp
		li 	$s7 0x2b
		bnez $v0 asm_r_type

		move	$a0 $s0	
		la	$a1 str_srl
		jal	strcmp
		li 	$s7 0x02
		bnez $v0 asm_r_type

		move	$a0 $s0	
		la	$a1 str_srlv
		jal	strcmp
		li 	$s7 0x06
		bnez $v0 asm_r_type

		move	$a0 $s0	
		la	$a1 str_sub
		jal	strcmp
		li 	$s7 0x22
		bnez $v0 asm_r_type

		move	$a0 $s0	
		la	$a1 str_subu
		jal	strcmp
		li 	$s7 0x23
		bnez $v0 asm_r_type

		move	$a0 $s0	
		la	$a1 str_sw
		jal	strcmp
		li 	$s7 0x2b
		bnez $v0 asm_i_type

		move $a0 $s0			# verifico si es la instruccion syscall
		la 	$a1 str_syscall
		jal 	strcmp
		bne 	$v0 $0 asm_syscall
		
		li	$a0 0
		j asm_error

	asm_r_type:			#codifica instrucciones tipo r, 
			#aumentamos el contador
			lw $s4 text_counter
			addi $s4 $s4 4
			sw $s4 text_counter
		
			addi	$s0 $s0 1	#eliminar espacio
			jal 	asm_regs	#n?mero de registro rd
			add	$s4 $0 $v0	#ponemos rd en s4 con todo lo dem?s en 0
			sll	$s4 $s4 11	#corremos rd 11 bits (shamt + func)
			or	$s7 $s7 $s4	#apendar rd y funct

			lw	$s4 asm_flag	#bandera que indica si necesitamos tomar en cuenta corrimiento
			beqz	$s4 no_shamt

			addi	$s0 $s0 1	#eliminar espacio
			jal	asm_regs	#n?mero de registro rs
			add	$s4 $0 $v0	#ponemos rs en s4 con lo dem?s en 0
			sll	$s4 $s4 16	#corremos rs 21 bits (shamt + func + rt + rd)
			or	$s7 $s7 $s4	#apendar funct

			addi	$s0 $s0 1	#eliminar espacio
			jal	ascii_to_int	#obtenemos el shamt
			add	$s4 $0 $v0	#shamt en s4
			sll	$s4 $s4 6	#shift de 6 bits (funct)
			or	$s7 $s7 $s4	#apendar shamt
			j 	asm_r_done
		no_shamt:

			addi	$s0 $s0 1	#eliminar espacio
			jal	asm_regs	#n?mero de registro rs
			add	$s4 $0 $v0	#ponemos rs en s4 con lo dem?s en 0
			sll	$s4 $s4 21	#corremos rs 21 bits (shamt + func + rt + rd)
			or	$s7 $s7 $s4	#apendar funct

			addi	$s0 $s0 1	#eliminar espacio
			jal	asm_regs	#n?mero de registro rt
			add	$s4 $0 $v0	#ponemos rt en t2 con todo lo dem?s en 0
			sll	$s4 $s4 16	#corremos rt 16 bits (shamt + func + rd)
			or	$s7 $s7 $s4
		asm_r_done:
			sw 	$s7 0($s1)	# almaceno la instruccion codificada
			addi 	$s1 $s1 4
			li	$s5 0
			sw	$s5 asm_flag	#setear flag a 0
			j asm_text_loop

	asm_i_type:
			#incrementamos contador de direcciones
			lw $s4 text_counter
			addi $s4 $s4 4
			sw $s4 text_counter
			
			sll 	$s7 $s7 10	# shift porque son 5b de rt + 5b de rs
			addi $s0 $s0 1		# elimino el espacio
			jal 	asm_regs       # me devuelve el numero del registro
			add 	$s7 $s7 $v0	# almaceno el numero del registro en rs

			addi	$s0 $s0 1		# elimino el espacio
			jal 	asm_regs       # me devuelve el numero del registro
			sll 	$v0 $v0 5		# pongo rs en la posicion que debe ir (van cruzados)
			or  	$s7 $s7 $v0		# almaceno el numero del registro en rt
      
			sll 	$s7 $s7 16	# le hago shift de 16 para hacer espacio al imm
			addi $s0 $s0 1		# elimino el espacio
			jal 	ascii_to_int	# hago la conversion de ascii a int
			addu $s7 $s7 $v0 	# concateno el imm con el resto que ya tenia
			sw 	$s7 0($s1)	# almaceno la instruccion codificada
			addi $s1 $s1 4
			j asm_text_loop
			
		asm_branch:
			#incrementamos contador de direcciones
			lw $s4 text_counter
			addi $s4 $s4 4
			sw $s4 text_counter

			sll 	$s7 $s7 10	# shift porque son 5b de rt + 5b de rs
			addi $s0 $s0 1		# elimino el espacio
			jal 	asm_regs       # me devuelve el numero del registro
			add 	$s7 $s7 $v0	# almaceno el numero del registro en rs

			addi	$s0 $s0 1		# elimino el espacio
			jal 	asm_regs       # me devuelve el numero del registro
			sll 	$v0 $v0 5		# pongo rs en la posicion que debe ir (van cruzados)
			or  	$s7 $s7 $v0		# almaceno el numero del registro en rt
      
			sll 	$s7 $s7 16	# le hago shift de 16 para hacer espacio al imm
			addi $s0 $s0 1		# elimino el espacio
			add $a0 $s0 $0
			jal get_addr_from_st
			add $t1 $v0 $0
			li $t2 0
			sub $t2 $t1 $s4 #calculamos el offset y le restamos 1
			div $t2 $t2 4			
			sub $t2 $t2 1	

			addu $s7 $s7 $t2 	# concateno el imm con el resto que ya tenia
			sw 	$s7 0($s1)	# almaceno la instruccion codificada
			addi $s1 $s1 4
			j asm_text_loop
		
		asm_bgtz:
			#incrementamos contador de direcciones
			lw $s4 text_counter
			addi $s4 $s4 4
			sw $s4 text_counter

			sll 	$s7 $s7 10	# shift porque son 5b de rt + 5b de rs
			addi $s0 $s0 1		# elimino el espacio
			jal 	asm_regs       # me devuelve el numero del registro
			sll 	$v0 $v0 5		# pongo rs en la posicion que debe ir (van cruzados)
			or  	$s7 $s7 $v0		# almaceno el numero del registro en rt
      
			sll 	$s7 $s7 16	# le hago shift de 16 para hacer espacio al imm
			addi $s0 $s0 1		# elimino el espacio
			add $a0 $s0 $0
			jal get_addr_from_st
			add $t1 $v0 $0
			li $t2 0
			sub $t2 $t1 $s4 #calculamos el offset y le restamos 1
			div $t2 $t2 4			
			sub $t2 $t2 1	

			addu $s7 $s7 $t2 	# concateno el imm con el resto que ya tenia
			sw 	$s7 0($s1)	# almaceno la instruccion codificada
			addi $s1 $s1 4
			j asm_text_loop

			
		asm_jr:
			lw $s4 text_counter
			addi $s4 $s4 4
			sw $s4 text_counter

			addi $s0 $s0 1		# elimino el espacio
			jal 	asm_regs	#numero de registro rd
			add	$s4 $0 $v0	#ponemos rd en s4 con todo lo dem?s en 0
			sll $s4 $s4 20
			or $s7 $s7 $4
			sw 	$s7 0($s1)	# almaceno la instruccion codificada
			addi $s1 $s1 4
			j asm_text_loop

		asm_j_type:
			lw $s4 text_counter
			addi $s4 $s4 4
			sw $s4 text_counter

			sll $s7 $s7 25
			addi $s0 $s0 1		# elimino el espacio
			add $a0 $s0 $0
			jal get_addr_from_st
			sll $v0 $v0 6
			srl $v0 $v0 8		#movemos la direccion solo para obtener los 26 bits que necesitamos
			or $s7 $s7 $v0
			sw 	$s7 0($s1)	# almaceno la instruccion codificada
			addi $s1 $s1 4
			j asm_text_loop

	asm_error:
		addi	$s0 $s0 -1 		#regresamos a un espacio de memoria anterior para comparar las instrucciones  		
		li	$v0 4
		li	$t0 0
		beq	$a0 $t0 error_code_0    #TO DO: función para imprimir instrucción desconocida
		li	$t0 1
		j 	error_unknown  
		
					
	error_code_0:
		la	$a0 err_0
		syscall 
		j 	asm_exit
	error_unknown:
		la	$a0 err_unknown
		syscall 			
		
	asm_exit:					#resettear el backup
		add $sp $sp $s6
		lw   $a2 44($sp)
		lw	$a1 40($sp)
		lw	$a0 36($sp)
		lw	$ra 32($sp)
		lw	$s7 28($sp)
		lw	$s6 24($sp)
		lw	$s5 20($sp)
		lw	$s4 16($sp)
		lw	$s3 12($sp)
		lw	$s2 8($sp)
		lw	$s1 4($sp)
		lw	$s0 0($sp)
		addi	$sp $sp 44		#liberar memoria
		move $v0 $a1			#devolver buffer
		jr 	$ra


	############# extract_regs_and_value #############
	extract_regs_and_value:
		la $t1 reg1
		la $t2 reg2
		la $t3 value
		sb $0 0($t1)
		sb $0 0($t2)
		sb $0 0($t3)
		li $t4 ' '
		li $t5 '\n'
		li $t6 '#'
	
	extract_reg1_loop:
		addi	$s0 $s0 1
		lb 	$t0 0($s0)
		beq 	$t0 $t4 extract_reg2_loop
		beq	$t0 $t5 extract_regs_and_value_end
		beqz $t0 extract_regs_and_value_end
		sb 	$t0 0($t1)
		addi	$t1 $t1 1
		j extract_reg1_loop
		
	extract_reg2_loop:
		addi	$s0 $s0 1
		lb	$t0 0($s0)
		beq	$t0 $t4 extract_value_loop
		beq	$t0 $t5 extract_regs_and_value_end
		beq	$t0 $t6 extract_regs_and_value_end
		beqz $t0 extract_regs_and_value_end
		sb	$t0 0($t2)
		addi	$t2 $t2 1
		j extract_reg2_loop
		
	extract_value_loop:
		addi	$s0 $s0 1
		lb	$t0 0($s0)
		beq	$t0 $t4 extract_regs_and_value_end
		beq	$t0 $t5 extract_regs_and_value_end
		beq	$t0 $t6 extract_regs_and_value_end
		beqz $t0 extract_regs_and_value_end
		sb	$t0 0($t3)
		addi	$t3 $t3 1
		j extract_value_loop
	
	
	extract_regs_and_value_end:
		sb $0 0($t1)
		sb $0 0($t2)
		sb $0 0($t3)
		jr $ra
		
 	############# copy_reg1 ####################
 	copy_reg1:
 		la	$t0 reg1
 	
 	copy_reg1_loop:
 		lb 	$t1 0($t0)
 		beqz	$t1 copy_reg1_exit
 		sb	$t1 0($s7)
 		addi	$t0 $t0 1
 		addi $s7 $s7 1
 		j copy_reg1_loop
 			
 	copy_reg1_exit:
 		jr $ra
 	
 	############# copy_reg2 ####################
 	copy_reg2:
 		la	$t0 reg2
 	
 	copy_reg2_loop:
 		lb 	$t1 0($t0)
 		beqz	$t1 copy_reg2_exit
 		sb 	$t1 0($s7)
 		addi	$t0 $t0 1
 		addi	$s7 $s7 1
 		j copy_reg2_loop
 			
 	copy_reg2_exit:
 		jr $ra

 	############# copy_value ####################
 	copy_value:
 		la	$t0 value
 	
 	copy_value_loop:
 		lb 	$t1 0($t0)
 		beqz	$t1 copy_value_exit
 		sb 	$t1 0($s7)
 		addi	$t0 $t0 1
 		addi	$s7 $s7 1
 		j copy_value_loop
 			
 	copy_value_exit:
 		jr $ra
 	
     ############# asm_regs ####################

	asm_regs:					# pasa de $AN -> N ej. $s0 -> 16	
		addi $sp $sp -4		# por supuesto que esta incompleto...
		sw 	$ra 0($sp)
		li 	$t7 '$'			# voy a utilizarlo para verificar que viene un registro
		li	$t6 'a'			# aX -> argumentos
		li	$t5 'v'			# vX -> valores de retorno
		li 	$t4 't'             # tx -> valores temporales
		li 	$t3 's'             # sx -> valores seguros
		li   $t2 'r'             # ra
		li	$t1 '0'			# cero


		lb 	$t0 0($s0)
		addi	$s0 $s0 1
		bne 	$t0 $t7 asm_regs_error	# si no empieza con $ no es valido
		lb	$t0 0($s0)
		addi	$s0 $s0 1
		beq	$t0 $t6 asm_regs_ax		# verifico a que grupo pertence para sumarle un offset
		beq	$t0 $t5 asm_regs_vx
		beq  $t0 $t4 asm_regs_tx
		beq  $t0 $t3 asm_regs_sx		# aqui tambien evaluamos si es $sp
		beq  $t0 $t2 asm_regs_ra		# si es ra
		beq	$t0 $t1 asm_regs_zero
		j	asm_regs_error		# no es ninguno... error

	asm_regs_zero:		# caso trivial 
		li	$v0 0
		j	asm_regs_exit
		
	asm_regs_vx:
		jal	ascii_to_int
		addi	$v0 $v0 2
		j	asm_regs_exit

	asm_regs_ax:		# le pongo de base $a0 y sumo su offset
		lb 	$t0 0($s0)
		beq 	$t0 't' asm_regs_at	
		jal	ascii_to_int	# ($a0 = 4) => ($a3 - $a0) + 4 = 7
		addi	$v0 $v0 4
		j asm_regs_exit
	
	asm_regs_tx:
		jal	ascii_to_int
		addi	$v0 $v0 8
		j	asm_regs_exit
		
	asm_regs_sx:
		lb 	$t0 0($s0)
		beq 	$t0 'p' asm_regs_sp	 	#si es un sp devolvemos 29
		jal	ascii_to_int
		addi	$v0 $v0 16
		j	asm_regs_exit
	
	asm_regs_sp:
		addi $s0 $s0 1			# advance the char pointer
		li	$v0 29
		j	asm_regs_exit
	
	asm_regs_at:
		addi $s0 $s0 1			# advance the char pointer
		li	$v0 1
		j	asm_regs_exit
	
	asm_regs_ra:
		lb 	$t0 0($s0)
		bne 	$t0 'a' asm_regs_error 	#si no es ra devolvemos error
		addi $s0 $s0 1				# advance the char pointer
		li 	$v0 31
		j	asm_regs_exit

	asm_regs_exit:
		lw	$ra 0($sp)
		addi	$sp $sp 4
		jr	$ra

	asm_regs_error:
		addi	$sp $sp 4
		j	asm_error
     
     
     ######### asm_syscall #####################
     asm_syscall:			# esta instruccion es muy facil de codificar ;)
     	lw $s4 text_counter
		addi $s4 $s4 4
		sw $s4 text_counter
     
		la 	$t0 0x0000000c
		sw 	$t0 0($s1)
		addi $s1 $s1 4
		j 	asm_text_loop
     
     ######### ascii_to_int ####################
     ascii_to_int:     # the infamous atoi, with no validations!
      	li 	$t1 0		# init with zero
      	li 	$t2 '0'	
      	li 	$t3 '9'	
      	li 	$t4 10
     	li 	$v0 0

     ascii_to_int_loop:
		lb 	$t0 0($s0)
		beq 	$t0 $0  ascii_to_int_exit
		blt 	$t0 $t2 ascii_to_int_exit	# only accept numbers
		bgt 	$t0 $t3 ascii_to_int_exit	# only accept numbers
		addi $s0 $s0 1			# advance the char pointer
		addi $t0 $t0 -48		# get real number (without the '0' offset)
		mul  $v0 $v0 $t4		# multiply by 10
		add  $v0 $v0 $t0		# add real number
		j 	ascii_to_int_loop

   	ascii_to_int_exit:
		jr 	$ra
		
     ######### ascii_to_int_generic ####################
     ascii_to_int_generic:     # the infamous atoi, with no validations!
      	move $t5 $a0
      	li 	$t1 0		# init with zero
      	li 	$t2 '0'	
      	li 	$t3 '9'	
      	li 	$t4 10
     	li 	$v0 0

     ascii_to_int_generic_loop:
		lb 	$t0 0($t5)
		beq 	$t0 $0  ascii_to_int_generic_exit
		blt 	$t0 $t2 ascii_to_int_generic_exit	# only accept numbers
		bgt 	$t0 $t3 ascii_to_int_generic_exit	# only accept numbers
		addi $t5 $t5 1			# advance the char pointer
		addi $t0 $t0 -48		# get real number (without the '0' offset)
		mul  $v0 $v0 $t4		# multiply by 10
		add  $v0 $v0 $t0		# add real number
		j 	ascii_to_int_generic_loop

   	ascii_to_int_generic_exit:
		jr 	$ra
				
	######### int_to_ascii ####################
	
	int_to_ascii:
		move	$t4 $a0
		beqz	$t4 signed_is_zero
		add	$t5 $0 $0 #inicializamos nuestro contador a 0
		addi	$t6 $0 10 #asignamos a t6 la base 10
		bgtz	$t4 signed_not_negative
		addi	$t7 $0 '-'
		sb	$t7 0($s7) #guardamos el signo negativo en el resultado y corremos 1
		addi	$s7 $s7 1 
	
	signed_not_negative:
		abs	$t4 $t4 #sacamos el valor absoluto del numero
	
	whileSigned:
		beqz	$t4 endSigned
		div	$t4 $t6
		mflo	$t4
		mfhi	$t7 #guardamos el residuo en $t6
		addi	$sp $sp -1 #pedimos 1 en el stack para guardar el ascii del residuo
		addi	$t5 $t5 1 #sumamos 1 al contador para saber cuanto hemos corrido el stack
		addi	$t7 $t7 48 #sumamos 48 al residuo para convertirlo a ascii
		sb	$t7 0($sp)
		j	whileSigned
	
	endSigned:
						
	whileSignedChars:
		beqz	$t5 endSignedChars
		lb	$t7 0($sp) #cargamos el digito mas alto del numero
		sb	$t7 0($s7)
		addi	$sp $sp 1 #regresamos el $sp 1 posicion
		addi	$t5 $t5 -1 #restamos 1 al contador
		addi	$s7 $s7 1
		j whileSignedChars
	
	endSignedChars:
		j end_s_zero
						
	signed_is_zero: #si el numero es 0 solo agregamos el 0 a la respuesta
		addi	$t7 $0 48
		sb	$t7 0($s7)
	
	end_s_zero:
		jr $ra

	############# strcmp ####################
	strcmp:
		li	$t2 ' '
		li	$t3 '\n'
		li	$t4 '\t'

	strcmp_loop:
		lb	$t0 0($a0)
		lb 	$t1 0($a1)
		beq 	$t0 $t2 strcmp_true		# no es una letra (termina con espacio)
		beq 	$t0 $t3 strcmp_true		# no es una letra (termina con EOL)
		beq 	$t0 $t4 strcmp_true		# no es una letra (termina con tab)
		beq 	$t0 $0 strcmp_true       #fin de la cadena que se esta comparando
		bne 	$t0 $t1 strcmp_false	#es diferente
		addi $a0 $a0 1
		addi $a1 $a1 1
		j	strcmp_loop

	strcmp_true:
		move	$s0 $a0
		li 	$v0 1
		jr	$ra

	strcmp_false:
		li	$v0 0
		jr 	$ra

     ######### asm_label_check #################
     asm_label_check:			# verifica si la cadena es un label
		li $t1 ':'
		li $t2 ' '
		li $t3 10

	asm_label_loop:
		lb $t0 0($a0)
		addi $a0 $a0 1
		beq $t0 $t1 asm_label_true
		beq $t0 $t2 asm_label_false
		beq $t0 $t3 asm_label_false
		j asm_label_loop

     asm_label_true:
		#move $s0 $a0
		li $v0 1
		jr $ra

     asm_label_false:
		li $v0 0
		jr $ra
		
		
	################ copy_extract_reg2 ################
	copy_extract_reg2:
 		la	$t0 reg2
 		li	$t2 0 		#flag
 		li	$t3 '$'
 		li      $t4 ')'
 	copy_extract_reg2_loop:
 		lb 	$t1 0($t0)
 		addi	$t0 $t0 1
 		beqz	$t1 copy_extract_reg2_exit
 		beq	$t1 $t4 copy_extract_reg2_exit
 		beq	$t1 $t3 do_copy
 		bnez	$t2 do_copy
 		j	copy_extract_reg2_loop
 	do_copy:
 		li 	$t2 1
 		sb 	$t1 0($s7)
 		addi	$s7 $s7 1
 		j copy_extract_reg2_loop
 			
 	copy_extract_reg2_exit:
 		jr $ra
 	
 	############## string_contains_char #################
 	string_contains_char:
		li	$t3 '\n'
		li	$t4 '\t'
	string_contains_char_loop:
		lb 	$t0 0($a0)
		move	$t1 $a1
		beq 	$t0 $t3 str_contains_char_false		
		beq 	$t0 $t4 str_contains_char_false		
		beq 	$t0 $0 str_contains_char_false 
		beq	$t0 $t1 str_contains_char_true
		addi $a0 $a0 1
		j	string_contains_char_loop
	str_contains_char_true:
		li 	$v0 1
		jr	$ra
	str_contains_char_false:
		li	$v0 0
		jr 	$ra
		
		
	################ string_is_number ####################
	string_is_number:
		li	$t3 '\n'
	string_is_number_loop:
		lb 	$t0 0($a0)
		beq 	$t0 $t3 str_contains_char_true
		beq 	$t0 $0 str_contains_char_true
		li	$t1 '0'
		beq	$t1 $t0 continue_is_number
		li	$t1 '1'
		beq	$t1 $t0 continue_is_number
		li	$t1 '2'
		beq	$t1 $t0 continue_is_number
		li	$t1 '3'
		beq	$t1 $t0 continue_is_number
		li	$t1 '4'
		beq	$t1 $t0 continue_is_number
		li	$t1 '5'
		beq	$t1 $t0 continue_is_number
		li	$t1 '6'
		beq	$t1 $t0 continue_is_number
		li	$t1 '7'
		beq	$t1 $t0 continue_is_number
		li	$t1 '8'
		beq	$t1 $t0 continue_is_number
		li	$t1 '9'
		beq	$t1 $t0 continue_is_number
		j	str_contains_char_false
	continue_is_number:
		addi 	$a0 $a0 1
		j 	string_is_number_loop
		
	################ get_addr_from_st ####################
	get_addr_from_st:
		la $t0 symbol_table #cargamos la direccion inicial de la matriz
		add $t1 $0 $0 #inicializamos $t1 en la fila 0
		
		#para tener la posicion del arreglo alumnos_matriz[row][col] debemos multiplicar 4*(2*row+col) y sumarle la direccion inicial
		#donde 4 es el tamano de cada elemento, 2 la cantidad de columnas, row y col la fila y columna actual
	loop_addr:
		addi $t2 $0 2 #cantidad de columnas de la matriz
		addi $t3 $0 4 #tamanio de cada elemento del array, como son word lo ponemos a 4 bytes
		mult $t2 $t1 #multiplicamos cantidad de columnas por la fila actual
		mflo $t4 
		add $t4 $t4 1 #sumamos la columna de la cual queremos saber la direccion, en este caso es la columna 0
		mult $t4 $t3 #multiplicamos el size
		mflo $t4
		add $t4 $t0 $t4 #sumamos la direccion de la celda actual a la direccion inicial de la matriz
		
		lw $t5 0($t4)
		beq $t5 -1 end_loop_addr #si la posicion actual es -1 quiere decir que el alumno no existe
		add $t6 $0 $0 #inicializamos el length del argumento recibido a 0
		add $t7 $0 $0 #inicializamos el length del nombre guardado a 0
		add $t8 $a0 $0 #copiamos la direccion recibida en el argumento
		add $t9 $t5 $0 #copiamos la direccion actual del arreglo		
				
	loop_length1:
		lb $t2 0($t8) #cargamos el byte de la direccion recibida en el arg
		beqz $t2 end_loop_length1
		beq $t2 ' ' end_loop_length1
		beq $t2 '\n' end_loop_length1
		beq $t2 '#' end_loop_length1
		addi $t8 $t8 1 #corremos la direccion en 1
		addi $t6 $t6 1 #incrementamos el contador del a1 en 1
		j loop_length1
	
	end_loop_length1:
				
	loop_length2:
		lb $t2 0($t9) #cargamos el byte de la direccion actual del arreglo
		beqz $t2 end_loop_length2
		addi $t9 $t9 -1 #corremos la direccion en 1
		addi $t7 $t7 1 #incrementamos el contador del a1 en 1
		j loop_length2
				
	end_loop_length2:
		bne $t6 $t7 not_equal_strings #comparamos los length
		add $t8 $a0 $0 #copiamos la direccion recibida en el argumento
		add $t9 $t5 $0 #copiamos la direccion actual del arreglo
	
	loop_compare_strings:
		lb $t2 0($t8) #cargamos el byte de la direccion recibida en el arg
		lb $t3 0($t9) #cargamos el byte de la direccion actual del arreglo
		beqz $t2 equal_strings
		beq $t2 ' ' equal_strings
		beq $t2 '\n' equal_strings
		beq $t2 '#' equal_strings
		bne $t2 $t3 not_equal_strings	
		addi $t8 $t8 1
		addi $t9 $t9 -1
		j loop_compare_strings
	
	equal_strings:
		addi $t2 $0 2 #cantidad de columnas de la matriz
		addi $t3 $0 4 #tamanio de cada elemento del array, como son word lo ponemos a 4 bytes
		mul $t4 $t2 $t1 #multiplicamos cantidad de columnas por la fila actua
		add $t4 $t4 0 #sumamos la columna de la cual queremos saber la direccion, en este caso es la columna 0
		mul $t4 $t4 $t3 #multiplicamos el siz
		add $t4 $t0 $t4 #sumamos la direccion de la celda actual a la direccion inicial de la matriz
		move $s0 $t8
		lw $v0 0($t4)
		jr $ra
				
	not_equal_strings:
		addi $t1 $t1 1 #avanzamos de fila
		j loop_addr
	
	end_loop_addr:
		j asm_error
		add $v0 $0 -1
		jr $ra
