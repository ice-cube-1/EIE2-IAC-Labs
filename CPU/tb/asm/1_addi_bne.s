.text
.globl main

main:
    addi    t1, zero, 0xff      # t1 = 255
    addi    a0, zero, 0x0       # output = 0

mloop:
    addi    a1, zero, 0x0       # i = 0

iloop:
    addi    a0, a1, 0           # output = i
    nop                         # RAW hazard (a1 -> a0)
    nop

    addi    a1, a1, 1           # i++
    nop                         # RAW hazard (a1 -> branch)
    nop

    bne     a1, t1, iloop       # if i != 255, goto iloop
    nop                         # control hazard
    nop

    bne     a0, zero, finish    # enter finish state
    nop                         # RAW + control hazard
    nop

finish:                          # expected result is 254
    bne     a0, zero, finish
    nop                         # control hazard
    nop
