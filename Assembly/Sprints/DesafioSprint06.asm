li x1, 0xf

addi x2, x0, 1  # Coloca 1 em x2 
and x3, x1, x2  # Pega o primeiro digito de x1
slt x3, x0, x3  # Verifica se x1 tem 1 na posicao 1
add x7, x7, x3  # Adciona 1 a x7 se tiver

add x2, x2, x2  # Desloca x2 para a esquerda
and x3, x1, x2  # Pega o segundo digito de x1
slt x3, x0, x3  # Verifica se x1 tem 1 na posicao 2
add x7, x7, x3  # Adciona 1 a x7 se tiver

add x2, x2, x2  # Desloca x2 para a esquerda
and x3, x1, x2  # Pega o terceiro digito de x1
slt x3, x0, x3  # Verifica se x1 tem 1 na posicao 3
add x7, x7, x3  # Adciona 1 a x7 se tiver

add x2, x2, x2  # Desloca x2 para a esquerda
and x3, x1, x2  # Pega o quarto digito de x1
slt x3, x0, x3  # Verifica se x1 tem 1 na posicao 4
cinco: add x7, x7, x3  # Adciona 1 a x7 se tiver

j cinco