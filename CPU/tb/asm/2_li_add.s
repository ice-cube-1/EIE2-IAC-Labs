.text
.globl main

main:
    # t1 = -9000
    lui     t1, 1048574          # t1 = -8192
    nop
    nop
    addi    t1, t1, -808    # t1 = -9000
    nop
    nop

    # t2 = 10000
    lui     t2, 2           # t2 = 8192
    nop
    nop
    addi    t2, t2, 1808    # t2 = 10000
    nop
    nop

    # a0 = t1 + t2
    add     a0, t1, t2      # a0 = 1000
    nop
    nop

    bne     a0, zero, finish
    nop
    nop

finish:
    bne     a0, zero, finish
    nop
    nop
