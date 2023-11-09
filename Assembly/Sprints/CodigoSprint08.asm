init:
lb x1, 0xFF(x0)
andi x2, x1, 1
slti x3, x2, 1
sb x3, 0xFF(x0) 
beq x0, x0, init