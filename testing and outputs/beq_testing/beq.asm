addi x1, x0, 10
addi x2, x0, 10

beq  x1, x2, pass

addi x3, x0, 111

pass:
addi x4, x0, 222

beq x0, x0, 
