li s0, 0x03E
sw s0, 0xFC(x0) 

#Linha 1
li s0, 0x6874614D
li s1, 0x20737565
li s2, 0x6163754C
li s3, 0x21212073

sw s0, 0x0(x0)
sw s1, 0x4(x0)
sw s2, 0x8(x0)
sw s3, 0xC(x0)

#Linha 2
li s4, 0x414C2020
li s5, 0x32204453
li s6, 0x2e333230
li s7, 0x20202131

sw s4, 0x10(x0)
sw s5, 0x14(x0)
sw s6, 0x18(x0)
sw s7, 0x1C(x0)


#Formata
li t0, 0xFF

#Previou
li t1, 0x100

#Next
li t2, 0x200

#Contador
li a0, 0
li a1, 0x1F

loop:
lb s0, 0x0(a0)  #Lê
and s0, s0, t0  #Formata
sw s0, 0xFC(x0) #Envia
add s0, s0, t2  #Next
sw s0, 0xFC(x0) #Envia
addi a0, a0, 1
bne a0, a1, loop

nothing:
j nothing
