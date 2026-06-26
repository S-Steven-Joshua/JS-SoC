lui  x2,0x40000          # UART base

# "Hi!!"
lui  x1,0x48692
addi x1,x1,0x121
sw   x1,0(x2)

# "JSOC"
lui  x1,0x4A535
addi x1,x1,-189
sw   x1,0(x2)

# "RISC"
lui  x1,0x52495
addi x1,x1,0x343
sw   x1,0(x2)

# "DONE"
lui  x1,0x444F5
addi x1,x1,-443
sw   x1,0(x2)

beq  x0,x0,0
