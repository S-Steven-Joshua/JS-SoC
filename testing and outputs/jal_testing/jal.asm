addi x1, x0, 1

jal x0, target

addi x2, x0, 2

target:
addi x3, x0, 3

beq x0, x0, target
