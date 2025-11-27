.data
_a: .word 0
_b: .word 0

.text
.globl main
main:
li $t0, 5
sw $t0, _a
lw $t0, _a
li $t1, 2
add $t0, $t0, $t1
sw $t0, _b
lw $t0, _a
move $a0, $t0
li $v0, 1
syscall
lw $t0, _b
move $a0, $t0
li $v0, 1
syscall
li $v0, 10
syscall
