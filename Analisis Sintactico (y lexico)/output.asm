.data
_a: 	.word 0
_b: 	.word 0
_c: 	.word 0
_d: 	.word 0
_e: 	.word 0
$str0: .asciiz "Inicio del programa\n"
$str1: .asciiz "a"
$str2: .asciiz "\n"
$str3: .asciiz "No a y b\n"
$str4: .asciiz "c = "
$str5: .asciiz "\n"
$str6: .asciiz "Final de If/While\n"
$str7: .asciiz "Asignaciones múltiples:\n"
$str8: .asciiz "c = "
$str9: .asciiz "\n"
$str10: .asciiz "d = "
$str11: .asciiz "\n"
$str12: .asciiz "e = "
$str13: .asciiz "\n"
$str14: .asciiz "Tras c = d = e = c + 5:\n"
$str15: .asciiz "c = "
$str16: .asciiz "\n"
$str17: .asciiz "d = "
$str18: .asciiz "\n"
$str19: .asciiz "e = "
$str20: .asciiz "\n"
$str21: .asciiz "\n--- PRUEBA DE EXPRESIÓN NEGADA ---\n"
$str22: .asciiz "d = "
$str23: .asciiz "\n"
$str24: .asciiz "e = -d: "
$str25: .asciiz "\n"
$str26: .asciiz "e + 5 = "
$str27: .asciiz "\n"
$str28: .asciiz "d = -(e + 5): "
$str29: .asciiz "\n"
$str30: .asciiz "\n--- PRUEBA DE TERNARIA (A ? B : C) ---\n"
$str31: .asciiz "e = (0 ? 100 : 200): "
$str32: .asciiz "\n"
$str33: .asciiz "e = (1 ? 100 : 200): "
$str34: .asciiz "\n"
$str35: .asciiz "e = (d ? (c + 5) : (c - 5)): "
$str36: .asciiz "\n"
$str37: .asciiz "\n--- PRUEBA DE LECTURA ---\n"
$str38: .asciiz "Introduce un nuevo valor para c:\n"
$str39: .asciiz "Nuevo valor de c = "
$str40: .asciiz "\n"

.text
.globl main
main:
li $t0, 0
sw $t0, _a
li $t0, 0
sw $t0, _b
la $a0, $str0
li $v0, 4
syscall
li $t0, 5
li $t1, 2
add $t0, $t0, $t1
li $t1, 2
sub $t0, $t0, $t1
sw $t0, _c
lw $t0, _a
beqz $t0, $l5
la $a0, $str1
li $v0, 4
syscall
la $a0, $str2
li $v0, 4
syscall
j $l6
$l5:
lw $t1, _b
beqz $t1, $l3
la $a0, $str3
li $v0, 4
syscall
j $l4
$l3:
$l1:
lw $t2, _c
beqz $t2, $l2
la $a0, $str4
li $v0, 4
syscall
lw $t3, _c
move $a0, $t3
li $v0, 1
syscall
la $a0, $str5
li $v0, 4
syscall
lw $t3, _c
li $t4, 2
sub $t3, $t3, $t4
li $t4, 1
add $t3, $t3, $t4
sw $t3, _c
j $l1
$l2:
$l4:
$l6:
la $a0, $str6
li $v0, 4
syscall
li $t0, 10
sw $t0, _e
sw $t0, _d
sw $t0, _c
la $a0, $str7
li $v0, 4
syscall
la $a0, $str8
li $v0, 4
syscall
lw $t0, _c
move $a0, $t0
li $v0, 1
syscall
la $a0, $str9
li $v0, 4
syscall
la $a0, $str10
li $v0, 4
syscall
lw $t0, _d
move $a0, $t0
li $v0, 1
syscall
la $a0, $str11
li $v0, 4
syscall
la $a0, $str12
li $v0, 4
syscall
lw $t0, _e
move $a0, $t0
li $v0, 1
syscall
la $a0, $str13
li $v0, 4
syscall
lw $t0, _c
li $t1, 5
add $t0, $t0, $t1
sw $t0, _e
sw $t0, _d
sw $t0, _c
la $a0, $str14
li $v0, 4
syscall
la $a0, $str15
li $v0, 4
syscall
lw $t0, _c
move $a0, $t0
li $v0, 1
syscall
la $a0, $str16
li $v0, 4
syscall
la $a0, $str17
li $v0, 4
syscall
lw $t0, _d
move $a0, $t0
li $v0, 1
syscall
la $a0, $str18
li $v0, 4
syscall
la $a0, $str19
li $v0, 4
syscall
lw $t0, _e
move $a0, $t0
li $v0, 1
syscall
la $a0, $str20
li $v0, 4
syscall
la $a0, $str21
li $v0, 4
syscall
li $t0, 20
sw $t0, _d
lw $t0, _d
li $t1, 0
sub $t0, $t1, $t0
sw $t0, _e
la $a0, $str22
li $v0, 4
syscall
lw $t0, _d
move $a0, $t0
li $v0, 1
syscall
la $a0, $str23
li $v0, 4
syscall
la $a0, $str24
li $v0, 4
syscall
lw $t0, _e
move $a0, $t0
li $v0, 1
syscall
la $a0, $str25
li $v0, 4
syscall
lw $t0, _e
li $t1, 5
add $t0, $t0, $t1
li $t1, 0
sub $t0, $t1, $t0
sw $t0, _d
la $a0, $str26
li $v0, 4
syscall
lw $t0, _e
li $t1, 5
add $t0, $t0, $t1
move $a0, $t0
li $v0, 1
syscall
la $a0, $str27
li $v0, 4
syscall
la $a0, $str28
li $v0, 4
syscall
lw $t0, _d
move $a0, $t0
li $v0, 1
syscall
la $a0, $str29
li $v0, 4
syscall
la $a0, $str30
li $v0, 4
syscall
li $t0, 0
sw $t0, _c
li $t0, 1
sw $t0, _d
lw $t0, _c
beqz $t0, $l7
li $t1, 100
move $t3, $t1
j $l8
$l7:
li $t2, 200
move $t3, $t2
$l8:
sw $t3, _e
la $a0, $str31
li $v0, 4
syscall
lw $t0, _e
move $a0, $t0
li $v0, 1
syscall
la $a0, $str32
li $v0, 4
syscall
lw $t0, _d
beqz $t0, $l9
li $t1, 100
move $t3, $t1
j $l10
$l9:
li $t2, 200
move $t3, $t2
$l10:
sw $t3, _e
la $a0, $str33
li $v0, 4
syscall
lw $t0, _e
move $a0, $t0
li $v0, 1
syscall
la $a0, $str34
li $v0, 4
syscall
lw $t0, _d
beqz $t0, $l11
lw $t1, _c
li $t2, 5
add $t1, $t1, $t2
move $t3, $t1
j $l12
$l11:
lw $t2, _c
li $t3, 5
sub $t2, $t2, $t3
move $t3, $t2
$l12:
sw $t3, _e
la $a0, $str35
li $v0, 4
syscall
lw $t0, _e
move $a0, $t0
li $v0, 1
syscall
la $a0, $str36
li $v0, 4
syscall
la $a0, $str37
li $v0, 4
syscall
la $a0, $str38
li $v0, 4
syscall
li $v0, 5
syscall
sw $v0, _c
la $a0, $str39
li $v0, 4
syscall
lw $t0, _c
move $a0, $t0
li $v0, 1
syscall
la $a0, $str40
li $v0, 4
syscall
li $v0, 10
syscall
# Código generado por mi compilador MiniC
