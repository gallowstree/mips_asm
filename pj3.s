.data
	##############PROGRAMA A CODIFICAR################
	programa: .asciiz "ori $a0 $0 10\n"
		  .asciiz "ori $v0 $0 1\n"
		  .asciiz "syscall\n"
		  .asciiz "ori $v0 $0 10\n"
		  .asciiz "syscall"
	##################################################
	
.align 2
	data: .space 200 #data del programa
	text: .space 400 #espacio para programa compilado

.text
	main:
		la	$a0 programa
		la	$a1 text
		la	$a2 data
		jal	ensamblador	
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
	.text	
		#backup a la memoria
		addi	$sp $sp -44
		sw	$a2 40($sp)
		sw	$a1 36($sp)
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
		move $s1 $a1
		move $s3 $sp
		li	$s4 ' '
		li 	$s5 '\n'
		li	$s6 '\t'
		
	asm_text_loop:
		lb	$t0 0($s0)			#primer caracter
		addi	$s0 $s0 1				#direccion del caracter siguiente
		beq	$t0 $0 asm_exit		#fin del codigo?
		beq 	$t0 $s4 asm_text_loop	#espacio en blanco
		beq 	$t0 $s5 asm_text_loop	#newline
		beq	$t0 $s6 asm_text_loop	#tab
		beq	$t0 '.' asm_get_punto	#obtener instrucciones que empiezan con .
		beq	$t0 'a' asm_get_a		#obtener instrucciones que empiezan con a
		beq	$t0 'b' asm_get_b		#obtener instrucciones que empiezan con b
		beq	$t0 'd' asm_get_d		#obtener instrucciones que empiezan con d
		beq	$t0 'j' asm_get_j		#obtener instrucciones que empiezan con j
		beq	$t0 'l' asm_get_l		#obtener instrucciones que empiezan con l
		beq	$t0 'm' asm_get_m		#obtener instrucciones que empiezan con m
		beq	$t0 'n' asm_get_n		#obtener instrucciones que empiezan con n
		beq	$t0 'o' asm_get_o		#obtener instrucciones que empiezan con o
		beq	$t0 'r' asm_get_r		#obtener instrucciones que empiezan con r
		beq	$t0 's' asm_get_s		#obtener instrucciones que empiezan con s
		j asm_error
		
		
	asm_get_punto:
		addi $s0 $s0 -1
		
		move $a0 $s0
		la   $a1 str_asciiz
		jal	strcmp
		bnez	$v0 asm_asciiz
		
		move	$a0 $s0
		la	$a1 str_data
		jal	strcmp
		bnez	$v0 asm_data
		
		move	$a0 $s0
		la	$a1 str_text
		jal	strcmp
		bnez $v0 asm_text
		
		j asm_error	

	asm_get_a:
		addi	$s0 $s0 -1 	#regresamos a un espacio de memoria anterior para comparar las instrucciones  		
		
		#move	$a0 $s0		#verificamos si la instruccion es abs
		#la 	$a1 str_abs
		#jal 	strcmp
		#bne 	$v0 $0 asm_abs

		move	$a0 $s0
		la	$a1 str_add
		jal	strcmp
		li 	$s7 0x20
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
		bnez $v0 asm_i_type
		
		#move	$a0 $s0
		#la	$a1 str_bgt
		#jal	strcmp
		#bnez $v0 asm_bgt
		
		#move	$a0 $s0
		#la	$a1 str_bgtz
		#jal	strcmp
		#bnez $v0 asm_bgtz
		
		#move	$a0 $s0
		#la	$a1 str_blt
		#jal	strcmp
		#bnez $v0 asm_blt
		
		move	$a0 $s0
		la	$a1 str_bne
		jal	strcmp
		li 	$s7 0x05
		bnez $v0 asm_i_type
		
		j 	asm_error
		
	asm_get_d:
		addi	$s0 $s0 -1 	#regresamos a un espacio de memoria anterior para comparar las instrucciones  		
		
		#move	$a0 $s0		#verificamos si la instruccion es abs
		#la	$a1 str_div
		#jal	strcmp
		#bnez $v0 asm_div
		
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
		bnez $v0 asm_r_type
		
		j	asm_error
	asm_get_l:
		addi	$s0 $s0 -1 	#regresamos a un espacio de memoria anterior para comparar las instrucciones  		
		
		#move	$a0 $s0		#verificamos si la instruccion es abs
		#la	$a1 str_la
		#jal	strcmp
		#bnez $v0 asm_la
		
		#move	$a0 $s0
		#la	$a1 str_li
		#jal	strcmp
		#bnez $v0 asm_li
		
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
		
		#move	$a0 $s0
		#la	$a1 str_move
		#jal	strcmp
		#bnez $v0 asm_move
		
		#move	$a0 $s0
		#la	$a1 str_mul
		#jal	strcmp
		#bnez $v0 asm_mul
		
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
		
		j asm_error
		
	asm_get_n:
		addi	$s0 $s0 -1 	#regresamos a un espacio de memoria anterior para comparar las instrucciones  		
		
		#move	$a0 $s0	
		#la	$a1 str_neg
		#jal	strcmp
		#bnez $v0 asm_neg
		
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
		
		j asm_error
	
	asm_get_r:
		addi	$s0 $s0 -1 	#regresamos a un espacio de memoria anterior para comparar las instrucciones  		
		
		#move	$a0 $s0	
		#la	$a1 str_rol
		#jal	strcmp
		#bnez $v0 asm_rol
		
		#move	$a0 $s0	
		#la	$a1 str_ror
		#jal	strcmp
		#bnez $v0 asm_ror
		
		j asm_error
	
	asm_get_s:
		addi	$s0 $s0 -1 	#regresamos a un espacio de memoria anterior para comparar las instrucciones  		
		
		#move	$a0 $s0	
		#la	$a1 str_seq
		#jal	strcmp
		#bnez $v0 asm_seq
		
		move	$a0 $s0	
		la	$a1 str_sll
		jal	strcmp
		li 	$s7 0x20
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
		
		#move	$a0 $s0	
		#la	$a1 str_sne
		#jal	strcmp
		#bnez $v0 asm_sne

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
		
		j asm_error
		
		asm_asciiz:
			j exit
		asm_data:
			j exit
		asm_text:
			j exit
		asm_r_type:
			j exit
		
		asm_i_type:
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
		
		asm_j_type:
			j exit
	asm_data_loop:				#TO DO
		addi	$s0 $s0 -1 		#regresamos a un espacio de memoria anterior para comparar las instrucciones  		
		
		j asm_error			# :(
	
	
	
	asm_error:
		addi	$s0 $s0 -1 		#regresamos a un espacio de memoria anterior para comparar las instrucciones  		
		
		j asm_error			#TO DO :(
		
	asm_exit:					#resettear el backup
		lw	$a2 40($sp)
		lw	$a1 36($sp)
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
		
	
     ############# asm_regs ####################

	asm_regs:					# pasa de $AN -> N ej. $s0 -> 16
		addi $sp $sp -4		# por supuesto que esta incompleto...
		sw 	$ra 0($sp)
		li 	$t7 '$'			# voy a utilizarlo para verificar que viene un registro
		li	$t6 'a'			# aX -> argumentos
		li	$t5 'v'			# vX -> valores de retorno
		li	$t4 '0'			# cero
	
		lb 	$t0 0($s0)
		addi	$s0 $s0 1
		bne 	$t0 $t7 asm_regs_error	# si no empieza con $ no es valido
		lb	$t0 0($s0)
		addi	$s0 $s0 1
		beq	$t0 $t6 asm_regs_ax		# verifico a que grupo pertence para sumarle un offset
		beq	$t0 $t5 asm_regs_vx
		beq	$t0 $t4 asm_regs_zero
		j	asm_regs_error		# no es ninguno... error

	asm_regs_zero:		# caso trivial 
		li	$v0 0
		j	asm_regs_exit

	asm_regs_ax:		# le pongo de base $a0 y sumo su offset
		jal	ascii_to_int	# ($a0 = 4) => ($a3 - $a0) + 4 = 7
		addi	$v0 $v0 4
		j asm_regs_exit

	asm_regs_vx:
		jal	ascii_to_int
		addi	$v0 $v0 2
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
