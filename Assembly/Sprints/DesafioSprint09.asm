inicio:
li x1, 1 #Acende LED

jal x7, delay #Espera 1s
jal x7, delay #Espera 1s

li x3, 0    #Inicializa contador
li x4, 0xFF #Condição de parada

li x1, 0 #Apaga LED

contador:
lb x5, 0xFF(x0)
beq x5, x0, fim
addi x3, x3, 1
bne x3, x4, contador

fim:
li x5, 1 #Reinicia a entrada
sb x3, 0xFF(x0) #Mostra o tempo de reação

jal x7, delay
jal x7, delay

j inicio



#SUB-ROTINA DE DELAY
delay:
li x2, 250

loop:
addi x2, x2, -1
nop
nop
bne x2, x0 loop

jalr x0, x7, 0
