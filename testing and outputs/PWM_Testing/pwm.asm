lui   x5,0x40000
addi  x5,x5,8

lui   x6,0x00020
addi  x6,x6,1
sw    x6,0(x5)

# 40 NOPs

addi  x6,x0,0
sw    x6,0(x5)

beq   x0,x0,0
