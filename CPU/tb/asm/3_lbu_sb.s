.text
.globl main
main:
    li s0, 0x00010000
    li t1, 100
    sb t1, 0(s0)
    lbu a0, 0(s0)
    addi a0, a0, 200
    bne     a0, zero, finish
finish:
    bne     a0, zero, finish
    