inicio:
li x6, 1
jal x1, delay
jal x1, delay
li x6, 0
jal x1, delay
j inicio



delay:
li x2, 16

loop:
addi x2, x2, -1
beq x2, x0, return
j loop

return:
addi x0, x0, 0
jr x1
