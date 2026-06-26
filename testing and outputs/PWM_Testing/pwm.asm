lui   x5,0x40000
addi  x5,x5,8

lui   x6,0x00640
addi  x6,x6,20

sw    x6,0(x5)

beq   x0,x0,0

// 1MHz 20% duty cycle
//to stop write 0 to the control word
