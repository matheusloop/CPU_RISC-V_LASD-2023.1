addi x1, x0, 0xAB
sb x1, 0xA(x0)
lb x2, 0xA(x0)
sb x2, 0xB(x0)
lb x3, 0xB(x0)
sb x3, 0xC(x0)
lb x4, 0xC(x0)