# UART Base = 0x40000000
lui   x10,0x40000

# Send "Hi!!"
lui   x11,0x48692
addi  x11,x11,289
sw    x11,0(x10)

# PWM Base = 0x40000008
addi  x10,x10,8

# PWM = Period 10 Duty 3
lui   x11,0x000A0
addi  x11,x11,3
sw    x11,0(x10)

# Timer Base = 0x4000000C
addi  x10,x10,4

# Timer 1
lui   x11,0x0C0A0
addi  x11,x11,6
sw    x11,0(x10)

# Timer 2
lui   x11,0x0E000
addi  x11,x11,10
sw    x11,0(x10)

# -------- CPU Operations --------

addi  x1,x0,15
addi  x2,x0,20
add   x3,x1,x2
sub   x4,x3,x1
add   x5,x3,x4
addi  x6,x5,-10

beq   x0,x0,0
