main:
    li a1, 1 # lfsr result
    li a2, 0xff # all lights on
    li a0, 0
lfsr:
    slli t2, a1, 1
    srli t1, t2, 3
    srli t3, t2, 4
    xor t1, t3, t1
    andi t1, t1, 1
    xor t2, t1, t2
    andi a1, t2, 0xf
    beq t6, zero, lfsr
lights:
    jal delay
    slli t1, a0, 1
    addi a0, t1, 1
    bne a0, a2, lights
wait:
    addi a1, a1, -1
    beq a1, zero, stop
    jal delay
    beq zero, zero, wait
stop:
    li a0, 0
    beq zero, a0, stop

delay:
    li t3, 0x100
loop:
    addi t3, t3, -1
    bne t3, zero, loop
    ret
    