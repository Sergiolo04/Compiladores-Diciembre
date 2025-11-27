.data
_c1: .word 0
_c2: .word 0
_a: .word 0
_b: .word 0
_c: .word 0
_d: .word 0
_e: .word 0
_x: .word 0
_y: .word 0
_z: .word 0
$str0: .asciiz "Inicio del programa de pruebas\n"
$str1: .asciiz "Introduce tres enteros (a, b, c):\n"
$str2: .asciiz "a es distinto de cero\n"
$str3: .asciiz "Rama if: a es no cero\n"
$str4: .asciiz "Rama else-if: a es cero, b es no cero\n"
$str5: .asciiz "Rama else: a y b son cero\n"
$str6: .asciiz "Valor actual de z: "
$str7: .asciiz "\n"
$str8: .asciiz "x = "
$str9: .asciiz "  d = "
$str10: .asciiz "\n"
$str11: .asciiz "Despues de a = b = c = 10:\n"
$str12: .asciiz "a = "
$str13: .asciiz "\n"
$str14: .asciiz "b = "
$str15: .asciiz "\n"
$str16: .asciiz "c = "
$str17: .asciiz "\n"
$str18: .asciiz "Fin del programa de pruebas\n"

.text
.globl main
main:
li $t0, 0
sw $t0, _c1
li $t0, 1
sw $t0, _c2
la $a0, $str0
li $v0, 4
syscall
la $a0, $str1
li $v0, 4
syscall
li $v0, 5
syscall
sw $v0, _a
li $v0, 5
syscall
sw $v0, _b
li $v0, 5
syscall
sw $v0, _c
lw $t0, _a
lw $t1, _b
li $t2, 2
mul $t1, $t1, $t2
add $t0, $t0, $t1
sw $t0, _d
lw $t0, _d
lw $t1, _c
sub $t0, $t0, $t1
li $t1, 2
div $t0, $t0, $t1
sw $t0, _e
lw $t0, _e
neg $t0, $t0
sw $t0, _x
lw $t0, _a
sw $t0, _e
li $t0, 3
sw $t0, _z
sw $t0, _y
sw $t0, _x
lw $t0, _c
li $t3, 1
add $t0, $t0, $t3
sw $t0, _b
sw $t0, _a
lw $t0, _x
li $t3, 2
mul $t0, $t0, $t3
sw $t0, _e
sw $t0, _d
lw $t0, _a
beqz $t0, $l1
la $a0, $str2
li $v0, 4
syscall
$l1:
lw $t0, _a
beqz $t0, $l4
la $a0, $str3
li $v0, 4
syscall
j $l5
$l4:
lw $t3, _b
beqz $t3, $l2
la $a0, $str4
li $v0, 4
syscall
j $l3
$l2:
la $a0, $str5
li $v0, 4
syscall
$l3:
$l5:
$l6:
lw $t0, _z
beqz $t0, $l7
la $a0, $str6
li $v0, 4
syscall
lw $t3, _z
move $a0, $t3
li $v0, 1
syscall
la $a0, $str7
li $v0, 4
syscall
lw $t3, _z
li $t4, 1
sub $t3, $t3, $t4
sw $t3, _z
j $l6
$l7:
li $t0, 5
sw $t0, _x
$l8:
lw $t0, _x
beqz $t0, $l9
la $a0, $str8
li $v0, 4
syscall
lw $t3, _x
move $a0, $t3
li $v0, 1
syscall
la $a0, $str9
li $v0, 4
syscall
lw $t3, _d
move $a0, $t3
li $v0, 1
syscall
la $a0, $str10
li $v0, 4
syscall
lw $t3, _d
lw $t4, _x
add $t3, $t3, $t4
sw $t3, _d
lw $t3, _x
li $t4, 1
sub $t3, $t3, $t4
sw $t3, _x
j $l8
$l9:
li $t0, 10
sw $t0, _c
sw $t0, _b
sw $t0, _a
la $a0, $str11
li $v0, 4
syscall
la $a0, $str12
li $v0, 4
syscall
lw $t0, _a
move $a0, $t0
li $v0, 1
syscall
la $a0, $str13
li $v0, 4
syscall
la $a0, $str14
li $v0, 4
syscall
lw $t0, _b
move $a0, $t0
li $v0, 1
syscall
la $a0, $str15
li $v0, 4
syscall
la $a0, $str16
li $v0, 4
syscall
lw $t0, _c
move $a0, $t0
li $v0, 1
syscall
la $a0, $str17
li $v0, 4
syscall
la $a0, $str18
li $v0, 4
syscall
li $v0, 10
syscall
