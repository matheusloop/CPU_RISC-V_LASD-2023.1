loop:
lw s0, 0xFC(x0) #Pega do usu�rio
sw s0, 0xFC(x0) #Envia para o LCD
j loop