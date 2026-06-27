# -------------------------------
# CPU Functional Verification
# -------------------------------

# x1 = 0x12345064
lui   x1, 0x12345
addi  x1, x1, 100

# x2 = 20
addi  x2, x0, 20

# x3 = x1 + x2
add   x3, x1, x2

# x4 = x3 - x2 (= x1)
sub   x4, x3, x2

# Store x3 to memory
sw    x3, 0(x0)

# Load it back into x5
lw    x5, 0(x0)

# If equal, skip next instruction
beq   x3, x5, pass

# Should never execute
addi  x6, x0, 111

pass:

# Jump over next instruction
jal   x0, end

# Should never execute
addi  x7, x0, 222

end:

# Infinite loop
beq   x0, x0, end
