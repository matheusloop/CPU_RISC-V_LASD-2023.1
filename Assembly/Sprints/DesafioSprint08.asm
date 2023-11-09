# ----> VERSÃO 02 <---- #
inicio:
lb x1, 0xFF(x0)

ON:
bnez x2, OFF
li x3, 1

OFF:
bne x2, x1, fim
li x3, 0

fim:
addi x2, x2, 1
sb x3, 0xFF(x0)
j inicio