lui   x5,0x40000
addi  x5,x5,12

lui   x6,0x0C0A0
addi  x6,x6,6
sw    x6,0(x5)

lui   x6,0x0E000
addi  x6,x6,10
sw    x6,0(x5)

beq   x0,x0,0
//To Stop the Timer [15:0] in a control_word [32:0] should be zero rest all the bits same
//For now only 2 timer have been integrated.One is normal mode and another one is square mode
