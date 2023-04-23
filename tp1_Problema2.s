.data
vetor: .word  7 3 7 1 4 5 8 6 0 0 0 1 2 0
##### START MODIFIQUE AQUI START #####
##### END MODIFIQUE AQUI END #####
.text
main:
    la x12, vetor # carrega o vetor
    addi x13, x0, 11 # x13 = tamanho do vetor
    addi x14, x0, 1 # x14 = indica se é cpf ou cnpj 0 = cpf, 1 = cnpj 
    jal x1, verificadastro
    beq x0,x0,FIM
    ##### START MODIFIQUE AQUI START #####
retorna0: 
 	addi x10, x0, 0 
    jalr x0, 0(x1) 
soma: 
	mul x5, x5, x7 # multiplica o digito por k 
    add x11, x5, x11 # soma em x11 
	addi x7, x7, -1 # diminui o k 
    addi x12, x12, 4 # passa para o proximo digito
    lw x5, 0(x12)  # carrega o digito 
    bge x7, x6,  soma # repete enquanto k for menor ou igual a 2 
	jalr x0, 0(x1) 
    
verificacpf: 
    # x10 = valor 0 ou 1 de retorno que indica se o cpf é válido ou nao 
    # x11 = armazena a soma 
    # x7 - numero pelo qual vamos multiplicar o digito 
    
	lw x5, 0(x12) # carrega o primeiro digito em x5 
    # lw x6, 0(x13)
    addi, x10, x0, 1 # se o cpf for invalido, esse valor será setado para 0 
    
	#### SOMA DOS 9 PRIMEIROS DIGITOS #### 
    addi x7, x0, 10   # numero k pelo qual vamos multiplicar o digito 
    addi x6, x0, 2 	  # usado pra controlar o k. Enquanto k for maior que 2 ... repita
    sw x17 0(x1)  # salvando o endereco de x1 
    jal x1 soma   # soma os 9 primeiro digitos vezes o k 
    lw x1 0(x17) 
   
    # Verificando o digito  
    addi x5, x0, 11 # usado pra calcular o resto por 11 
    addi x7, x0, 10 # usado pra multiplicar a soma por 10 
    mul x16, x11, x7 # soma * 10 
    rem x16, x16, x5 # (soma * 10) % 11 
    la x12, vetor
    lw x5 ,36(x12) # carrega o primeiro digito verificador 
    bne x16, x5 retorna0 
    
    ### SOMA DOS 10 PRIMEIROS DIGITOS 
    addi x11, x0, 0 # reseta x11 para somar o novo valor
    addi x7, x0, 11   # numero k pelo qual vamos multiplicar o digito 
    addi x6, x0, 2 	  # usado pra controlar o k. Enquanto k for maior que 2 ... repita
    sw x17 0(x1) # guarda o endereço de x1 
    jal x1, soma
    lw x1 0(x17) # carrega o antigo endereço de x1 
    
    # Verificando o digito 
    addi x5, x0, 11 
    addi x7, x0, 10 
    mul x16, x11, x7
    rem x16, x16, x5 
    la x12, vetor 
    lw x5, 40(x12) 
    bne x16, x5, retorna0 
    jalr x0, 0(x1) 
    
    
calcula_digito_cnpj: 
	blt x16, x6, seta0
	addi x5, x0, 11 
    sub x16, x5, x16 
    jalr x0, 0(x1) 
    
seta0: 
	addi x16, x0, 0 
    jalr x0, 0(x1) 

verificacnpj: 

	### VERIFICAÇÃO DO PRIMEIRO DÍGITO ### 
    lw x5, 0(x12) # carrega o primeiro digito em x5 
    addi, x10, x0, 1 # se o cpf for invalido, esse valor será setado para 0 
    
    # soma com os pesos 5, 4, 3, 2
    addi x7, x0, 5   # numero k pelo qual vamos multiplicar o digito
    addi x6, x0, 2 	 # usado pra controlar o k. Enquanto k for maior que 2 ... repita
    sw x17 0(x1)  # salvando o endereco de x1 
    jal x1 soma   # soma os 9 primeiro digitos vezes o k 
    lw x1 0(x17) 
    
    # soma com os pesos 9, 8, 7, 6, 5, 4, 3, 2
    addi x7, x0, 9 
    addi x6, x0, 2
    sw x17 0(x1)  # salvando o endereco de x1 
    jal x1 soma   # soma os 9 primeiro digitos vezes o k 
    lw x1 0(x17) 
    
    # verificando o dígito 
    addi x5, x0, 11    # usado pra calcular o resto da soma por 11 
    rem x16, x11, x5   # calculando o resto 
    sw x17 0(x1)
    jal x1, calcula_digito_cnpj 
    lw x1 0(x17) 
    
    
    la x12, vetor 
    lw x5, 48(x12)    # carrega o primeiro digito verificador 
    bne x16, x5, retorna0 # se o digito nao bater, entao o cnpj nao é valido 
    
    ### VERIFICAÇÃO DO SEGUNDO DÍGITO ### 
    lw x5, 0(x12) # carrega o primeiro digito em x5 
    addi x11, x0, 0 # reseta o x11 para armazenar a nova soma
    
    # soma com os pesos 6,5,4,3,2
    addi x7, x0, 6 
    addi x6, x0, 2
    sw x17 0(x1)  # salvando o endereco de x1 
    jal x1 soma   # soma os 9 primeiro digitos vezes o k 
    lw x1 0(x17) 
    
    # soma com os pesos 9,8,7,6,5,4,3,2
    addi x7, x0, 9 
    addi x6, x0, 2
    sw x17 0(x1)  # salvando o endereco de x1 
    jal x1 soma   # soma os 9 primeiro digitos vezes o k 
    lw x1 0(x17) 
    
    # verificando o dígito 
    addi x5, x0, 11    # usado pra calcular o resto da soma por 11 
    rem x16, x11, x5   # calculando o resto  
    sw x17 0(x1)
    jal x1, calcula_digito_cnpj 
    lw x1 0(x17) 
    
    la x12, vetor 
    lw x5, 52(x12)    # carrega o segundo digito verificador 
    bne x16, x5, retorna0 # se o digito nao bater, entao o cnpj nao é valido 

	jalr x0, 0(x1)
    
verificadastro:
    beq x14, x0, verificacpf
    addi x5, x0, 1
    beq x14, x5, verificacnpj
	jalr x0, 0(x1)
 
	##### END MODIFIQUE AQUI END #####
	FIM: add x1, x0, x10