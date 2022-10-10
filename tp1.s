.data
vetor: .word 1 2 3 4 5 6 7
.text
main:
la x12, vetor # ele ta lendo a primeira posiçao do vetor?? 
addi x13, x0, 7 # x13 = tamanho do vetor 
addi x13, x13, -1 # x13 = 6
slli x13, x13, 2 # x13 = 24 
add x13, x13, x12 # pq??? 
jal x1, inverte 
beq x0, x0, FIM
##### START MODIFIQUE AQUI START #####
# minha teoria: 
# x12 = inicio do vetor
# x13 = fim do vetor
inverte: 
    lw x5, x12 # x5 = x12 
    lw x6, x13 # x6  = x13
    bge x12, x13, FIM
    sw x5, 0(x13) 
  	sw x6, 0(x12) 
    addi x12, x12, 8
    addi x13, x13, -8
	jalr x0, 0(x1)
##### END MODIFIQUE AQUI END #####
FIM: add x1, x0, x10