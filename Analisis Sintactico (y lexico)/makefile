# ==========================
# COMPILACIÓN PRINCIPAL
# ==========================

analizador: main.c lex.yy.c sintaxis.tab.c listaSimbolos.c listaCodigo.c
	gcc -g main.c lex.yy.c sintaxis.tab.c listaSimbolos.c listaCodigo.c -lfl -o analizador

lex.yy.c: lexico.l sintaxis.tab.h
	flex lexico.l

sintaxis.tab.c sintaxis.tab.h: sintaxis.y
	bison -d -v sintaxis.y

clean:
	rm -f analizador lex.yy.c sintaxis.tab.* sintaxis.output output.asm

# ==========================
# EJECUCIÓN BÁSICA
# ==========================

compilar: analizador programa_minic.txt
	./analizador < programa_minic.txt

ejecutar: analizador programa_minic.txt
	./analizador < programa_minic.txt && java -jar Mars.jar output.asm


# ===================================================
#    OBJETIVOS PARA PROBAR FICHEROS DE ERROR
# ===================================================

error_constantes: analizador errores_constantes_y_variables.txt
	./analizador < errores_constantes_y_variables.txt

error_comentarios: analizador error_comentario_no_cerrado.txt
	./analizador < error_comentario_no_cerrado.txt

error_cadenas: analizador error_cadena_no_cerrada.txt
	./analizador < error_cadena_no_cerrada.txt

error_sintaxis: analizador error_sintaxis_general.txt
	./analizador < error_sintaxis_general.txt

